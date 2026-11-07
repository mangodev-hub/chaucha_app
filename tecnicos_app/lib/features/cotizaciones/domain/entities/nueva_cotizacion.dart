// Datos que envía un técnico al cotizar una solicitud.
class NuevaCotizacion {
  const NuevaCotizacion({
    required this.solicitudId,
    required this.manoObra,
    required this.materiales,
    this.detalle,
  });

  final String solicitudId;
  final double manoObra;
  final double materiales;
  final String? detalle;
}
