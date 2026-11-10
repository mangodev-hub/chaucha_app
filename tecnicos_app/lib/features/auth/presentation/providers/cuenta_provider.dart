import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_auth_repository.dart';

final cuentaProvider = AsyncNotifierProvider.autoDispose<CuentaNotifier, void>(
  CuentaNotifier.new,
);

class CuentaNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> cambiarContrasena({
    required String actual,
    required String nueva,
  }) => _ejecutar(
    () => ref
        .read(authRepositoryProvider)
        .cambiarContrasenaConActual(actual: actual, nueva: nueva),
  );

  Future<bool> cambiarCorreo({
    required String contrasena,
    required String nuevo,
  }) => _ejecutar(
    () => ref
        .read(authRepositoryProvider)
        .cambiarCorreo(contrasena: contrasena, nuevo: nuevo),
  );

  Future<bool> _ejecutar(Future<void> Function() accion) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(accion);
    if (ref.mounted) state = resultado;
    return !resultado.hasError;
  }
}
