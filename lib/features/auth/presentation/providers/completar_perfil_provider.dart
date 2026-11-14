import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import '../../domain/entities/rol.dart';
import 'sesion_provider.dart';

final completarPerfilProvider =
    AsyncNotifierProvider.autoDispose<CompletarPerfilNotifier, void>(
      CompletarPerfilNotifier.new,
    );

class CompletarPerfilNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> completar({
    required String nombres,
    required String apellidos,
    required String cedula,
    required String codigoDactilar,
    required Rol rol,
  }) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final resultado = await asyncGuard(() async {
      await ref
          .read(usuarioRepositoryProvider)
          .completarPerfil(
            nombres: nombres,
            apellidos: apellidos,
            cedula: cedula,
            codigoDactilar: codigoDactilar,
            rol: rol,
          );
      await ref.read(sesionProvider.notifier).recargarUsuario();
    });
    if (ref.mounted) state = resultado;
  }
}
