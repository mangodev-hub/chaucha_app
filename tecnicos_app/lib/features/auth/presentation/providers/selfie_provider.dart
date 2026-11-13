import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../../core/media/nitidez.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import 'sesion_provider.dart';

final selfieProvider =
    AsyncNotifierProvider.autoDispose<SelfieNotifier, String?>(
      SelfieNotifier.new,
    );

/// El estado es el motivo de rechazo (null si no hay).
class SelfieNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  Future<void> enviar(Uint8List bytes) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard<String?>(() async {
      if (!await compute(esNitida, bytes)) {
        return 'La foto salió borrosa, inténtalo de nuevo.';
      }
      final uid = ref.read(supabaseClientProvider).auth.currentUser!.id;
      final ruta = '$uid/selfie_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await ref
          .read(storageServiceProvider)
          .subirImagen(bucket: Buckets.perfiles, ruta: ruta, bytes: bytes);
      final motivo = await ref
          .read(usuarioRepositoryProvider)
          .registrarSelfie(ruta: ruta);
      if (motivo == null) {
        await ref.read(sesionProvider.notifier).recargarUsuario();
      }
      return motivo;
    });
    if (ref.mounted) state = resultado;
  }
}
