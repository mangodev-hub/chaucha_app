import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/tecnico_cercano.dart';
import '../../domain/repositories/inicio_repository.dart';
import '../models/tecnico_cercano_model.dart';

final inicioRepositoryProvider = Provider<InicioRepository>(
  (ref) => SupabaseInicioRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseInicioRepository implements InicioRepository {
  SupabaseInicioRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<TecnicoCercano>> tecnicosCercanos({
    required LatLng punto,
    required int radioM,
    int? oficioId,
    int limite = 20,
  }) {
    return supabaseGuard(() async {
      final filas = await _client.rpc<List<dynamic>>(
        'tecnicos_cercanos',
        params: {
          'p_lat': punto.latitude,
          'p_lng': punto.longitude,
          'p_oficio_id': oficioId,
          'p_radio_m': radioM,
          'p_limite': limite,
        },
      );
      return [
        for (final fila in filas)
          TecnicoCercanoModel.fromJson(fila as Map<String, dynamic>).aEntidad(),
      ];
    });
  }
}
