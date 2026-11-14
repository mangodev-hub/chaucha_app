class Conversacion {
  const Conversacion({
    required this.id,
    required this.solicitudId,
    required this.tecnicoId,
    this.clienteId,
  });

  final String id;
  final String solicitudId;
  final String tecnicoId;
  final String? clienteId;
}
