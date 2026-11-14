import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/auth_redirect.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/presence/presencia_service.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import '../../domain/entities/rol.dart';
import '../../domain/entities/sesion_estado.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/usuario_repository.dart';

final sesionProvider = NotifierProvider<SesionNotifier, SesionEstado>(
  SesionNotifier.new,
);

/// Usuario conectado, o null si no hay sesión.
final usuarioActualProvider = Provider<Usuario?>(
  (ref) => switch (ref.watch(sesionProvider)) {
    ConSesion(:final usuario) => usuario,
    _ => null,
  },
);

class SesionNotifier extends Notifier<SesionEstado> {
  static const String _avisoDadoDeBaja =
      'Esta cuenta se dio de baja. Si quieres reactivarla, escríbenos a '
      'soporte.';
  static const String _avisoSinPerfil =
      'Tu cuenta no tiene un perfil registrado. Contacta al soporte.';

  late AuthRepository _auth;
  late UsuarioRepository _usuarios;

  int _version = 0;
  String? _avisoPendiente;
  bool _correoVerificado = false;

  @override
  SesionEstado build() {
    _auth = ref.watch(authRepositoryProvider);
    _usuarios = ref.watch(usuarioRepositoryProvider);

    final suscripcion = _auth.cambiosDeSesion.listen(
      _alCambiarSesion,
      onError: (Object _) => _alFallarEnlace(),
    );
    ref.onDispose(suscripcion.cancel);
    final recuperacion = _auth.recuperacionIniciada.listen((_) {
      ++_version;
      _emitir(const SesionRecuperando());
    });
    ref.onDispose(recuperacion.cancel);
    return const SesionVerificando();
  }

  Future<void> finalizarRecuperacion() => _alCambiarSesion(_auth.usuarioId);

  Future<void> cancelarRecuperacion() async {
    ++_version;
    _emitir(const SinSesion());
    await _auth.cerrarSesion();
  }

  Future<void> cerrarSesion() async {
    // Primero el token push: con la sesión cerrada, RLS ya no deja borrarlo.
    await ref
        .read(pushServiceProvider)
        .olvidar(ref.read(supabaseClientProvider));
    // También "desconectado" ya (la función necesita la sesión).
    await ref.read(presenciaRepositoryProvider).salir();
    await _auth.cerrarSesion();
  }

  Future<void> recargarUsuario() async {
    final actual = state;
    if (actual is! ConSesion) return;
    final perfil = await _usuarios.obtenerPorId(actual.usuario.id);
    if (perfil == null) return;
    // Si ya estaba verificado no se vuelve a consultar.
    final rostro = actual.rostroVerificado || await _rostroVerificado(perfil);
    _emitir(ConSesion(perfil, rostroVerificado: rostro));
  }

  /// El rostro del login coincidió con la foto de perfil.
  void marcarRostroVerificado() {
    final actual = state;
    if (actual is ConSesion) _emitir(ConSesion(actual.usuario));
  }

  /// Cierra la sesión y muestra [aviso] en el login.
  Future<void> darseDeBaja() async {
    await _usuarios.darseDeBaja();
    await cerrarSesionConAviso(
      'Tu cuenta se dio de baja. Gracias por haber sido parte de ChauchaApp.',
    );
  }

  Future<void> cerrarSesionConAviso(String aviso) async {
    _avisoPendiente = aviso;
    try {
      await cerrarSesion();
    } catch (_) {
      await _cerrarConAviso(aviso);
    }
  }

  /// El admin no tiene foto de perfil ni pasa por el control de rostro, y quien
  /// aún no verificó su identidad tampoco.
  Future<bool> _rostroVerificado(Usuario perfil) async {
    if (perfil.rol == Rol.admin || !perfil.verificado) return true;
    try {
      return await _usuarios.rostroSesionVerificado();
    } on AppFailure {
      return false;
    }
  }

  void consumirVerificado() {
    final actual = state;
    if (actual is SinSesion && actual.correoVerificado) {
      _emitir(SinSesion(aviso: actual.aviso));
    }
  }

  void _alFallarEnlace() {
    ++_version;
    final desdeEnlace = AuthRedirect.vieneDeConfirmacion;
    AuthRedirect.vieneDeConfirmacion = false;
    _emitir(SinSesion(correoVerificado: desdeEnlace));
  }

  Future<void> _alCambiarSesion(String? usuarioId) async {
    final version = ++_version;

    if (usuarioId == null) {
      _emitir(
        SinSesion(aviso: _avisoPendiente, correoVerificado: _correoVerificado),
      );
      _avisoPendiente = null;
      _correoVerificado = false;
      return;
    }

    if (AuthRedirect.vieneDeConfirmacion) {
      AuthRedirect.vieneDeConfirmacion = false;
      _correoVerificado = true;
      await _auth.cerrarSesion();
      return;
    }

    _emitir(const SesionVerificando());
    try {
      final perfil = await _usuarios.obtenerPorId(usuarioId);
      if (version != _version) return;
      if (perfil == null) {
        await _cerrarConAviso(_avisoSinPerfil);
      } else if (perfil.dadoDeBaja) {
        await _cerrarConAviso(_avisoDadoDeBaja);
      } else {
        final rostro = await _rostroVerificado(perfil);
        if (version != _version) return;
        _emitir(ConSesion(perfil, rostroVerificado: rostro));
      }
    } on AppFailure catch (falla) {
      if (version != _version) return;
      await _cerrarConAviso(falla.message);
    }
  }

  Future<void> _cerrarConAviso(String aviso) async {
    _avisoPendiente = aviso;
    _emitir(SinSesion(aviso: aviso));
    try {
      await _auth.cerrarSesion();
    } on AppFailure {
      // La sesión ya quedó cerrada en la app.
    }
  }

  void _emitir(SesionEstado nuevo) {
    if (!ref.mounted) return;
    state = nuevo;
  }
}
