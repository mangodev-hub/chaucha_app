// Acceso al GPS detrás de una interfaz (para poder simularlo en tests).
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


abstract interface class UbicacionService {


  Future<LatLng?> obtenerActual();
}

class GeolocatorUbicacionService implements UbicacionService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  @override
  Future<LatLng?> obtenerActual() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        return null;
      }

      final posicion =
          await Geolocator.getCurrentPosition().timeout(_tiempoMaximo);
      return LatLng(posicion.latitude, posicion.longitude);
    } on TimeoutException {
      return null;
    } catch (_) {

      return null;
    }
  }
}
