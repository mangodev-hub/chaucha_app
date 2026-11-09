import 'package:latlong2/latlong.dart';

enum EstadoSolicitud {
  abierta,
  cotizada,
  aceptada,
  porConfirmar,
  completada,
  cancelada;

  bool get recibeCotizaciones => this == abierta || this == cotizada;
  bool get oficioEditable => this == abierta;
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

  final String id;
  final String clienteId;
  final int oficioId;
  final String oficioNombre;
  final String descripcion;
  final LatLng? ubicacion;
  final String? direccionReferencia;
  final EstadoSolicitud estado;
  final DateTime creadoEn;
}
