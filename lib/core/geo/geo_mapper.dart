import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

abstract final class GeoMapper {
  static const LatLng quito = LatLng(-0.180653, -78.467834);

  static const int srid = 4326;

  static const Distance _distancia = Distance();

  static String toPostGisPoint(LatLng coord) {
    _assertRango(coord.latitude, coord.longitude);
    return 'SRID=$srid;POINT(${coord.longitude} ${coord.latitude})';
  }

  static double metrosEntre(LatLng a, LatLng b) =>
      _distancia.as(LengthUnit.Meter, a, b);

  static LatLng? fromDb(Object? valor) {
    try {
      if (valor is Map<String, dynamic>) return fromGeoJson(valor);
      if (valor is String) {
        final texto = valor.trim();
        if (texto.toUpperCase().contains('POINT')) return _desdeWkt(texto);
        return _desdeWkbHex(texto);
      }
      return null;
    } on ArgumentError {
      return null;
    }
  }

  static LatLng fromGeoJson(Map<String, dynamic> json) {
    final coords = (json['coordinates'] as List).cast<num>();
    return _crear(
      latitud: coords[1].toDouble(),
      longitud: coords[0].toDouble(),
    );
  }

  static LatLng? _desdeWkt(String wkt) {
    final match = RegExp(
      r'POINT\s*\(\s*(\S+)\s+(\S+)\s*\)',
      caseSensitive: false,
    ).firstMatch(wkt);
    if (match == null) return null;
    final longitud = double.tryParse(match[1]!);
    final latitud = double.tryParse(match[2]!);
    if (longitud == null || latitud == null) return null;
    return _crear(latitud: latitud, longitud: longitud);
  }

  static LatLng? _desdeWkbHex(String hex) {
    const tipoPoint = 1;
    const banderaSrid = 0x20000000;
    if (hex.length < 42 || hex.length.isOdd) return null;

    final bytes = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      final byte = int.tryParse(hex.substring(i * 2, i * 2 + 2), radix: 16);
      if (byte == null) return null;
      bytes[i] = byte;
    }

    final datos = ByteData.sublistView(bytes);
    final orden = bytes[0] == 1 ? Endian.little : Endian.big;
    final tipo = datos.getUint32(1, orden);
    if ((tipo & 0x0FFFFFFF) != tipoPoint) return null;

    final inicio = (tipo & banderaSrid) != 0 ? 9 : 5;
    if (bytes.length < inicio + 16) return null;
    final longitud = datos.getFloat64(inicio, orden);
    final latitud = datos.getFloat64(inicio + 8, orden);
    return _crear(latitud: latitud, longitud: longitud);
  }

  static LatLng _crear({required double latitud, required double longitud}) {
    _assertRango(latitud, longitud);
    return LatLng(latitud, longitud);
  }

  static void _assertRango(double latitud, double longitud) {
    if (latitud < -90 || latitud > 90 || longitud < -180 || longitud > 180) {
      throw ArgumentError(
        'Coordenadas fuera de rango: lat=$latitud, lng=$longitud',
      );
    }
  }
}
