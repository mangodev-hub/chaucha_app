import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/solicitud_en_mapa.dart';
import '../../domain/repositories/mapa_tecnico_repository.dart';

final mapaTecnicoRepositoryProvider = Provider<MapaTecnicoRepository>(
  (ref) => SupabaseMapaTecnicoRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseMapaTecnicoRepository implements MapaTecnicoRepository {
  SupabaseMapaTecnicoRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<SolicitudEnMapa>> solicitudesEnMapa() {
    return supabaseGuard(() async {
      final filas = await _client.rpc<List<dynamic>>('solicitudes_en_mapa');
      return [
        for (final f in filas.cast<Map<String, dynamic>>())
          SolicitudEnMapa(
            id: f['solicitud_id'] as String,
            descripcion: f['descripcion'] as String? ?? '',
            oficioId: aInt(f['oficio_id']),
            metros: aInt(f['metros']),
            ubicacion: LatLng(aDouble(f['lat']), aDouble(f['lng'])),
            creadoEn: aFecha(f['creado_en']).toLocal(),
          ),
      ];
    });
  }

  @override
  Future<void> actualizarMiRadio(int metros) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'actualizar_mi_radio',
        params: {'p_metros': metros},
      );
    });
  }
}
