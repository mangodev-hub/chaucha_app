import 'package:latlong2/latlong.dart';

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
    this.verificacionVista = true,
    this.dadoDeBaja = false,
    this.suspendidoHasta,
    this.ciudad,
    this.ubicacionRegistro,
  });

  final String id;
  final Rol rol;
  final String nombres;
  final String apellidos;
  final bool perfilCompleto;
  final bool verificado;

  /// false: quedó verificado y aún no vio la celebración.
  final bool verificacionVista;

  /// Se dio de baja: la cuenta está desactivada y no puede entrar.
  final bool dadoDeBaja;
  final String? fotoPerfilRuta;
  final bool fotoRostroValidada;
  final DateTime creadoEn;

  /// Fin de la sanción por reseñas negativas (null si nunca la tuvo).
  final DateTime? suspendidoHasta;
  final String? ciudad;

  /// Ubicación que eligió el cliente para buscar técnicos cercanos.
  final LatLng? ubicacionRegistro;

  bool get estaSuspendido =>
      suspendidoHasta != null && suspendidoHasta!.isAfter(DateTime.now());

  String get nombreCompleto => '$nombres $apellidos'.trim();

  bool get fotoVerificada => fotoPerfilRuta != null && fotoRostroValidada;
}
