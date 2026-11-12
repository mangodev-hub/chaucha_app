import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/notificacion.dart';

class SupabaseNotificacionesRepository {
  SupabaseNotificacionesRepository(this._db);

  final SupabaseClient _db;

  Stream<List<Notificacion>> noLeidas(String uid) => _db
      .from('notificaciones')
      .stream(primaryKey: ['id'])
      .eq('usuario_id', uid)
      .order('creada_en', ascending: false)
      .limit(50)
      .map(
        (filas) => filas
            .where((f) => f['leida'] == false)
            .map(Notificacion.desdeFila)
            .toList(),
      );

  Future<void> marcarLeidas(
    String uid, {
    required List<String> tipos,
    String? referenciaId,
  }) async {
    var q = _db
        .from('notificaciones')
        .update({'leida': true})
        .eq('usuario_id', uid)
        .eq('leida', false)
        .inFilter('tipo', tipos);
    if (referenciaId != null) q = q.eq('referencia_id', referenciaId);
    await q;
  }

  Future<void> marcarLeidasDe(
    String uid, {
    required List<String> tipos,
    required List<String> referenciaIds,
  }) async {
    if (referenciaIds.isEmpty) return;
    await _db
        .from('notificaciones')
        .update({'leida': true})
        .eq('usuario_id', uid)
        .eq('leida', false)
        .inFilter('tipo', tipos)
        .inFilter('referencia_id', referenciaIds);
  }
}
