import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/async_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_perfil_repository.dart';
import '../../domain/entities/cambios_perfil.dart';
import '../../domain/entities/perfil_tecnico.dart';

/// Se recarga si cambia el usuario conectado (no mezcla datos de cuentas).
final perfilTecnicoProvider = FutureProvider.autoDispose<PerfilTecnico>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(perfilRepositoryProvider).miPerfilTecnico();
});

final guardarPerfilProvider =
    AsyncNotifierProvider.autoDispose<GuardarPerfilNotifier, void>(
      GuardarPerfilNotifier.new,
    );

class GuardarPerfilNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Devuelve true si se guardó. Al guardar, recarga [perfilTecnicoProvider].
  Future<bool> guardar(CambiosPerfil cambios) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(() async {
      if (cambios.oficioIds.isEmpty) {
        throw const AppFailure('Selecciona al menos un oficio.');
      }
      await ref.read(perfilRepositoryProvider).guardar(cambios);
    });
    if (!ref.mounted) return !resultado.hasError;

    state = resultado;
    if (!resultado.hasError) ref.invalidate(perfilTecnicoProvider);
    return !resultado.hasError;
  }
}
