// Reseña que deja un usuario sobre otro al terminar un servicio.
class NuevaResena {
  const NuevaResena({
    required this.solicitudId,
    required this.destinatarioId,
    required this.calificacion,
    this.comentario,
  });

  final String solicitudId;
  final String destinatarioId;
  final int calificacion;
  final String? comentario;
}
