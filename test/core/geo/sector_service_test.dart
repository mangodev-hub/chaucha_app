import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tecnicos_app/core/geo/sector_service.dart';

void main() {
  test('sin sesión consulta Nominatim directo', () async {
    var llamadas = 0;
    final cliente = MockClient((req) async {
      llamadas++;
      expect(req.url.host, 'nominatim.openstreetmap.org');
      return http.Response(
        jsonEncode({
          'address': {'suburb': 'La Carolina'},
        }),
        200,
      );
    });
    final servicio = SectorService(
      cliente: cliente,
      supabase: SupabaseClient(
        'http://localhost',
        'anon',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      ),
    );
    expect(await servicio.sectorDe((-0.18, -78.48)), 'La Carolina');
    // Segunda vez: caché en memoria, sin otra consulta.
    expect(await servicio.sectorDe((-0.18, -78.48)), 'La Carolina');
    expect(llamadas, 1);
  });
}
