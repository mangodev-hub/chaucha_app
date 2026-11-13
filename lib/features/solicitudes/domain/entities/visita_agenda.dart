// Una visita de la agenda: la franja agendada de una cotización aceptada,
// con su solicitud y la otra persona (para el cliente, el técnico; para el
// técnico, el cliente).

/// Estado de la visita en la agenda. Colores en `ColoresVisita`.
enum EstadoVisita {
  /// Franja fija, todavía no empieza.
  agendada,

  /// Ya empezó (o el técnico la marcó terminada y falta el cierre).
  enCurso,

  /// Una de las partes propuso otra hora y la otra debe responder.
  porConfirmar,
}

class VisitaAgenda {
  const VisitaAgenda({
    required this.cotizacionId,
    required this.solicitudId,
    required this.tecnicoId,
    required this.inicio,
    required this.fin,
    required this.oficio,
    required this.descripcion,
    required this.precioVisita,
    required this.estado,
    required this.otraPersonaId,
    required this.otraPersonaNombre,
    this.otraPersonaFoto,
    this.reagendaInicio,
    this.reagendaPorMi = false,
  });

  final String cotizacionId;
  final String solicitudId;
  final String tecnicoId;
  final DateTime inicio;
  final DateTime fin;
  final String oficio;
  final String descripcion;
  final double precioVisita;
  final EstadoVisita estado;

  final String otraPersonaId;
  final String otraPersonaNombre;
  final String? otraPersonaFoto;

  /// Hora propuesta en una reagenda pendiente.
  final DateTime? reagendaInicio;

  /// La reagenda pendiente la propuso el usuario (espera a la otra parte).
  final bool reagendaPorMi;

  /// La otra parte propuso otra hora y le toca a este usuario responder.
  bool get meTocaConfirmar =>
      estado == EstadoVisita.porConfirmar && !reagendaPorMi;

  String get iniciales {
    final ini = otraPersonaNombre
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0])
        .join();
    return ini.isEmpty ? '?' : ini.toUpperCase();
  }
}
