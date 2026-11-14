import '../entities/calificacion_pendiente.dart';
import '../entities/cambios_perfil.dart';
import '../entities/nivel.dart';
import '../entities/nueva_resena.dart';
import '../entities/perfil_publico.dart';
import '../entities/perfil_tecnico.dart';

abstract interface class PerfilRepository {
  /// Perfil del técnico conectado.
  Future<PerfilTecnico> miPerfilTecnico();

  /// Guarda los datos editables y sincroniza sus oficios.
  Future<void> guardar(CambiosPerfil cambios);

  Future<void> crearResena(NuevaResena resena);

  /// Servicios completados (últimos 14 días) que la persona conectada aún
  /// no califica, del más reciente al más antiguo.
  Future<List<CalificacionPendiente>> calificacionesPendientes();

  /// Perfil de cualquier técnico tal como lo ve un cliente.
  Future<PerfilPublico> perfilPublico(String tecnicoId);

  /// Niveles de gamificación, de menos a más puntos.
  Future<List<Nivel>> niveles();
}
