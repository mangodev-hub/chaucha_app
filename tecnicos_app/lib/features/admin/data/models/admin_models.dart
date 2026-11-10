// Lectura de las respuestas del panel de administrador: funciones RPC
// (`admin_resumen`, `admin_usuarios`) y consultas con joins.
import '../../../../core/utils/json_utils.dart';
import '../../../auth/data/models/rol_db.dart';
import '../../../perfil_puntos/data/models/documento_tecnico_model.dart';
import '../../../perfil_puntos/domain/entities/documento_tecnico.dart';
import '../../../solicitudes/data/models/solicitud_model.dart';
import '../../domain/entities/resumen_admin.dart';
import '../../domain/entities/revision_tecnico.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../../domain/entities/usuario_admin.dart';

abstract final class ResumenAdminModel {
  static ResumenAdmin desdeJson(Map<String, dynamic> json) => ResumenAdmin(
    clientes: aInt(json['clientes']),
    tecnicos: aInt(json['tecnicos']),
    tecnicosVerificados: aInt(json['tecnicos_verificados']),
    solicitudes: aInt(json['solicitudes']),
    solicitudesAbiertas: aInt(json['solicitudes_abiertas']),
    verificacionesPendientes: aInt(json['verificaciones_pendientes']),
  );
}

/// Fila de `admin_usuarios()`.
abstract final class UsuarioAdminModel {
  static UsuarioAdmin desdeFila(Map<String, dynamic> fila) => UsuarioAdmin(
    id: fila['id'] as String,
    email: (fila['email'] as String?) ?? '',
    rol: RolDb.desdeDb(fila['rol'] as String),
    nombres: fila['nombres'] as String,
    apellidos: (fila['apellidos'] as String?) ?? '',
    ciudad: (fila['ciudad'] as String?) ?? 'Quito',
    cedula: fila['cedula'] as String?,
    verificado: fila['verificado'] as bool?,
    suspendido: (fila['suspendido'] as bool?) ?? false,
    creadoEn: aFecha(fila['creado_en']),
  );
}

/// `solicitudes_servicio` con el oficio y el cliente (la única llave a
/// `usuarios` es `cliente_id`).
abstract final class SolicitudAdminModel {
  static const String columnas =
      '${SolicitudModel.columnas}, usuarios(nombres, apellidos)';

  static SolicitudAdmin desdeFila(Map<String, dynamic> fila) {
    final cliente = anidado(fila['usuarios']);
    final nombre = '${cliente?['nombres'] ?? ''} ${cliente?['apellidos'] ?? ''}'
        .trim();
    return SolicitudAdmin(
      solicitud: SolicitudModel.fromJson(fila).aEntidad(),
      cliente: nombre.isEmpty ? 'Cliente' : nombre,
    );
  }
}

/// `documentos_tecnico` con el técnico (perfil → usuario → identidad).
abstract final class RevisionTecnicoModel {
  static const String columnas =
      '${DocumentoTecnicoModel.columnas}, tecnico_id, '
      'perfiles_tecnicos(usuarios!fk_perfiles_usuario(nombres, apellidos, identidades(cedula)))';

  /// Agrupa las filas por técnico, conservando el orden de llegada.
  static List<RevisionTecnico> agrupar(
    List<Map<String, dynamic>> filas,
    Map<String, String> urls,
  ) {
    final documentos = <String, List<DocumentoTecnico>>{};
    final nombres = <String, String>{};
    final cedulas = <String, String?>{};
    for (final fila in filas) {
      final tecnicoId = fila['tecnico_id'] as String;
      final doc = DocumentoTecnicoModel.fromJson(fila).aEntidad();
      final url = urls[doc.ruta];
      (documentos[tecnicoId] ??= []).add(url == null ? doc : doc.conUrl(url));
      if (!nombres.containsKey(tecnicoId)) {
        final usuario = anidado(
          anidado(fila['perfiles_tecnicos'])?['usuarios'],
        );
        final nombre =
            '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'
                .trim();
        nombres[tecnicoId] = nombre.isEmpty ? 'Técnico' : nombre;
        cedulas[tecnicoId] =
            anidado(usuario?['identidades'])?['cedula'] as String?;
      }
    }
    return [
      for (final MapEntry(key: id, value: docs) in documentos.entries)
        RevisionTecnico(
          tecnicoId: id,
          nombre: nombres[id]!,
          cedula: cedulas[id],
          documentos: docs
            ..sort((a, b) => a.tipo.index.compareTo(b.tipo.index)),
        ),
    ];
  }
}
