// Documentos de verificación de identidad y su subida.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_documento_repository.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';

/// Se recarga si cambia el usuario conectado (no mezcla datos de cuentas).
final verificacionProvider = FutureProvider.autoDispose<Verificacion>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(documentoRepositoryProvider).miVerificacion();
});

final subirDocumentoProvider =
    AsyncNotifierProvider.autoDispose<SubirDocumentoNotifier, void>(
      SubirDocumentoNotifier.new,
    );

class SubirDocumentoNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Devuelve true si se subió. Al subir, recarga [verificacionProvider].
  Future<bool> subir(TipoDocumento tipo, Uint8List bytes) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(documentoRepositoryProvider).subir(tipo, bytes),
    );
    if (!ref.mounted) return !resultado.hasError;

    state = resultado;
    if (!resultado.hasError) ref.invalidate(verificacionProvider);
    return !resultado.hasError;
  }
}
