// Implementación del catálogo de oficios sobre Supabase.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/oficio.dart';
import '../../domain/repositories/oficio_repository.dart';
import '../models/oficio_model.dart';

final oficioRepositoryProvider = Provider<OficioRepository>(
  (ref) => SupabaseOficioRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseOficioRepository implements OficioRepository {
  SupabaseOficioRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Oficio>> listar() {
    return supabaseGuard(() async {
      final filas = await _client
          .from('oficios')
          .select('id, nombre')
          .order('nombre');
      return filas
          .map((fila) => OficioModel.fromJson(fila).aEntidad())
          .toList();
    });
  }
}
