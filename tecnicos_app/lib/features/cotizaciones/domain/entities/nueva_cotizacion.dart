// Datos que envía un técnico al ofrecer sus servicios en una solicitud.
class NuevaCotizacion {
  const NuevaCotizacion({
    required this.solicitudId,
    required this.solucion,
  });

  final String solicitudId;

  /// Cómo resolvería el problema.
  final String solucion;
}
