// Conversación entre el cliente de una solicitud y un técnico que ofertó.
class Conversacion {
  const Conversacion({
    required this.id,
    required this.solicitudId,
    required this.tecnicoId,
  });

  final String id;
  final String solicitudId;
  final String tecnicoId;
}
