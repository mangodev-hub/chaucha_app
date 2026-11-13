import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/anuncio.dart';
import '../../domain/repositories/anuncio_repository.dart';
import '../models/anuncio_model.dart';

final anuncioRepositoryProvider = Provider<AnuncioRepository>(
  (ref) => SupabaseAnuncioRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
  ),
);

class SupabaseAnuncioRepository implements AnuncioRepository {
  SupabaseAnuncioRepository(this._client, this._storage);

  final SupabaseClient _client;
  final StorageService _storage;
  final _azar = Random();

  @override
  Future<List<Anuncio>> vigentes(UbicacionAnuncio ubicacion) {
    return supabaseGuard(() async {
      final filas =
          await _desdeCache(ubicacion) ?? await _desdeTabla(ubicacion);
      final ahora = DateTime.now().toUtc();
      // Orden al azar en cada carga, para repartir la vista entre los
      // anunciantes; se muestran como máximo 5.
      final vigentes = [
        for (final fila in filas)
          if (AnuncioModel.vigente(fila, ahora))
            AnuncioModel.desdeFila(
              fila,
              urlImagen: (ruta) =>
                  _storage.urlPublica(bucket: Buckets.anuncios, ruta: ruta),
            ),
      ]..shuffle(_azar);
      return vigentes.take(5).toList();
    });
  }

  /// Edge Function `anuncios`: la misma consulta, guardada en Redis 5 min
  /// para todos los usuarios. null si no responde (se lee la tabla directo).
  Future<List<Map<String, dynamic>>?> _desdeCache(
    UbicacionAnuncio ubicacion,
  ) async {
    try {
      final r = await _client.functions.invoke(
        'anuncios',
        method: HttpMethod.get,
        queryParameters: {'ubicacion': ubicacion.db},
      );
      final lista = r.data is Map ? (r.data as Map)['anuncios'] : null;
      if (lista is! List) return null;
      return [
        for (final f in lista)
          if (f is Map) Map<String, dynamic>.from(f),
      ];
    } on Object {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _desdeTabla(UbicacionAnuncio ubicacion) =>
      _client
          .from('anuncios')
          .select(AnuncioModel.columnas)
          .inFilter('ubicacion', [ubicacion.db, UbicacionAnuncioDb.general])
          .eq('activo', true)
          .limit(50);
}
