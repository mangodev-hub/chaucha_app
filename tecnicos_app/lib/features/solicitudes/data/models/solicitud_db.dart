// Mapeo de los enums de solicitudes al texto de la base. Refleja los CHECK de
// `solicitudes_servicio.estado` y `solicitud_archivos.tipo`.
import '../../domain/entities/foto_solicitud.dart';
import '../../domain/entities/solicitud.dart';

extension EstadoSolicitudDb on EstadoSolicitud {
  String get valorDb => switch (this) {
        EstadoSolicitud.abierta => 'abierta',
        EstadoSolicitud.cotizada => 'cotizada',
        EstadoSolicitud.aceptada => 'aceptada',
        EstadoSolicitud.porConfirmar => 'por_confirmar',
        EstadoSolicitud.completada => 'completada',
        EstadoSolicitud.cancelada => 'cancelada',
      };

  static EstadoSolicitud desdeDb(String valor) =>
      EstadoSolicitud.values.firstWhere(
        (estado) => estado.valorDb == valor,
        orElse: () =>
            throw FormatException('Estado de solicitud desconocido: $valor'),
      );
}

extension TipoArchivoDb on TipoArchivo {
  String get valorDb => switch (this) {
        TipoArchivo.problema => 'problema',
        TipoArchivo.evidencia => 'evidencia',
      };

  /// Cualquier valor que no sea "evidencia" se trata como foto del problema.
  static TipoArchivo desdeDb(Object? valor) => valor == 'evidencia'
      ? TipoArchivo.evidencia
      : TipoArchivo.problema;
}
