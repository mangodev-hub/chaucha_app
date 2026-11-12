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
import '../../domain/entities/resumen_chat.dart';
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

  @override
  Future<List<ResumenChat>> misChats() {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      final conversaciones = await _client
          .from('conversaciones')
          .select(
            'id, tecnico_id, solicitudes_servicio(cliente_id, oficios(nombre))',
          );
      if (conversaciones.isEmpty) return const <ResumenChat>[];

      final ids = [for (final c in conversaciones) c['id'] as String];
      final mensajes = await _client
          .from('mensajes')
          .select('conversacion_id, autor_id, contenido, enviado_en')
          .inFilter('conversacion_id', ids)
          .order('enviado_en', ascending: false)
          .limit(_limiteMensajesRecientes);
      final ultimo = <String, Map<String, dynamic>>{};
      for (final m in mensajes) {
        ultimo.putIfAbsent(m['conversacion_id'] as String, () => m);
      }

      String otroId(Map<String, dynamic> c) {
        final tecnico = c['tecnico_id'] as String;
        if (tecnico != uid) return tecnico;
        return (anidado(c['solicitudes_servicio'])?['cliente_id'] as String?) ??
            '';
      }

      final otros = {for (final c in conversaciones) otroId(c)}..remove('');
      final nombres = <String, String>{};
      if (otros.isNotEmpty) {
        final usuarios = await _client
            .from('usuarios')
            .select('id, nombres, apellidos')
            .inFilter('id', otros.toList());
        for (final u in usuarios) {
          nombres[u['id'] as String] =
              '${u['nombres'] ?? ''} ${u['apellidos'] ?? ''}'.trim();
        }
      }

      final chats = <ResumenChat>[];
      for (final c in conversaciones) {
        final m = ultimo[c['id'] as String];
        final oficio = anidado(
          anidado(c['solicitudes_servicio'])?['oficios'],
        )?['nombre'];
        final nombre = nombres[otroId(c)] ?? '';
        chats.add(
          ResumenChat(
            conversacionId: c['id'] as String,
            otroNombre: nombre.isEmpty ? 'Usuario' : nombre,
            otroId: otroId(c),
            oficio: oficio is String ? oficio : null,
            ultimoMensaje: m?['contenido'] as String?,
            enviadoEn: m == null ? null : aFecha(m['enviado_en']),
            esMio: m?['autor_id'] == uid,
          ),
        );
      }
      chats.sort((a, b) {
        final fa = a.enviadoEn;
        final fb = b.enviadoEn;
        if (fa == null && fb == null) return 0;
        if (fa == null) return 1;
        if (fb == null) return -1;
        return fb.compareTo(fa);
      });
      return chats;
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
      final id = await _client.rpc(
        'iniciar_conversacion',
        params: {'p_solicitud': solicitudId, 'p_tecnico': tecnicoId},
      );
      return id as String;
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
