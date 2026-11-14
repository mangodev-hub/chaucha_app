class ConversacionPendiente {
  const ConversacionPendiente({
    required this.conversacionId,
    required this.solicitudId,
    required this.ultimoMensaje,
    required this.enviadoEn,
    this.oficio,
  });

  final String conversacionId;
  final String solicitudId;

  /// Oficio de la solicitud ("Plomería"), si llegó.
  final String? oficio;
  final String ultimoMensaje;
  final DateTime enviadoEn;
}
