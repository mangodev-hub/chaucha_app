// Implementación de [AuthRepository] con Supabase Auth.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/auth_redirect.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/registro_datos.dart';
import '../../domain/entities/registro_resultado.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/registro_datos_db.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SupabaseAuthRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  Stream<String?> get cambiosDeSesion => _auth.onAuthStateChange
      .map((evento) => evento.session?.user.id)
      // Los refrescos de token no cambian el usuario: no deben recargar.
      .distinct();

  @override
  Future<void> iniciarSesion({
    required String email,
    required String password,
  }) {
    return supabaseGuard(() async {
      await _auth.signInWithPassword(email: email.trim(), password: password);
    });
  }

  @override
  Future<RegistroResultado> registrar(RegistroDatos datos) {
    return supabaseGuard(() async {
      final respuesta = await _auth.signUp(
        email: datos.email.trim(),
        password: datos.password,
        data: datos.toMetadata(),
        emailRedirectTo: AuthRedirect.url,
      );
      return respuesta.session != null
          ? RegistroResultado.sesionIniciada
          : RegistroResultado.confirmarCorreo;
    });
  }

  @override
  Future<void> cerrarSesion() => supabaseGuard(_auth.signOut);
}
