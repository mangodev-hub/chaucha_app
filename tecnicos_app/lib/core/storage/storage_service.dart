// Nombres de buckets. Deben existir en Supabase > Storage como PRIVADOS.
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_guard.dart';


abstract final class Buckets {
  static const String solicitudes = 'solicitudes';
  static const String documentos = 'cedulas';
}


abstract interface class StorageService {
  Future<void> subirImagen({
    required String bucket,
    required String ruta,
    required Uint8List bytes,
  });


  Future<String> urlFirmada({required String bucket, required String ruta});
}

class SupabaseStorageService implements StorageService {
  SupabaseStorageService(this._client);

  static const int _segundosValidez = 3600;

  final SupabaseClient _client;

  @override
  Future<void> subirImagen({
    required String bucket,
    required String ruta,
    required Uint8List bytes,
  }) {
    return supabaseGuard(() async {
      await _client.storage.from(bucket).uploadBinary(
            ruta,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
    });
  }

  @override
  Future<String> urlFirmada({required String bucket, required String ruta}) {
    return supabaseGuard(
      () => _client.storage.from(bucket).createSignedUrl(ruta, _segundosValidez),
    );
  }
}
