// Ruta: `{id_del_tecnico}/{tipo}_{marcaDeTiempo}.jpg`.
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/storage/storage_service.dart';
import '../../../core/supabase/supabase_extensions.dart';
import '../../../core/supabase/supabase_guard.dart';
import '../models/documento_tecnico.dart';
import 'documento_service.dart';

class SupabaseDocumentoService implements DocumentoService {
  SupabaseDocumentoService(this._client, this._storage);

  static const String _tabla = 'documentos_tecnico';

  final SupabaseClient _client;
  final StorageService _storage;

  @override
  Future<Verificacion> miVerificacion() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(DocumentoTecnico.columnas)
          .eq('tecnico_id', _client.uidActual);
      final vigentes =
          DocumentoTecnico.vigentes(filas.map(DocumentoTecnico.fromJson).toList());

      final conUrl = await Future.wait(
        vigentes.values.map((doc) async => doc.conUrl(
              await _storage.urlFirmada(bucket: Buckets.documentos, ruta: doc.ruta),
            )),
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
      await _client.from(_tabla).insert({
        'tecnico_id': uid,
        'tipo': tipo.valorDb,
        'ruta_archivo': ruta,
      });
    });
  }
}