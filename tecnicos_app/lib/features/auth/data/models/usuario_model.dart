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
    this.fotoRostroValidada = false,
    this.perfilCompleto = true,
    this.verificado = false,
    this.suspendidoHasta,
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
      fotoRostroValidada: (json['foto_rostro_validada'] as bool?) ?? false,
      creadoEn: DateTime.parse(json['creado_en'] as String),
      verificado: (json['verificado'] as bool?) ?? false,
      suspendidoHasta: switch (json['suspendido_hasta']) {
        final String s => DateTime.parse(s).toLocal(),
        _ => null,
      },
    );
  }

  /// Columnas que se piden en el `select`.
  static const String columnas =
      'id, rol, nombres, apellidos, foto_perfil_ruta, creado_en, verificado, foto_rostro_validada, suspendido_hasta,'
      'identidades(usuario_id)';

  final String id;
  final Rol rol;
  final String nombres;
  final String apellidos;
  final String? fotoPerfilRuta;
  final bool fotoRostroValidada;
  final DateTime creadoEn;
  final bool perfilCompleto;
  final bool verificado;
  final DateTime? suspendidoHasta;

  Usuario aEntidad() => Usuario(
    id: id,
    rol: rol,
    nombres: nombres,
    apellidos: apellidos,
    fotoPerfilRuta: fotoPerfilRuta,
    fotoRostroValidada: fotoRostroValidada,
    creadoEn: creadoEn,
    perfilCompleto: perfilCompleto,
    verificado: verificado,
    suspendidoHasta: suspendidoHasta,
  );
}
