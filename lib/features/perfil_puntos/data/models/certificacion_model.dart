// Fila de `certificaciones_tecnico` tal como llega de Supabase.
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/certificacion.dart';

abstract final class CertificacionModel {
  static const String tabla = 'certificaciones_tecnico';

  /// Bucket privado propio (acepta PDF); `cedulas` queda solo para fotos.
  static const String bucket = 'certificados';

  static const String columnas =
      'id, tecnico_id, nombre, entidad, anio, estado, ruta_archivo';

  /// Con el nombre del técnico, para la revisión del admin.
  static const String columnasAdmin =
      '$columnas, usuarios!fk_certificaciones_tecnico(nombres, apellidos)';

  static Certificacion desdeFila(Map<String, dynamic> fila, {String? url}) {
    final usuario = anidado(fila['usuarios']);
    final nombre = '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'
        .trim();
    return Certificacion(
      id: fila['id'] as String,
      tecnicoId: fila['tecnico_id'] as String,
      nombre: fila['nombre'] as String,
      entidad: fila['entidad'] as String,
      anio: fila['anio'] as int?,
      estado: EstadoCertificacion.desdeDb(fila['estado'] as String?),
      tecnicoNombre: nombre.isEmpty ? null : nombre,
      url: url,
    );
  }
}
