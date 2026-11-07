// Pantalla de inicio de cada rol.
import '../core/router/app_routes.dart';
import '../features/auth/models/rol.dart';
import '../features/auth/models/sesion_estado.dart';


String rutaInicioPara(Rol rol) => switch (rol) {
      Rol.cliente => AppRoutes.clienteInicio,
      Rol.tecnico => AppRoutes.tecnicoInicio,
      Rol.admin => AppRoutes.adminInicio,
    };

String? resolverRedireccion({
  required SesionEstado sesion,
  required String ubicacion,
}) {
  return switch (sesion) {
    SesionVerificando() =>
      ubicacion == AppRoutes.splash ? null : AppRoutes.splash,
    SinSesion() =>
      AppRoutes.publicas.contains(ubicacion) ? null : AppRoutes.login,
    ConSesion(:final usuario) => _redireccionConSesion(usuario.rol, ubicacion),
  };
}

String? _redireccionConSesion(Rol rol, String ubicacion) {
  final inicio = rutaInicioPara(rol);
  final estaEnSuZona = ubicacion == inicio || ubicacion.startsWith('$inicio/');
  return estaEnSuZona ? null : inicio;
}
