// Refleja el CHECK de `solicitudes_servicio.estado`.
import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

import '../../../core/geo/geo_mapper.dart';
import '../../../core/utils/json_utils.dart';


enum EstadoSolicitud {
  abierta('abierta'),
  cotizada('cotizada'),
  aceptada('aceptada'),
  porConfirmar('por_confirmar'),
  completada('completada'),
  cancelada('cancelada');

  const EstadoSolicitud(this.valorDb);

  final String valorDb;

  static EstadoSolicitud desdeDb(String valor) =>
      values.firstWhere((e) => e.valorDb == valor);


  bool get recibeCotizaciones => this == abierta || this == cotizada;
}


class Solicitud {
  const Solicitud({
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

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String,
      oficioId: aInt(json['oficio_id']),
      oficioNombre:
          anidado(json['oficios'])?['nombre'] as String? ?? 'Oficio',
      descripcion: json['descripcion'] as String,
      ubicacion: GeoMapper.fromDb(json['ubicacion']),
      direccionReferencia: json['direccion_referencia'] as String?,
      estado: EstadoSolicitud.desdeDb(json['estado'] as String),
      creadoEn: aFecha(json['creado_en']),
    );
  }
}


class NuevaSolicitud {
  const NuevaSolicitud({
    required this.oficioId,
    required this.descripcion,
    required this.ubicacion,
    required this.fotos,
    this.direccionReferencia,
  });

  final int oficioId;
  final String descripcion;
  final LatLng ubicacion;
  final String? direccionReferencia;
  final List<Uint8List> fotos;
}


enum TipoArchivo {
  problema('problema'),
  evidencia('evidencia');

  const TipoArchivo(this.valorDb);

  final String valorDb;
}


class FotoSolicitud {
  const FotoSolicitud({required this.tipo, required this.url});

  final TipoArchivo tipo;
  final String url;
}
