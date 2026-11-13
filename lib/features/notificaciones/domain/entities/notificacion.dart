class Notificacion {
  const Notificacion({
    required this.id,
    required this.tipo,
    required this.referenciaId,
    required this.contenido,
    required this.creadaEn,
  });

  factory Notificacion.desdeFila(Map<String, dynamic> f) => Notificacion(
    id: f['id'] as String,
    tipo: f['tipo'] as String,
    referenciaId: f['referencia_id'] as String?,
    contenido: (f['contenido'] as String?) ?? '',
    creadaEn: DateTime.parse(f['creada_en'] as String),
  );

  final String id;
  final String tipo;
  final String? referenciaId;
  final String contenido;
  final DateTime creadaEn;
}
