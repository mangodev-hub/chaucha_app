// Contrato del panel de administrador. Los métodos lanzan [AppFailure] si
// fallan (incluido "Solo el administrador puede hacer esto.").
import '../../../auth/domain/entities/registro_datos.dart';
import '../entities/resumen_admin.dart';
import '../entities/revision_tecnico.dart';
import '../entities/solicitud_admin.dart';
import '../entities/usuario_admin.dart';

abstract interface class AdminRepository {
  Future<ResumenAdmin> resumen();

  /// Todas las solicitudes, de la más reciente a la más antigua.
  Future<List<SolicitudAdmin>> solicitudes();

  /// Todos los usuarios, del más reciente al más antiguo.
  Future<List<UsuarioAdmin>> usuarios();

  /// Crea un cliente o técnico con el mismo registro de la app: recibe el
  /// correo de confirmación. No cambia la sesión del administrador.
  Future<void> crearUsuario(RegistroDatos datos);

  Future<void> actualizarUsuario(String id, CambiosUsuario cambios);

  Future<void> suspenderUsuario(String id, {required bool suspendido});

  /// Solo si no tiene historial; si lo tiene, lanza un AppFailure que
  /// sugiere suspenderlo.
  Future<void> eliminarUsuario(String id);

  /// Técnicos con algún documento pendiente, con sus documentos firmados.
  Future<List<RevisionTecnico>> revisionesPendientes();

  Future<void> revisarDocumento(String documentoId, {required bool aprobado});
}
