// Lógica de la pantalla de login.
import 'package:flutter/foundation.dart';

import '../../../core/state/base_store.dart';
import '../services/auth_service.dart';






class LoginViewModel extends BaseStore<void> {
  LoginViewModel(this._auth);

  final AuthService _auth;

  late final ValueNotifier<bool> ocultarPassword = createField(true);

  void alternarPassword() => ocultarPassword.value = !ocultarPassword.value;

  Future<void> iniciarSesion({required String email, required String password}) {
    return execute(() => _auth.iniciarSesion(email: email, password: password));
  }
}
