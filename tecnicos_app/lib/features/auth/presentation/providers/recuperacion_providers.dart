import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import 'sesion_provider.dart';

final recuperarProvider =
    AsyncNotifierProvider.autoDispose<RecuperarNotifier, bool>(
  RecuperarNotifier.new,
);

class RecuperarNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> enviar(String email) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard(() async {
      await ref.read(authRepositoryProvider).enviarRecuperacion(email);
      return true;
    });
    if (ref.mounted) state = resultado;
  }
}

final restablecerProvider =
    AsyncNotifierProvider.autoDispose<RestablecerNotifier, void>(
  RestablecerNotifier.new,
);

class RestablecerNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> cambiar(String nueva) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(() async {
      await ref.read(authRepositoryProvider).cambiarContrasena(nueva);
      await ref.read(sesionProvider.notifier).finalizarRecuperacion();
    });
    if (ref.mounted) state = resultado;
    return !resultado.hasError;
  }
}

final reenviarConfirmacionProvider =
    AsyncNotifierProvider.autoDispose<ReenviarConfirmacionNotifier, void>(
  ReenviarConfirmacionNotifier.new,
);

class ReenviarConfirmacionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> reenviar(String email) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(authRepositoryProvider).reenviarConfirmacion(email),
    );
    if (ref.mounted) state = resultado;
  }
}