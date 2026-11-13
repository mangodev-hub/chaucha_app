// Cifras del inicio del panel.
class ResumenAdmin {
  const ResumenAdmin({
    required this.clientes,
    required this.tecnicos,
    required this.tecnicosVerificados,
    required this.solicitudes,
    required this.solicitudesAbiertas,
    required this.verificacionesPendientes,
  });

  final int clientes;
  final int tecnicos;
  final int tecnicosVerificados;
  final int solicitudes;

  /// Abiertas o con cotizaciones (esperando técnico).
  final int solicitudesAbiertas;

  /// Técnicos con al menos un documento por revisar.
  final int verificacionesPendientes;
}
