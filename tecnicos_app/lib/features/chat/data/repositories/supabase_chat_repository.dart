// Implementación del chat sobre Supabase (tablas `conversaciones` y
// `mensajes`).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/mensaje.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/mensaje_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => SupabaseChatRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseChatRepository implements ChatRepository {
  SupabaseChatRepository(this._client);

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

  /// `.stream()` hace la consulta inicial y luego escucha los INSERT.
  /// Sus errores (de red o del canal en tiempo real) se traducen a
  /// [AppFailure], como hace `supabaseGuard` con las llamadas normales.
  @override
  Stream<List<Mensaje>> mensajes(String conversacionId) {
    return _client
        .from('mensajes')
        .stream(primaryKey: ['id'])
        .eq('conversacion_id', conversacionId)
        .order('enviado_en', ascending: true)
        .map(
          (filas) => filas
              .map((fila) => MensajeModel.fromJson(fila).aEntidad())
              .toList(),
        )
        .transform(_errorDeConexion);
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

final _errorDeConexion =
    StreamTransformer<List<Mensaje>, List<Mensaje>>.fromHandlers(
  handleError: (error, stackTrace, sink) => sink.addError(
    error is AppFailure
        ? error
        : AppFailure(
            'No se pudo conectar al chat. Revisa tu conexión.',
            cause: error,
          ),
    stackTrace,
  ),
);
