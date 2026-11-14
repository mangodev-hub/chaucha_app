import '../../../perfil_puntos/domain/entities/documento_tecnico.dart';

class RevisionTecnico {
  const RevisionTecnico({
    required this.tecnicoId,
    required this.nombre,
    required this.documentos,
    this.cedula,
  });

  final String tecnicoId;
  final String nombre;

  /// Cédula que escribió al registrarse, para compararla con la foto.
  final String? cedula;

  /// Sus documentos (frente, reverso y selfie), con URL firmada.
  final List<DocumentoTecnico> documentos;

  List<DocumentoTecnico> get pendientes => [
    for (final d in documentos)
      if (d.estado == EstadoDocumento.pendiente) d,
  ];
}
