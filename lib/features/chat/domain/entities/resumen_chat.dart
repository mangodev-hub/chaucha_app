class ResumenChat {
  const ResumenChat({
    required this.conversacionId,
    required this.otroNombre,
    required this.esMio,
    this.otroId = '',
    this.otroVerificado = false,
    this.oficio,
    this.ultimoMensaje,
    this.enviadoEn,
  });

  final String conversacionId;
  final String otroNombre;

  /// Id del otro usuario (técnico o cliente); vacío si no se conoce.
  final String otroId;

  /// La identidad del otro usuario está verificada.
  final bool otroVerificado;
  final String? oficio;
  final String? ultimoMensaje;
  final DateTime? enviadoEn;
  final bool esMio;
}
