// Fila de `documentos_tecnico`.
import '../../domain/entities/documento_tecnico.dart';
import 'documento_db.dart';

class DocumentoTecnicoModel {
  const DocumentoTecnicoModel({
    required this.id,
    required this.tipo,
    required this.estado,
    required this.ruta,
  });

  factory DocumentoTecnicoModel.fromJson(Map<String, dynamic> json) {
    return DocumentoTecnicoModel(
      id: json['id'] as String,
      tipo: TipoDocumentoDb.desdeDb(json['tipo'] as String),
      estado: EstadoDocumentoDb.desdeDb(json['estado'] as String),
      ruta: json['ruta_archivo'] as String,
    );
  }

  static const String columnas = 'id, tipo, ruta_archivo, estado';

  final String id;
  final TipoDocumento tipo;
  final EstadoDocumento estado;
  final String ruta;

  DocumentoTecnico aEntidad() =>
      DocumentoTecnico(id: id, tipo: tipo, estado: estado, ruta: ruta);
}
