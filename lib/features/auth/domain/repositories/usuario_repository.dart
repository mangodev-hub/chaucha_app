import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

import '../entities/resultado_rostro.dart';
import '../entities/rol.dart';
import '../entities/usuario.dart';

abstract interface class UsuarioRepository {
  /// Devuelve null si el usuario no tiene perfil registrado.
  Future<Usuario?> obtenerPorId(String id);

  /// Nombres y apellidos como aparecen en la cédula: los de la cuenta de
  /// Google pueden ser un seudónimo.
  Future<void> completarPerfil({
    required String nombres,
    required String apellidos,
    required String cedula,
    required String codigoDactilar,
    required Rol rol,
  });

  Future<String?> registrarSelfie({required String ruta});

  /// ¿La sesión de login actual ya confirmó el rostro?
  Future<bool> rostroSesionVerificado();

  /// Compara una selfie en vivo con la foto de perfil (no se guarda).
  Future<ResultadoRostro> verificarRostroSesion(Uint8List selfie);

  /// El técnico confirmó su identidad con la biometría del celular para
  /// enviar una oferta.
  Future<void> registrarVerificacionPostulacion();

  /// Confirma la identidad para ofertar con una foto en vivo contra la foto
  /// de perfil (cuando no hay biometría).
  Future<ResultadoRostro> verificarRostroPostulacion(Uint8List foto);

  /// Guarda la ubicación con la que el cliente busca técnicos.
  Future<void> actualizarUbicacion(LatLng punto);

  /// Desactiva la cuenta: cancela sus solicitudes activas, retira sus
  /// ofertas y deja de estar verificada.
  Future<void> darseDeBaja();

  /// Ya vio la celebración de su cuenta verificada.
  Future<void> marcarVerificacionVista();

  /// Cédula del usuario conectado (solo él la puede leer).
  Future<String?> miCedula();
}
