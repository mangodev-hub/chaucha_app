import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

class NuevaSolicitud {
  const NuevaSolicitud({
    required this.oficioId,
    required this.descripcion,
    required this.ubicacion,
    required this.fotos,
    this.direccionReferencia,
  });

  /// Fotos del problema permitidas por solicitud.
  static const int maximoFotos = 3;

  final int oficioId;
  final String descripcion;
  final LatLng ubicacion;
  final String? direccionReferencia;
  final List<Uint8List> fotos;
}
