// Implementación de [AuthService] con Supabase Auth .
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/auth_redirect.dart';
import '../../../core/supabase/supabase_guard.dart';
import '../models/registro_datos.dart';
import 'auth_service.dart';


class SupabaseAuthService implements AuthService {
  SupabaseAuthService(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  Stream<String?> get cambiosDeSesion => _auth.onAuthStateChange
      .map((evento) => evento.session?.user.id)


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
