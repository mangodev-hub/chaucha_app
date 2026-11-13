// Certificado de un técnico (curso, capacitación). Lo revisa el admin.
enum EstadoCertificacion {
  pendiente,
  aprobada,
  rechazada;

  static EstadoCertificacion desdeDb(String? valor) => switch (valor) {
    'aprobada' => aprobada,
    'rechazada' => rechazada,
    _ => pendiente,
  };

  String get valorDb => name;
}

class Certificacion {
  const Certificacion({
    required this.id,
    required this.tecnicoId,
    required this.nombre,
    required this.entidad,
    required this.estado,
    this.anio,
    this.tecnicoNombre,
    this.url,
  });

  final String id;
  final String tecnicoId;
  final String nombre;
  final String entidad;
  final int? anio;
  final EstadoCertificacion estado;

  /// Solo la revisión del admin lo trae.
  final String? tecnicoNombre;

  /// URL firmada del archivo; solo la revisión del admin la trae.
  final String? url;

  bool get aprobada => estado == EstadoCertificacion.aprobada;

  /// La URL firmada conserva la extensión del archivo en su ruta.
  bool get esPdf =>
      url != null && Uri.parse(url!).path.toLowerCase().endsWith('.pdf');

  /// "SECAP · 2024" (o solo la entidad si no hay año).
  String get detalle => anio == null ? entidad : '$entidad · $anio';
}
