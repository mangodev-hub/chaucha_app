import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SectorService {
  SectorService({http.Client? cliente, this.supabase})
    : _cliente = cliente ?? http.Client();

  static const Duration _intervalo = Duration(milliseconds: 1100);
  static const Duration _tiempoMaximo = Duration(seconds: 8);

  /// De más específico a más general. Se usa el primero que venga.
  static const List<String> _campos = [
    'neighbourhood',
    'suburb',
    'quarter',
    'city_district',
    'village',
    'town',
    'city',
  ];

  final http.Client _cliente;

  /// Para pedir el barrio a la Edge Function `sector` (con caché en Redis).
  final SupabaseClient? supabase;
  final Map<String, String?> _cache = {};
  Future<void> _cola = Future<void>.value();

  /// Redondea a unas 3 cifras decimales (~110 m): puntos casi iguales
  /// comparten resultado y no repiten la consulta.
  static (double, double) clave(LatLng punto) => (
    (punto.latitude * 1000).round() / 1000,
    (punto.longitude * 1000).round() / 1000,
  );

  /// Devuelve el sector, o null si el mapa no tiene uno para ese punto.
  /// Lanza si la consulta falla (red, límite de uso, etc.).
  Future<String?> sectorDe((double, double) clave) {
    final llave = '${clave.$1},${clave.$2}';
    if (_cache.containsKey(llave)) return Future<String?>.value(_cache[llave]);

    final turno = _cola;
    final liberar = Completer<void>();
    _cola = liberar.future;

    return () async {
      await turno;
      try {
        if (_cache.containsKey(llave)) return _cache[llave];
        final sector = await _consultar(clave);
        _cache[llave] = sector;
        return sector;
      } finally {
        // El siguiente turno espera el intervalo completo.
        unawaited(
          Future<void>.delayed(_intervalo).then((_) => liberar.complete()),
        );
      }
    }();
  }

  Future<String?> _consultar((double, double) clave) async {
    final supabase = this.supabase;
    if (supabase != null && supabase.auth.currentSession != null) {
      try {
        final r = await supabase.functions
            .invoke('sector', body: {'lat': clave.$1, 'lng': clave.$2})
            .timeout(_tiempoMaximo);
        final datos = r.data;
        if (datos is Map) {
          final sector = datos['sector'];
          return sector is String && sector.trim().isNotEmpty
              ? sector.trim()
              : null;
        }
      } on Object {
        // Sin función (o con su límite agotado): consulta directa.
      }
    }
    return _directo(clave);
  }

  Future<String?> _directo((double, double) clave) async {
    final r = await _cliente
        .get(
          Uri.https('nominatim.openstreetmap.org', '/reverse', {
            'lat': '${clave.$1}',
            'lon': '${clave.$2}',
            'format': 'jsonv2',
            'zoom': '16',
            'addressdetails': '1',
            // Como parámetro (no como cabecera) para evitar el preflight CORS.
            'accept-language': 'es',
          }),
          // El navegador no deja cambiar el User-Agent; en móvil sí conviene.
          headers: kIsWeb
              ? null
              : const {
                  'User-Agent': 'ChauchaApp/1.0 (com.eagledev.tecnicos_app)',
                },
        )
        .timeout(_tiempoMaximo);
    if (r.statusCode != 200) {
      throw http.ClientException('Nominatim respondió ${r.statusCode}');
    }
    final cuerpo = jsonDecode(r.body);
    final direccion = cuerpo is Map ? cuerpo['address'] : null;
    if (direccion is! Map) return null;
    for (final campo in _campos) {
      final valor = direccion[campo];
      if (valor is String && valor.trim().isNotEmpty) return valor.trim();
    }
    return null;
  }
}
