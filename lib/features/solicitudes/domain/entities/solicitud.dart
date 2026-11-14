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
    this.clienteNombre,
    this.clienteFotoRuta,
    this.clienteVerificado = false,
    this.completadaEn,
  });

  final String id;
  final String clienteId;
  final int oficioId;
  final String oficioNombre;
  final String descripcion;

  /// Cuándo se completó el servicio: desde aquí corren los 30 días de
  /// garantía.
  final DateTime? completadaEn;
  final LatLng? ubicacion;
  final String? direccionReferencia;
  final EstadoSolicitud estado;
  final DateTime creadoEn;

  /// Nombre corto ("Ana P.") y foto del cliente, para las tarjetas del técnico.
  final String? clienteNombre;
  final String? clienteFotoRuta;

  /// La identidad del cliente está verificada.
  final bool clienteVerificado;

  String get clienteIniciales {
    final partes = (clienteNombre ?? '').split(' ').where((p) => p.isNotEmpty);
    final ini = partes.take(2).map((p) => p[0]).join();
    return ini.isEmpty ? '?' : ini.toUpperCase();
  }
}
