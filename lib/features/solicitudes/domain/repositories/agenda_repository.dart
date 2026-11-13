import '../entities/visita_agenda.dart';

abstract interface class AgendaRepository {
  /// Visitas (cotizaciones aceptadas de solicitudes activas) con
  /// `inicio_visita` en [desde, hasta). Una sola consulta.
  Future<List<VisitaAgenda>> visitas({
    required DateTime desde,
    required DateTime hasta,
    required bool esCliente,
  });
}
