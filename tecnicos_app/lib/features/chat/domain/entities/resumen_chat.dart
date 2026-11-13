class ResumenChat {
  const ResumenChat({
    required this.conversacionId,
    required this.otroNombre,
    required this.esMio,
    this.otroId = '',
    this.oficio,
    this.ultimoMensaje,
    this.enviadoEn,
  });

  final String conversacionId;
  final String otroNombre;

  /// Id del otro usuario (técnico o cliente); vacío si no se conoce.
  final String otroId;
  final String? oficio;
  final String? ultimoMensaje;
  final DateTime? enviadoEn;
  final bool esMio;
}
