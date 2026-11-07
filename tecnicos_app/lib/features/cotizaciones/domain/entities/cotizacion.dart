// Cotización de un técnico para una solicitud, con su nombre y calificación.
enum EstadoCotizacion { pendiente, aceptada, rechazada }

class Cotizacion {
  const Cotizacion({
    required this.id,
    required this.solicitudId,
    required this.tecnicoId,
    required this.tecnicoNombre,
    required this.tecnicoCalificacion,
    required this.manoObra,
    required this.materiales,
    required this.total,
    required this.estado,
    required this.creadoEn,
    this.detalle,
  });

  final String id;
  final String solicitudId;
  final String tecnicoId;
  final String tecnicoNombre;
  final double tecnicoCalificacion;
  final double manoObra;
  final double materiales;
  final double total;
  final String? detalle;
  final EstadoCotizacion estado;
  final DateTime creadoEn;
}
