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

  /// Perfil público de un técnico. Solo lo abre el cliente (desde una oferta).
  static String perfilTecnico(String tecnicoId) =>
      '$clienteInicio/tecnico/$tecnicoId';

  static String _prefijo(bool esCliente) =>
      esCliente ? clienteInicio : tecnicoInicio;
}
