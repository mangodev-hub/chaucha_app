abstract final class AppRoutes {
  static const String splash = '/';

  static const String login = '/login';
  static const String registro = '/registro';

  static const String completarPerfil = '/completar-perfil';
  static const String selfie = '/selfie';

  /// Selfie en vivo tras cada inicio de sesión, contra la foto de perfil.
  static const String verificarRostro = '/verificar-rostro';
  static const String clienteInicio = '/cliente';
  static const String tecnicoInicio = '/tecnico';
  static const String adminInicio = '/admin';
  static const String recuperar = '/recuperar';
  static const String restablecer = '/restablecer';

  static const Set<String> publicas = {login, registro, recuperar};

  /// Páginas legales: se abren con o sin sesión, desde cualquier rol.
  static const String terminos = '/terminos';
  static const String privacidad = '/privacidad';
  static const Set<String> legales = {terminos, privacidad};

  /// Sección "Uso de datos de verificación" dentro de Privacidad.
  static const String privacidadVerificacion =
      '$privacidad?seccion=verificacion';

  static const String clienteNuevaSolicitud = '/cliente/nueva';

  /// Agenda del cliente. No es una pestaña: se abre desde el menú de la
  /// cuenta y desde "Mis solicitudes".
  static const String clienteAgenda = '/cliente/agenda';

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

  /// Detalle de un reclamo: lo abre quien lo hizo o el asesor (admin).
  static String reclamo(
    String id, {
    bool esCliente = true,
    bool esAdmin = false,
  }) => '${esAdmin ? adminInicio : _prefijo(esCliente)}/reclamo/$id';

  static String misReclamos({required bool esCliente}) =>
      '${_prefijo(esCliente)}/reclamos';

  /// Perfiles públicos desde el panel del asesor.
  static String perfilTecnicoAdmin(String id) => '$adminInicio/tecnico/$id';
  static String perfilClienteAdmin(String id) => '$adminInicio/cliente/$id';

  static String _prefijo(bool esCliente) =>
      esCliente ? clienteInicio : tecnicoInicio;
}
