// Pantalla de inicio de cada rol.
import '../core/router/app_routes.dart';
import '../features/auth/domain/entities/rol.dart';
import '../features/auth/domain/entities/sesion_estado.dart';

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
    // El administrador no tiene cédula: nunca pasa por completar el perfil.
    ConSesion(:final usuario)
        when !usuario.perfilCompleto && usuario.rol != Rol.admin =>
      ubicacion == AppRoutes.completarPerfil ? null : AppRoutes.completarPerfil,
          ConSesion(:final usuario)
        when !usuario.fotoVerificada && usuario.rol != Rol.admin =>
      ubicacion == AppRoutes.selfie ? null : AppRoutes.selfie,
    ConSesion(:final usuario) => _redireccionConSesion(usuario.rol, ubicacion),
    SesionRecuperando() =>
      ubicacion == AppRoutes.restablecer ? null : AppRoutes.restablecer,
  };
}

String? _redireccionConSesion(Rol rol, String ubicacion) {
  final inicio = rutaInicioPara(rol);
  final estaEnSuZona = ubicacion == inicio || ubicacion.startsWith('$inicio/');
  return estaEnSuZona ? null : inicio;
}
