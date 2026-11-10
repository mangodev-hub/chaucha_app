class ResumenChat {
  const ResumenChat({
    required this.conversacionId,
    required this.otroNombre,
    required this.esMio,
    this.oficio,
    this.ultimoMensaje,
    this.enviadoEn,
  });

  final String conversacionId;
  final String otroNombre;
  final String? oficio;
  final String? ultimoMensaje;
  final DateTime? enviadoEn;
  final bool esMio;
}
