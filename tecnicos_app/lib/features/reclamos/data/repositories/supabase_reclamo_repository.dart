import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/reclamo.dart';
import '../../domain/repositories/reclamo_repository.dart';
import '../models/reclamo_model.dart';

final reclamoRepositoryProvider = Provider<ReclamoRepository>(
  (ref) => SupabaseReclamoRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
  ),
);

class SupabaseReclamoRepository implements ReclamoRepository {
  SupabaseReclamoRepository(this._client, this._storage);

  final SupabaseClient _client;
  final StorageService _storage;

  static String _idAleatorio() {
    final r = Random.secure();
    return List.generate(
      16,
      (_) => r.nextInt(256),
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  @override
  Future<String> subirEvidencia(Uint8List bytes) async {
    final ruta = '${_client.uidActual}/${_idAleatorio()}.jpg';
    await _storage.subirImagen(
      bucket: Buckets.reclamos,
      ruta: ruta,
      bytes: bytes,
    );
    return ruta;
  }

  @override
  Future<String> urlEvidencia(String ruta) =>
      _storage.urlFirmada(bucket: Buckets.reclamos, ruta: ruta);

  @override
  Future<Reclamo> crear({
    required String solicitudId,
    required CategoriaReclamo categoria,
    required String descripcion,
    required List<String> evidencias,
  }) {
    return supabaseGuard(() async {
      final fila = await _client.rpc<Map<String, dynamic>>(
        'crear_reclamo',
        params: {
          'p_solicitud_id': solicitudId,
          'p_categoria': categoria.db,
          'p_descripcion': descripcion.trim(),
          'p_evidencias': evidencias,
        },
      );
      return obtener(fila['id'] as String);
    });
  }

  @override
  Future<List<Reclamo>> misReclamos() {
    return supabaseGuard(() async {
      final filas = await _client
          .from('reclamos')
          .select(ReclamoModel.columnas)
          .eq('autor_id', _client.uidActual)
          .order('creado_en', ascending: false);
      return filas.map(ReclamoModel.desdeFila).toList();
    });
  }

  @override
  Future<Reclamo> obtener(String id) {
    return supabaseGuard(() async {
      final fila = await _client
          .from('reclamos')
          .select(ReclamoModel.columnas)
          .eq('id', id)
          .maybeSingle();
      if (fila == null) throw const AppFailure('No encontramos ese reclamo.');
      return ReclamoModel.desdeFila(fila);
    });
  }

  @override
  Future<Reclamo?> abiertoDeSolicitud(String solicitudId) {
    return supabaseGuard(() async {
      final fila = await _client
          .from('reclamos')
          .select(ReclamoModel.columnas)
          .eq('solicitud_id', solicitudId)
          .eq('autor_id', _client.uidActual)
          .inFilter('estado', [for (final e in EstadoReclamo.abiertos) e.db])
          .maybeSingle();
      return fila == null ? null : ReclamoModel.desdeFila(fila);
    });
  }

  @override
  Stream<List<MensajeReclamo>> mensajes(String reclamoId) {
    return _client
        .from('reclamo_mensajes')
        .stream(primaryKey: ['id'])
        .eq('reclamo_id', reclamoId)
        .order('creado_en', ascending: true)
        .map((filas) => filas.map(ReclamoModel.mensajeDesdeFila).toList())
        .transform(_errorDeConexion);
  }

  @override
  Future<void> responder(String reclamoId, String texto) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'responder_reclamo',
        params: {'p_reclamo_id': reclamoId, 'p_texto': texto.trim()},
      );
    });
  }

  @override
  Future<List<Reclamo>> todos({required Set<EstadoReclamo> estados}) {
    return supabaseGuard(() async {
      final filas = await _client
          .from('reclamos')
          .select(ReclamoModel.columnas)
          .inFilter('estado', [for (final e in estados) e.db])
          .order('creado_en', ascending: true);
      return filas.map(ReclamoModel.desdeFila).toList();
    });
  }

  @override
  Future<int> contarRecibidos() {
    return supabaseGuard(
      () => _client
          .from('reclamos')
          .count(CountOption.exact)
          .eq('estado', EstadoReclamo.recibido.db),
    );
  }

  @override
  Future<void> gestionar(
    String reclamoId,
    EstadoReclamo estado, {
    String? mensaje,
  }) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'admin_gestionar_reclamo',
        params: {
          'p_reclamo_id': reclamoId,
          'p_estado': estado.db,
          'p_mensaje': mensaje?.trim(),
        },
      );
    });
  }
}

final _errorDeConexion =
    StreamTransformer<List<MensajeReclamo>, List<MensajeReclamo>>.fromHandlers(
      handleError: (error, stackTrace, sink) => sink.addError(
        error is AppFailure
            ? error
            : AppFailure(
                'No se pudo cargar la conversación. Revisa tu conexión.',
                cause: error,
              ),
        stackTrace,
      ),
    );
