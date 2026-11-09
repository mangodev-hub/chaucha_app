// Datos que envía un técnico al ofrecer sus servicios en una solicitud.
class NuevaCotizacion {
  const NuevaCotizacion({
    required this.solicitudId,
    required this.precioBase,
    required this.solucion,
  });

  final String solicitudId;
  final double precioBase;

  /// Cómo resolvería el problema.
  final String solucion;
}
