class Mensaje {
  const Mensaje({
    required this.id,
    required this.conversacionId,
    required this.autorId,
    required this.contenido,
    required this.enviadoEn,
    this.tipo = 'texto',
    this.datos,
  });

  final String id;
  final String conversacionId;
  final String autorId;
  final String contenido;
  final DateTime enviadoEn;
  final String tipo;
  final Map<String, dynamic>? datos;

  bool get esSistema => tipo == 'sistema';
  String? get accion => datos?['accion'] as String?;
}