import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../hilos/hilos.dart';
import '../supabase/supabase_guard.dart';

abstract final class Buckets {
  static const String solicitudes = 'solicitudes';
  static const String documentos = 'cedulas';
  static const String perfiles = 'perfiles';

  /// Público: imágenes de la publicidad.
  static const String anuncios = 'anuncios';

  /// Privado: fotos de evidencia de los reclamos (`{uid}/{id}.jpg`).
  static const String reclamos = 'reclamos';
}

abstract interface class StorageService {
  Future<void> subirImagen({
    required String bucket,
    required String ruta,
    required Uint8List bytes,
  });
  String urlPublica({required String bucket, required String ruta});
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
      // Se reduce y pasa a JPEG en otro hilo antes de subirla.
      final foto = await Hilos.prepararFoto(bytes);
      await _client.storage
          .from(bucket)
          .uploadBinary(
            ruta,
            foto,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
    });
  }

  @override
  Future<String> urlFirmada({required String bucket, required String ruta}) {
    return supabaseGuard(
      () =>
          _client.storage.from(bucket).createSignedUrl(ruta, _segundosValidez),
    );
  }

  @override
  String urlPublica({required String bucket, required String ruta}) =>
      _client.storage.from(bucket).getPublicUrl(ruta);
}
