// Datos editables del perfil del técnico.
import 'package:latlong2/latlong.dart';

class CambiosPerfil {
  const CambiosPerfil({
    required this.tarifaBase,
    required this.rangoCoberturaM,
    required this.oficioIds,
    this.ubicacion,
  });

  final double tarifaBase;
  final int rangoCoberturaM;

  /// Punto de partida. Si es null no se toca la zona guardada (por ejemplo,
  /// al guardar solo la tarifa y los oficios).
  final LatLng? ubicacion;
  final Set<int> oficioIds;
}
