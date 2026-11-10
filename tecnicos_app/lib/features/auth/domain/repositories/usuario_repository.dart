// Contrato de lectura de perfiles de usuario. Lanza [AppFailure] si falla.
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
}
