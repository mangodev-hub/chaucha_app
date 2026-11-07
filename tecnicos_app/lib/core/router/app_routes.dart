// Rutas de la app en un solo lugar 
abstract final class AppRoutes {
  static const String splash = '/';


  static const String login = '/login';
  static const String registro = '/registro';


  static const String clienteInicio = '/cliente';
  static const String tecnicoInicio = '/tecnico';
  static const String adminInicio = '/admin';

  static const Set<String> publicas = {login, registro};


  static const String clienteNuevaSolicitud = '/cliente/nueva';


  static String detalleSolicitud(String id, {required bool esCliente}) =>
      '${_prefijo(esCliente)}/solicitud/$id';

  static String chat(String conversacionId, {required bool esCliente}) =>
      '${_prefijo(esCliente)}/chat/$conversacionId';

  static String _prefijo(bool esCliente) =>
      esCliente ? clienteInicio : tecnicoInicio;
}
