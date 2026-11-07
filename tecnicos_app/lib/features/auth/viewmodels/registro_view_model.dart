// Lógica de la pantalla de registro.
import 'package:flutter/foundation.dart';

import '../../../core/state/base_store.dart';
import '../models/registro_datos.dart';
import '../models/rol.dart';
import '../services/auth_service.dart';


class RegistroViewModel extends BaseStore<RegistroResultado> {
  RegistroViewModel(this._auth);

  final AuthService _auth;



  late final ValueNotifier<Rol> rol = createField(Rol.cliente);
  late final ValueNotifier<bool> ocultarPassword = createField(true);

  void seleccionarRol(Rol nuevo) => rol.value = nuevo;

  void alternarPassword() => ocultarPassword.value = !ocultarPassword.value;

  Future<void> registrar({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String cedula,
  }) {
    final datos = RegistroDatos(
      email: email,
      password: password,
      nombres: nombres,
      apellidos: apellidos,
      cedula: cedula,
      rol: rol.value,
    );
    return execute(() => _auth.registrar(datos));
  }
}
