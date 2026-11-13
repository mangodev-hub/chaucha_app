// Contrato de lectura de perfiles de usuario. Lanza [AppFailure] si falla.
import 'package:latlong2/latlong.dart';

import '../entities/rol.dart';
import '../entities/usuario.dart';

abstract interface class UsuarioRepository {
  /// Devuelve null si el usuario no tiene perfil registrado.
  Future<Usuario?> obtenerPorId(String id);

  Future<void> completarPerfil({
    required String cedula,
    required String codigoDactilar,
    required Rol rol,
  });

  Future<String?> registrarSelfie({required String ruta});

  /// Guarda la ubicación con la que el cliente busca técnicos.
  Future<void> actualizarUbicacion(LatLng punto);

  /// Cédula del usuario conectado (solo él la puede leer).
  Future<String?> miCedula();
}
