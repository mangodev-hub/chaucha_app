// Fuente única de verdad sobre "quién está conectado" .
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/errors/app_failure.dart';
import '../models/sesion_estado.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';







class SessionStore extends ValueNotifier<SesionEstado> {
  SessionStore({
    required AuthService authService,
    required UsuarioService usuarioService,
  })  : _auth = authService,
        _usuarios = usuarioService,
        super(const SesionVerificando());

  static const String _avisoSinPerfil =
      'Tu cuenta no tiene un perfil registrado. Contacta al soporte.';

  final AuthService _auth;
  final UsuarioService _usuarios;

  StreamSubscription<String?>? _suscripcion;
  bool _disposed = false;



  int _version = 0;


  String? _avisoPendiente;

  Usuario? get usuario => switch (value) {
        ConSesion(:final usuario) => usuario,
        _ => null,
      };


  void iniciar() {
    _suscripcion ??= _auth.cambiosDeSesion.listen(_alCambiarSesion);
  }

  Future<void> cerrarSesion() => _auth.cerrarSesion();

  Future<void> _alCambiarSesion(String? usuarioId) async {
    final version = ++_version;

    if (usuarioId == null) {
      _emit(SinSesion(aviso: _avisoPendiente));
      _avisoPendiente = null;
      return;
    }

    _emit(const SesionVerificando());
    try {
      final perfil = await _usuarios.obtenerPorId(usuarioId);
      if (version != _version) return; 
      if (perfil == null) {
        await _cerrarConAviso(_avisoSinPerfil);
      } else {
        _emit(ConSesion(perfil));
      }
    } on AppFailure catch (falla) {
      if (version != _version) return;
      await _cerrarConAviso(falla.message);
    }
  }

  Future<void> _cerrarConAviso(String aviso) async {
    _avisoPendiente = aviso;
    _emit(SinSesion(aviso: aviso));
    try {
      await _auth.cerrarSesion();
    } on AppFailure {//

    }
  }

  void _emit(SesionEstado estado) {
    if (_disposed) return;
    value = estado;
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_suscripcion?.cancel());
    super.dispose();
  }
}
