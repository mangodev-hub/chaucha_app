// Envío del formulario de login. Si sale bien, el router redirige solo
// (escucha a `sesionProvider`).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_auth_repository.dart';

final loginProvider = AsyncNotifierProvider.autoDispose<LoginNotifier, void>(
  LoginNotifier.new,
);

class LoginNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}
  Future<void> iniciarConGoogle() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(authRepositoryProvider).iniciarConGoogle(),
    );
    if (ref.mounted) state = resultado;
  }

  Future<void> iniciarSesion({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref
          .read(authRepositoryProvider)
          .iniciarSesion(email: email, password: password),
    );
    if (ref.mounted) state = resultado;
  }
}
