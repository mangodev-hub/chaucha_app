import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../../core/media/nitidez.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import 'sesion_provider.dart';

final verificarRostroProvider =
    AsyncNotifierProvider.autoDispose<VerificarRostroNotifier, String?>(
      VerificarRostroNotifier.new,
    );

/// El estado es el motivo del último rechazo (null si no hay).
class VerificarRostroNotifier extends AsyncNotifier<String?> {
  static const String _avisoBloqueo =
      'No pudimos confirmar que eres tú. Por seguridad cerramos la sesión; '
      'vuelve a iniciarla para intentarlo de nuevo.';

  @override
  FutureOr<String?> build() => null;

  Future<void> enviar(Uint8List bytes) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard<String?>(() async {
      // Una foto borrosa no gasta intento: se rechaza antes de enviarla.
      if (!await compute(esNitida, bytes)) {
        return 'La foto salió borrosa, inténtalo de nuevo.';
      }
      final r = await ref
          .read(usuarioRepositoryProvider)
          .verificarRostroSesion(bytes);
      final sesion = ref.read(sesionProvider.notifier);
      if (r.verificado) {
        sesion.marcarRostroVerificado();
        return null;
      }
      if (r.bloqueado) {
        await sesion.cerrarSesionConAviso(_avisoBloqueo);
        return null;
      }
      final motivo = r.motivo ?? 'Tu rostro no coincide con tu foto de perfil.';
      return switch (r.intentosRestantes) {
        1 => '$motivo Te queda 1 intento.',
        final n => '$motivo Te quedan $n intentos.',
      };
    });
    if (ref.mounted) state = resultado;
  }
}
