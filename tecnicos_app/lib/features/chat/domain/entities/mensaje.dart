// Mensaje de una conversación entre cliente y técnico.
class Mensaje {
  const Mensaje({
    required this.id,
    required this.conversacionId,
    required this.autorId,
    required this.contenido,
    required this.enviadoEn,
  });

  final String id;
  final String conversacionId;
  final String autorId;
  final String contenido;
  final DateTime enviadoEn;
}
