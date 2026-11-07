// Fuente única de verdad sobre "quién está conectado". La lee el router.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  /// Cada cambio de sesión incrementa la versión; las respuestas de un
  /// cambio anterior que lleguen tarde se descartan.
  int _version = 0;

  /// Aviso que se mostrará cuando llegue el evento de "sin sesión".
  String? _avisoPendiente;

  @override
  SesionEstado build() {
    _auth = ref.watch(authRepositoryProvider);
    _usuarios = ref.watch(usuarioRepositoryProvider);

    final suscripcion = _auth.cambiosDeSesion.listen(_alCambiarSesion);
    ref.onDispose(suscripcion.cancel);

    return const SesionVerificando();
  }

  Future<void> cerrarSesion() => _auth.cerrarSesion();

  Future<void> _alCambiarSesion(String? usuarioId) async {
    final version = ++_version;

    if (usuarioId == null) {
      _emitir(SinSesion(aviso: _avisoPendiente));
      _avisoPendiente = null;
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
      // Si falla el cierre remoto, el estado local ya es SinSesion.
    }
  }

  void _emitir(SesionEstado nuevo) {
    if (!ref.mounted) return;
    state = nuevo;
  }
}
