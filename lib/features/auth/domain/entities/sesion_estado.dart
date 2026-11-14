import 'usuario.dart';

sealed class SesionEstado {
  const SesionEstado();
}

/// Arrancando o cargando el perfil tras un cambio de sesión.
final class SesionVerificando extends SesionEstado {
  const SesionVerificando();
}

/// Sin sesión. [aviso] explica por qué se cerró (p. ej. cuenta sin perfil).
final class SinSesion extends SesionEstado {
  const SinSesion({this.aviso, this.correoVerificado = false});

  final String? aviso;
  final bool correoVerificado;
}

final class ConSesion extends SesionEstado {
  const ConSesion(this.usuario, {this.rostroVerificado = true});

  final Usuario usuario;

  /// false: esta sesión de login aún no confirmó el rostro con la foto de
  /// perfil, y el router no deja pasar del control de rostro.
  final bool rostroVerificado;
}

final class SesionRecuperando extends SesionEstado {
  const SesionRecuperando();
}
