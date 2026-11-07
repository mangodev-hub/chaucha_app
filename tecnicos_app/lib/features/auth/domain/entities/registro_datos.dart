// Datos del formulario de registro, ya validados por la vista.
import 'rol.dart';

class RegistroDatos {
  RegistroDatos({
    required this.email,
    required this.password,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.rol,
  }) : assert(Rol.registrables.contains(rol), 'No se puede registrar $rol');

  final String email;
  final String password;
  final String nombres;
  final String apellidos;
  final String cedula;
  final Rol rol;
}
