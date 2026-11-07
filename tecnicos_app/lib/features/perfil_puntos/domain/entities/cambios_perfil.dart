// Datos editables del perfil del técnico.
import 'package:latlong2/latlong.dart';

class CambiosPerfil {
  const CambiosPerfil({
    required this.tarifaBase,
    required this.rangoCoberturaM,
    required this.ubicacion,
    required this.oficioIds,
  });

  final double tarifaBase;
  final int rangoCoberturaM;
  final LatLng ubicacion;
  final Set<int> oficioIds;
}
