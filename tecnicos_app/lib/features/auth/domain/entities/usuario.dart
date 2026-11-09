// Usuario de la app (perfil de `public.usuarios`).
import 'rol.dart';

class Usuario {
  const Usuario({
    required this.id,
    required this.rol,
    required this.nombres,
    required this.apellidos,
    required this.creadoEn,
    this.fotoPerfilRuta,
    this.perfilCompleto = true,
  });

  final String id;
  final Rol rol;
  final String nombres;
  final String apellidos;
  final bool perfilCompleto;

  /// Ruta del archivo en Storage (no una URL).
  final String? fotoPerfilRuta;
  final DateTime creadoEn;

  String get nombreCompleto => '$nombres $apellidos'.trim();
}
