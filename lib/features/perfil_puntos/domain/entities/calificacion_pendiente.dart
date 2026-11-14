class CalificacionPendiente {
  const CalificacionPendiente({
    required this.solicitudId,
    required this.destinatarioId,
    required this.nombre,
    required this.paraTecnico,
    required this.completadaEn,
    this.oficio,
  });

  final String solicitudId;
  final String destinatarioId;

  /// A quién se califica (el cliente aparece con nombre corto: "Ana P.").
  final String nombre;

  /// true si quien califica es el cliente (y se califica al técnico).
  final bool paraTecnico;
  final DateTime completadaEn;
  final String? oficio;
}
