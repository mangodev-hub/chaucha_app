// `.stream()` hace la consulta inicial y luego escucha los INSERT.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_extensions.dart';
import '../../../core/supabase/supabase_guard.dart';
import '../models/mensaje.dart';
import 'chat_service.dart';

class SupabaseChatService implements ChatService {
  SupabaseChatService(this._client);

  final SupabaseClient _client;

  @override
  Future<String> obtenerOCrearConversacion({
    required String solicitudId,
    required String tecnicoId,
  }) {
    return supabaseGuard(() async {
      final existente = await _client
          .from('conversaciones')
          .select('id')
          .eq('solicitud_id', solicitudId)
          .eq('tecnico_id', tecnicoId)
          .limit(1)
          .maybeSingle();
      if (existente != null) return existente['id'] as String;

      final nueva = await _client
          .from('conversaciones')
          .insert({'solicitud_id': solicitudId, 'tecnico_id': tecnicoId})
          .select('id')
          .single();
      return nueva['id'] as String;
    });
  }




  @override
  Stream<List<Mensaje>> mensajes(String conversacionId) {
    return _client
        .from('mensajes')
        .stream(primaryKey: ['id'])
        .eq('conversacion_id', conversacionId)
        .order('enviado_en', ascending: true)
        .map((filas) => filas.map(Mensaje.fromJson).toList());
  }

  @override
  Future<void> enviar({required String conversacionId, required String texto}) {
    return supabaseGuard(() async {
      await _client.from('mensajes').insert({
        'conversacion_id': conversacionId,
        'autor_id': _client.uidActual,
        'contenido': texto.trim(),
      });
    });
  }
}
