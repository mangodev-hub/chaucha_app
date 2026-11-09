// Envío del formulario de registro. El estado es null hasta que se registra.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import '../../domain/entities/registro_datos.dart';
import '../../domain/entities/registro_resultado.dart';
import '../../domain/entities/rol.dart';

final registroProvider =
    AsyncNotifierProvider.autoDispose<RegistroNotifier, RegistroResultado?>(
  RegistroNotifier.new,
);

class RegistroNotifier extends AsyncNotifier<RegistroResultado?> {
  @override
  FutureOr<RegistroResultado?> build() => null;

  Future<void> registrar({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String cedula,
    required Rol rol,
    required String codigoDactilar,
  }) async {
    final datos = RegistroDatos(
      email: email,
      password: password,
      nombres: nombres,
      apellidos: apellidos,
      cedula: cedula,
      rol: rol,
      codigoDactilar: codigoDactilar,
    );
    state = const AsyncLoading();
    final resultado =
        await asyncGuard(() => ref.read(authRepositoryProvider).registrar(datos));
    if (ref.mounted) state = resultado;
  }
}
