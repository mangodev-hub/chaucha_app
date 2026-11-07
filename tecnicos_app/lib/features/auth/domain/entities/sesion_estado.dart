// Estado global de la sesión. Lo lee el router para decidir a dónde ir.
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
  const SinSesion({this.aviso});

  final String? aviso;
}

final class ConSesion extends SesionEstado {
  const ConSesion(this.usuario);

  final Usuario usuario;
}
