// Implementación del chat sobre Supabase (tablas `conversaciones` y
// `mensajes`).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/conversacion.dart';
import '../../domain/entities/conversacion_pendiente.dart';
import '../../domain/entities/mensaje.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/conversacion_model.dart';
import '../models/mensaje_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => SupabaseChatRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseChatRepository implements ChatRepository {
  SupabaseChatRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<Conversacion> conversacion(String conversacionId) {
    return supabaseGuard(() async {
      final fila = await _client
          .from('conversaciones')
          .select(ConversacionModel.columnas)
          .eq('id', conversacionId)
          .maybeSingle();
      if (fila == null) {
        throw const AppFailure('No encontramos esta conversación.');
      }
      return ConversacionModel.desdeFila(fila);
    });
  }

  /// Dos consultas: las conversaciones del técnico (con el oficio de su
  /// solicitud) y sus mensajes más recientes, para ver quién escribió último.
  @override
  Future<List<ConversacionPendiente>> porResponder() {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      final conversaciones = await _client
          .from('conversaciones')
          .select('id, solicitud_id, solicitudes_servicio(oficios(nombre))')
          .eq('tecnico_id', uid);
      if (conversaciones.isEmpty) return const [];

      final ids = [for (final c in conversaciones) c['id'] as String];
      final mensajes = await _client
          .from('mensajes')
          .select('conversacion_id, autor_id, contenido, enviado_en')
          .inFilter('conversacion_id', ids)
          .order('enviado_en', ascending: false)
          .limit(_limiteMensajesRecientes);

      // El primero de cada conversación es el último mensaje (vienen del
      // más nuevo al más viejo).
      final ultimo = <String, Map<String, dynamic>>{};
      for (final m in mensajes) {
        ultimo.putIfAbsent(m['conversacion_id'] as String, () => m);
      }
      final pendientes = <ConversacionPendiente>[];
      for (final c in conversaciones) {
        final m = ultimo[c['id'] as String];
        if (m == null || m['autor_id'] == uid) continue;
        final oficio = anidado(
          anidado(c['solicitudes_servicio'])?['oficios'],
        )?['nombre'];
        pendientes.add(
          ConversacionPendiente(
            conversacionId: c['id'] as String,
            solicitudId: c['solicitud_id'] as String,
            oficio: oficio is String ? oficio : null,
            ultimoMensaje: m['contenido'] as String,
            enviadoEn: aFecha(m['enviado_en']),
          ),
        );
      }
      pendientes.sort((a, b) => b.enviadoEn.compareTo(a.enviadoEn));
      return pendientes;
    });
  }

  /// Suficiente para cubrir el último mensaje de las conversaciones activas.
  static const int _limiteMensajesRecientes = 300;

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
