import '../../../auth/domain/entities/rol.dart';

class UsuarioAdmin {
  const UsuarioAdmin({
    required this.id,
    required this.email,
    required this.rol,
    required this.nombres,
    required this.apellidos,
    required this.ciudad,
    required this.suspendido,
    required this.creadoEn,
    this.cedula,
    this.verificado,
  });

  final String id;
  final String email;
  final Rol rol;
  final String nombres;
  final String apellidos;
  final String ciudad;

  /// Null si aún no completó el perfil (por ejemplo, entró con Google).
  final String? cedula;

  /// Solo para técnicos: si su identidad ya fue verificada.
  final bool? verificado;

  /// Si es true, no puede iniciar sesión.
  final bool suspendido;
  final DateTime creadoEn;

  String get nombreCompleto => '$nombres $apellidos'.trim();

  bool get esAdmin => rol == Rol.admin;

  /// Coincide con la búsqueda por nombre, correo o cédula.
  bool coincide(String texto) {
    final buscado = texto.trim().toLowerCase();
    if (buscado.isEmpty) return true;
    return nombreCompleto.toLowerCase().contains(buscado) ||
        email.toLowerCase().contains(buscado) ||
        (cedula?.contains(buscado) ?? false);
  }
}

/// Datos que el administrador puede editar de un usuario.
class CambiosUsuario {
  const CambiosUsuario({
    required this.nombres,
    required this.apellidos,
    required this.ciudad,
  });

  final String nombres;
  final String apellidos;
  final String ciudad;
}
