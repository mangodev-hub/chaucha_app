// Estado global de la sesión. Lo lee el router para decidir a dónde ir.
import 'usuario.dart';


sealed class SesionEstado {
  const SesionEstado();
}


final class SesionVerificando extends SesionEstado {
  const SesionVerificando();
}



final class SinSesion extends SesionEstado {
  const SinSesion({this.aviso});

  final String? aviso;
}


final class ConSesion extends SesionEstado {
  const ConSesion(this.usuario);

  final Usuario usuario;
}
