// Fila de `solicitudes_servicio` + nombre del oficio (join).
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/solicitud.dart';
import 'solicitud_db.dart';

class SolicitudModel {
  const SolicitudModel({
    required this.id,
    required this.clienteId,
    required this.oficioId,
    required this.oficioNombre,
    required this.descripcion,
    required this.estado,
    required this.creadoEn,
    this.ubicacion,
    this.direccionReferencia,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    return SolicitudModel(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String,
      oficioId: aInt(json['oficio_id']),
      oficioNombre:
          anidado(json['oficios'])?['nombre'] as String? ?? 'Oficio',
      descripcion: json['descripcion'] as String,
      ubicacion: GeoMapper.fromDb(json['ubicacion']),
      direccionReferencia: json['direccion_referencia'] as String?,
      estado: EstadoSolicitudDb.desdeDb(json['estado'] as String),
      creadoEn: aFecha(json['creado_en']),
    );
  }

  /// Columnas que se piden en el `select`, con el join al oficio.
  static const String columnas = 'id, cliente_id, oficio_id, descripcion, '
      'ubicacion, direccion_referencia, estado, creado_en, oficios(nombre)';

  final String id;
  final String clienteId;
  final int oficioId;
  final String oficioNombre;
  final String descripcion;
  final LatLng? ubicacion;
  final String? direccionReferencia;
  final EstadoSolicitud estado;
  final DateTime creadoEn;

  Solicitud aEntidad() => Solicitud(
        id: id,
        clienteId: clienteId,
        oficioId: oficioId,
        oficioNombre: oficioNombre,
        descripcion: descripcion,
        ubicacion: ubicacion,
        direccionReferencia: direccionReferencia,
        estado: estado,
        creadoEn: creadoEn,
      );
}
