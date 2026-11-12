// Rutas de la app en un solo lugar
abstract final class AppRoutes {
  static const String splash = '/';

  static const String login = '/login';
  static const String registro = '/registro';

  static const String completarPerfil = '/completar-perfil';
  static const String selfie = '/selfie';
  static const String clienteInicio = '/cliente';
  static const String tecnicoInicio = '/tecnico';
  static const String adminInicio = '/admin';
  static const String recuperar = '/recuperar';
  static const String restablecer = '/restablecer';

  static const Set<String> publicas = {login, registro, recuperar};

  static const String clienteNuevaSolicitud = '/cliente/nueva';

  static String detalleSolicitud(String id, {required bool esCliente}) =>
      '${_prefijo(esCliente)}/solicitud/$id';

  static String chat(String conversacionId, {required bool esCliente}) =>
      '${_prefijo(esCliente)}/chat/$conversacionId';

  /// Perfil público de un técnico: lo abren clientes y otros técnicos.
  static String perfilTecnico(String tecnicoId, {bool esCliente = true}) =>
      '${_prefijo(esCliente)}/tecnico/$tecnicoId';

  /// Perfil público de un cliente. Solo lo abre el técnico.
  static String perfilCliente(String clienteId) =>
      '$tecnicoInicio/cliente/$clienteId';

  static String _prefijo(bool esCliente) =>
      esCliente ? clienteInicio : tecnicoInicio;
}
