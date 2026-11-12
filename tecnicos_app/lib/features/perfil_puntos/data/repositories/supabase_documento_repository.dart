// Implementación de [DocumentoRepository] con Supabase (tabla + Storage).
// Ruta en Storage: `{id_del_tecnico}/{tipo}_{marcaDeTiempo}.jpg`.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';
import '../../domain/repositories/documento_repository.dart';
import '../models/documento_db.dart';
import '../models/documento_tecnico_model.dart';

final documentoRepositoryProvider = Provider<DocumentoRepository>(
  (ref) => SupabaseDocumentoRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
  ),
);

class SupabaseDocumentoRepository implements DocumentoRepository {
  SupabaseDocumentoRepository(this._client, this._storage);

  static const String _tabla = 'documentos_tecnico';

  final SupabaseClient _client;
  final StorageService _storage;

  @override
  Future<Verificacion> miVerificacion() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(DocumentoTecnicoModel.columnas)
          .eq('tecnico_id', _client.uidActual);
      final vigentes = Verificacion.vigentes(
        filas
            .map((fila) => DocumentoTecnicoModel.fromJson(fila).aEntidad())
            .toList(),
      );

      // Solo se firman las URLs de los documentos vigentes.
      final conUrl = await Future.wait(
        vigentes.values.map(
          (doc) async => doc.conUrl(
            await _storage.urlFirmada(
              bucket: Buckets.documentos,
              ruta: doc.ruta,
            ),
          ),
        ),
      );
      return Verificacion({for (final doc in conUrl) doc.tipo: doc});
    });
  }

  @override
  Future<void> subir(TipoDocumento tipo, Uint8List bytes) {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      final ruta =
          '$uid/${tipo.valorDb}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _storage.subirImagen(
        bucket: Buckets.documentos,
        ruta: ruta,
        bytes: bytes,
      );
      final previo = await _client
          .from(_tabla)
          .select('tipo')
          .eq('tecnico_id', uid)
          .eq('tipo', tipo.valorDb)
          .maybeSingle();
      if (previo == null) {
        await _client.from(_tabla).insert({
          'tecnico_id': uid,
          'tipo': tipo.valorDb,
          'ruta_archivo': ruta,
        });
      } else {
        await _client
            .from(_tabla)
            .update({
              'ruta_archivo': ruta,
              'estado': 'pendiente',
              'revisado_por': null,
              'revisado_en': null,
            })
            .eq('tecnico_id', uid)
            .eq('tipo', tipo.valorDb);
      }
      if (tipo == TipoDocumento.cedulaFrontal) _compararRostro();
    });
  }

  // Apoyo a la revisión: guarda el resultado en `comparaciones_rostro`.
  // No bloquea ni afecta la subida si falla.
  void _compararRostro() {
    unawaited(
      _client.functions
          .invoke('comparar-rostro-cedula')
          .then((_) {}, onError: (_) {}),
    );
  }
}