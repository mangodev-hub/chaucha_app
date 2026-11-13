import 'package:latlong2/latlong.dart';

/// Solicitud abierta dentro del radio del técnico (`solicitudes_en_mapa`).
class SolicitudEnMapa {
  const SolicitudEnMapa({
    required this.id,
    required this.descripcion,
    required this.oficioId,
    required this.metros,
    required this.ubicacion,
    required this.creadoEn,
  });

  final String id;
  final String descripcion;
  final int oficioId;
  final int metros;
  final LatLng ubicacion;
  final DateTime creadoEn;
}
