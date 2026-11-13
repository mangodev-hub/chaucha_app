import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/servicio_completado.dart';

abstract final class ServicioCompletadoModel {
  /// Solicitud completada con su cotización aceptada, el técnico y la
  /// reseña que dejó el cliente (el filtro por autor va en la consulta).
  static const String columnas =
      'id, descripcion, completada_en, oficios(nombre), '
      'cotizaciones!fk_cotizaciones_solicitud!inner(precio_base, tecnico_id, '
      'estado, perfiles_tecnicos!fk_cotizaciones_tecnico('
      'calificacion_promedio, total_resenas, '
      'usuarios!fk_perfiles_usuario(nombres, apellidos, foto_perfil_ruta))), '
      'resenas!fk_resenas_solicitud(calificacion, autor_id)';

  static ServicioCompletado? desdeFila(Map<String, dynamic> f) {
    final cotizacion = anidado(f['cotizaciones']);
    final completada = f['completada_en'];
    if (cotizacion == null || completada == null) return null;
    final perfil = anidado(cotizacion['perfiles_tecnicos']);
    final usuario = anidado(perfil?['usuarios']);
    final nombre = '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'
        .trim();
    final resena = anidado(f['resenas']);
    final precio = cotizacion['precio_base'];
    return ServicioCompletado(
      solicitudId: f['id'] as String,
      descripcion: (f['descripcion'] as String? ?? '').trim(),
      oficioNombre: anidado(f['oficios'])?['nombre'] as String? ?? 'Servicio',
      completadaEn: aFecha(completada).toLocal(),
      precioVisita: precio == null ? null : aDouble(precio),
      tecnicoId: cotizacion['tecnico_id'] as String,
      tecnicoNombre: nombre.isEmpty ? 'Técnico' : nombre,
      tecnicoFotoRuta: usuario?['foto_perfil_ruta'] as String?,
      tecnicoCalificacion: aDouble(perfil?['calificacion_promedio']),
      tecnicoTotalResenas: aInt(perfil?['total_resenas']),
      miCalificacion: resena == null ? null : aInt(resena['calificacion']),
    );
  }
}
