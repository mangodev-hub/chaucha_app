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
    this.clienteNombre,
    this.clienteFotoRuta,
    this.completadaEn,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    final cliente = anidado(json['cliente']);
    final nombres = (cliente?['nombres'] as String? ?? '').trim();
    final apellidos = (cliente?['apellidos'] as String? ?? '').trim();
    final nombreCorto = [
      if (nombres.isNotEmpty) nombres.split(' ').first,
      if (apellidos.isNotEmpty) '${apellidos[0]}.',
    ].join(' ');
    return SolicitudModel(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String,
      oficioId: aInt(json['oficio_id']),
      oficioNombre: anidado(json['oficios'])?['nombre'] as String? ?? 'Oficio',
      descripcion: json['descripcion'] as String,
      ubicacion: GeoMapper.fromDb(json['ubicacion']),
      direccionReferencia: json['direccion_referencia'] as String?,
      estado: EstadoSolicitudDb.desdeDb(json['estado'] as String),
      creadoEn: aFecha(json['creado_en']),
      clienteNombre: nombreCorto.isEmpty ? null : nombreCorto,
      clienteFotoRuta: cliente?['foto_perfil_ruta'] as String?,
      completadaEn: json['completada_en'] is String
          ? aFecha(json['completada_en']).toLocal()
          : null,
    );
  }

  /// Columnas que se piden en el `select`, con el join al oficio.
  static const String columnas =
      'id, cliente_id, oficio_id, descripcion, '
      'ubicacion, direccion_referencia, estado, creado_en, completada_en, '
      'oficios(nombre), '
      'cliente:usuarios!fk_solicitudes_cliente(nombres, apellidos, foto_perfil_ruta)';

  final String id;
  final String clienteId;
  final int oficioId;
  final String oficioNombre;
  final String descripcion;
  final LatLng? ubicacion;
  final String? direccionReferencia;
  final EstadoSolicitud estado;
  final DateTime creadoEn;
  final String? clienteNombre;
  final String? clienteFotoRuta;
  final DateTime? completadaEn;

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
    clienteNombre: clienteNombre,
    clienteFotoRuta: clienteFotoRuta,
    completadaEn: completadaEn,
  );
}
