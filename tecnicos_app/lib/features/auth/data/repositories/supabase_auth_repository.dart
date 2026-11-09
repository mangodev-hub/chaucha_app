import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/auth_redirect.dart';
import '../../../../core/errors/app_failure.dart';
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
      .where((evento) => evento.event != AuthChangeEvent.passwordRecovery)
      .map((evento) => evento.session?.user.id)
      .distinct();

  @override
  Stream<void> get recuperacionIniciada => _auth.onAuthStateChange
      .where((evento) => evento.event == AuthChangeEvent.passwordRecovery)
      .map<void>((_) {});

  @override
  String? get usuarioId => _auth.currentUser?.id;

  @override
  Future<void> enviarRecuperacion(String email) {
    return supabaseGuard(() async {
      await _auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: AuthRedirect.url,
      );
    });
  }

  @override
  Future<void> reenviarConfirmacion(String email) {
    return supabaseGuard(() async {
      await _auth.resend(
        type: OtpType.signup,
        email: email.trim(),
        emailRedirectTo: AuthRedirect.url,
      );
    });
  }

  @override
  Future<void> cambiarContrasena(String nueva) {
    return supabaseGuard(() async {
      await _auth.updateUser(UserAttributes(password: nueva));
    });
  }
  
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
      if (respuesta.user?.identities?.isEmpty ?? false) {
        throw const AppFailure(
          'Ya existe una cuenta con ese correo. Inicia sesión.',
        );
      }
      return respuesta.session != null
          ? RegistroResultado.sesionIniciada
          : RegistroResultado.confirmarCorreo;
    });
  }
  @override
  Future<void> iniciarConGoogle() {
    return supabaseGuard(() async {
      await _auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: AuthRedirect.url,
        queryParams: {'prompt': 'select_account'},
      );
    });
  }
  @override
  Future<void> cerrarSesion() => supabaseGuard(_auth.signOut);
}

