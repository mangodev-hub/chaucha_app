// Fuente única de verdad sobre "quién está conectado". La lee el router.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/auth_redirect.dart';
import '../../../../core/errors/app_failure.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import '../../domain/entities/sesion_estado.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/usuario_repository.dart';

final sesionProvider =
    NotifierProvider<SesionNotifier, SesionEstado>(SesionNotifier.new);

/// Usuario conectado, o null si no hay sesión.
final usuarioActualProvider = Provider<Usuario?>(
  (ref) => switch (ref.watch(sesionProvider)) {
    ConSesion(:final usuario) => usuario,
    _ => null,
  },
);

class SesionNotifier extends Notifier<SesionEstado> {
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

  Future<void> cerrarSesion() => _auth.cerrarSesion();

  Future<void> recargarUsuario() async {
    final actual = state;
    if (actual is! ConSesion) return;
    final perfil = await _usuarios.obtenerPorId(actual.usuario.id);
    if (perfil != null) _emitir(ConSesion(perfil));
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
      _emitir(SinSesion(
        aviso: _avisoPendiente,
        correoVerificado: _correoVerificado,
      ));
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
      } else {
        _emitir(ConSesion(perfil));
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
      // La sesión ya quedó cerrada en la app (SinSesion con el aviso); si
      // cerrarla también en Supabase falla, no hay nada más que hacer.
    }
  }

  void _emitir(SesionEstado nuevo) {
    if (!ref.mounted) return;
    state = nuevo;
  }
}