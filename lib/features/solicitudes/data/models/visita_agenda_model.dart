import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/solicitud.dart';
import '../../domain/entities/visita_agenda.dart';
import 'solicitud_db.dart';

abstract final class VisitaAgendaModel {
  /// Cotización aceptada + solicitud (con su oficio y su cliente) + técnico.
  /// El `!inner` permite filtrar por columnas de la solicitud.
  static const String columnas =
      'id, solicitud_id, tecnico_id, precio_base, inicio_visita, fin_visita, '
      'reagenda_inicio, reagenda_por, '
      'solicitud:solicitudes_servicio!fk_cotizaciones_solicitud!inner('
      'id, descripcion, estado, cliente_id, oficios(nombre), '
      'cliente:usuarios!fk_solicitudes_cliente(nombres, apellidos, '
      'foto_perfil_ruta)), '
      'perfiles_tecnicos!fk_cotizaciones_tecnico('
      'usuarios!fk_perfiles_usuario(nombres, apellidos, foto_perfil_ruta))';

  static const List<String> estadosActivos = ['aceptada', 'por_confirmar'];

  static VisitaAgenda? desdeFila(
    Map<String, dynamic> f, {
    required bool esCliente,
    required String miId,
    DateTime? ahora,
  }) {
    final solicitud = anidado(f['solicitud']);
    final inicioTexto = f['inicio_visita'];
    if (solicitud == null || inicioTexto == null) return null;
    final inicio = aFecha(inicioTexto).toLocal();
    final finTexto = f['fin_visita'];
    final fin = finTexto == null
        ? inicio.add(const Duration(hours: 1))
        : aFecha(finTexto).toLocal();

    final tecnico = anidado(anidado(f['perfiles_tecnicos'])?['usuarios']);
    final cliente = anidado(solicitud['cliente']);
    final otra = esCliente ? tecnico : cliente;
    final nombre = '${otra?['nombres'] ?? ''} ${otra?['apellidos'] ?? ''}'
        .trim();

    final reagenda = f['reagenda_inicio'];
    final estadoSolicitud = EstadoSolicitudDb.desdeDb(
      solicitud['estado'] as String,
    );
    final momento = ahora ?? DateTime.now();
    final estado = reagenda != null
        ? EstadoVisita.porConfirmar
        : estadoSolicitud == EstadoSolicitud.porConfirmar ||
              !momento.isBefore(inicio)
        ? EstadoVisita.enCurso
        : EstadoVisita.agendada;

    return VisitaAgenda(
      cotizacionId: f['id'] as String,
      solicitudId: solicitud['id'] as String,
      tecnicoId: f['tecnico_id'] as String,
      inicio: inicio,
      fin: fin,
      oficio: anidado(solicitud['oficios'])?['nombre'] as String? ?? 'Servicio',
      descripcion: (solicitud['descripcion'] as String? ?? '').trim(),
      precioVisita: aDouble(f['precio_base']),
      estado: estado,
      otraPersonaId: esCliente
          ? f['tecnico_id'] as String
          : solicitud['cliente_id'] as String,
      otraPersonaNombre: nombre.isEmpty
          ? (esCliente ? 'Técnico' : 'Cliente')
          : nombre,
      otraPersonaFoto: otra?['foto_perfil_ruta'] as String?,
      reagendaInicio: reagenda == null ? null : aFecha(reagenda).toLocal(),
      reagendaPorMi: f['reagenda_por'] == miId,
    );
  }
}
