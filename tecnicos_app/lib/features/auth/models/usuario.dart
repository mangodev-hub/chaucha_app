// Fila de `public.usuarios` (sin la columna geográfica).
import 'rol.dart';


class Usuario {
  const Usuario({
    required this.id,
    required this.rol,
    required this.nombres,
    required this.apellidos,
    required this.creadoEn,
    this.fotoPerfilRuta,
  });




  static const String columnas =
      'id, rol, nombres, apellidos, foto_perfil_ruta, creado_en';

  final String id;
  final Rol rol;
  final String nombres;
  final String apellidos;


  final String? fotoPerfilRuta;
  final DateTime creadoEn;

  String get nombreCompleto => '$nombres $apellidos'.trim();

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      rol: Rol.desdeDb(json['rol'] as String),
      nombres: json['nombres'] as String,
      apellidos: (json['apellidos'] as String?) ?? '',
      fotoPerfilRuta: json['foto_perfil_ruta'] as String?,
      creadoEn: DateTime.parse(json['creado_en'] as String),
    );
  }
}
