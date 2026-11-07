// Implementa perfil_service para la aplicación.
import '../models/perfil_tecnico.dart';

abstract interface class PerfilService {
  Future<PerfilTecnico> miPerfilTecnico();

  Future<void> guardar(CambiosPerfil cambios);

  Future<void> crearResena(NuevaResena resena);
}
