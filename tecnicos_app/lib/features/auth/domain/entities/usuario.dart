import 'rol.dart';

class Usuario {
  const Usuario({
    required this.id,
    required this.rol,
    required this.nombres,
    required this.apellidos,
    required this.creadoEn,
    this.fotoPerfilRuta,
    this.fotoRostroValidada = false,
    this.perfilCompleto = true,
    this.verificado = false,
  });

  final String id;
  final Rol rol;
  final String nombres;
  final String apellidos;
  final bool perfilCompleto;
  final bool verificado;
  final String? fotoPerfilRuta;
  final bool fotoRostroValidada;
  final DateTime creadoEn;

  String get nombreCompleto => '$nombres $apellidos'.trim();

  bool get fotoVerificada => fotoPerfilRuta != null && fotoRostroValidada;
}