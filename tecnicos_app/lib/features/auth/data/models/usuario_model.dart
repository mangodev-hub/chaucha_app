import '../../domain/entities/rol.dart';
import '../../domain/entities/usuario.dart';
import 'rol_db.dart';

class UsuarioModel {
  const UsuarioModel({
    required this.id,
    required this.rol,
    required this.nombres,
    required this.apellidos,
    required this.creadoEn,
    this.fotoPerfilRuta,
    this.perfilCompleto = true,
    this.verificado = false,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final identidad = json['identidades'];
    return UsuarioModel(
      perfilCompleto: identidad is List
          ? identidad.isNotEmpty
          : identidad != null,
      id: json['id'] as String,
      rol: RolDb.desdeDb(json['rol'] as String),
      nombres: json['nombres'] as String,
      apellidos: (json['apellidos'] as String?) ?? '',
      fotoPerfilRuta: json['foto_perfil_ruta'] as String?,
      creadoEn: DateTime.parse(json['creado_en'] as String),
      verificado: (json['verificado'] as bool?) ?? false,
    );
  }

  /// Columnas que se piden en el `select`.
  static const String columnas =
      'id, rol, nombres, apellidos, foto_perfil_ruta, creado_en, verificado, '
      'identidades(usuario_id)';

  final String id;
  final Rol rol;
  final String nombres;
  final String apellidos;
  final String? fotoPerfilRuta;
  final DateTime creadoEn;
  final bool perfilCompleto;
  final bool verificado;

  Usuario aEntidad() => Usuario(
    id: id,
    rol: rol,
    nombres: nombres,
    apellidos: apellidos,
    fotoPerfilRuta: fotoPerfilRuta,
    creadoEn: creadoEn,
    perfilCompleto: perfilCompleto,
    verificado: verificado,
  );
}