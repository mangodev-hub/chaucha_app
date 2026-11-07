// Solicitud de servicio que publica un cliente.
import 'package:latlong2/latlong.dart';

enum EstadoSolicitud {
  abierta,
  cotizada,
  aceptada,
  porConfirmar,
  completada,
  cancelada;

  /// Solo se puede cotizar (y aceptar cotizaciones) mientras está abierta.
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
