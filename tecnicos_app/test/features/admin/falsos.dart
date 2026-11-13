// Repositorio falso y datos de prueba del panel de administrador.
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/admin/domain/entities/resumen_admin.dart';
import 'package:tecnicos_app/features/admin/domain/entities/revision_tecnico.dart';
import 'package:tecnicos_app/features/admin/domain/entities/solicitud_admin.dart';
import 'package:tecnicos_app/features/admin/domain/entities/usuario_admin.dart';
import 'package:tecnicos_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:tecnicos_app/features/auth/domain/entities/registro_datos.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/documento_tecnico.dart';

UsuarioAdmin usuarioAdminDePrueba({
  String id = 'u1',
  Rol rol = Rol.cliente,
  bool suspendido = false,
}) => UsuarioAdmin(
  id: id,
  email: '$id@correo.com',
  rol: rol,
  nombres: 'Ana',
  apellidos: 'Pérez',
  ciudad: 'Quito',
  cedula: '1710034065',
  verificado: rol == Rol.tecnico ? false : null,
  suspendido: suspendido,
  creadoEn: DateTime(2026),
);

RevisionTecnico revisionDePrueba({String tecnicoId = 't1'}) => RevisionTecnico(
  tecnicoId: tecnicoId,
  nombre: 'Luis Andrade',
  cedula: '1710034065',
  documentos: const [
    DocumentoTecnico(
      id: 'd1',
      tipo: TipoDocumento.cedulaFrontal,
      estado: EstadoDocumento.pendiente,
      ruta: 't1/cedula_frontal.jpg',
    ),
    DocumentoTecnico(
      id: 'd2',
      tipo: TipoDocumento.cedulaPosterior,
      estado: EstadoDocumento.aprobada,
      ruta: 't1/cedula_posterior.jpg',
    ),
    DocumentoTecnico(
      id: 'd3',
      tipo: TipoDocumento.selfie,
      estado: EstadoDocumento.pendiente,
      ruta: 't1/selfie.jpg',
    ),
  ],
);

class AdminFalso implements AdminRepository {
  List<UsuarioAdmin> listaUsuarios = [usuarioAdminDePrueba()];
  List<RevisionTecnico> listaRevisiones = [revisionDePrueba()];

  int consultasDeUsuarios = 0;
  int consultasDeRevisiones = 0;
  int consultasDeResumen = 0;

  final creados = <RegistroDatos>[];
  final actualizados = <(String, CambiosUsuario)>[];
  final suspensiones = <(String, bool)>[];
  final eliminados = <String>[];
  final revisados = <(String, bool)>[];

  /// Si no es null, las escrituras lanzan este error.
  AppFailure? falla;

  void _quizasFallar() {
    if (falla case final error?) throw error;
  }

  @override
  Future<ResumenAdmin> resumen() async {
    consultasDeResumen++;
    return const ResumenAdmin(
      clientes: 1,
      tecnicos: 1,
      tecnicosVerificados: 0,
      solicitudes: 0,
      solicitudesAbiertas: 0,
      verificacionesPendientes: 1,
    );
  }

  @override
  Future<List<SolicitudAdmin>> solicitudes() async => const [];

  @override
  Future<List<UsuarioAdmin>> usuarios() async {
    consultasDeUsuarios++;
    return listaUsuarios;
  }

  @override
  Future<void> crearUsuario(RegistroDatos datos) async {
    _quizasFallar();
    creados.add(datos);
  }

  @override
  Future<void> actualizarUsuario(String id, CambiosUsuario cambios) async {
    _quizasFallar();
    actualizados.add((id, cambios));
  }

  @override
  Future<void> suspenderUsuario(String id, {required bool suspendido}) async {
    _quizasFallar();
    suspensiones.add((id, suspendido));
  }

  @override
  Future<void> eliminarUsuario(String id) async {
    _quizasFallar();
    eliminados.add(id);
  }

  @override
  Future<List<RevisionTecnico>> revisionesPendientes() async {
    consultasDeRevisiones++;
    return listaRevisiones;
  }

  @override
  Future<void> revisarDocumento(
    String documentoId, {
    required bool aprobado,
  }) async {
    _quizasFallar();
    revisados.add((documentoId, aprobado));
  }
}
