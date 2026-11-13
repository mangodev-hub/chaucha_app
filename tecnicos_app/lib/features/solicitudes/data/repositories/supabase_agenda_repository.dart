import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/visita_agenda.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../models/visita_agenda_model.dart';

final agendaRepositoryProvider = Provider<AgendaRepository>(
  (ref) => SupabaseAgendaRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseAgendaRepository implements AgendaRepository {
  SupabaseAgendaRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<VisitaAgenda>> visitas({
    required DateTime desde,
    required DateTime hasta,
    required bool esCliente,
  }) {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      var consulta = _client
          .from('cotizaciones')
          .select(VisitaAgendaModel.columnas)
          .eq('estado', 'aceptada')
          .gte('inicio_visita', desde.toUtc().toIso8601String())
          .lt('inicio_visita', hasta.toUtc().toIso8601String())
          .inFilter('solicitud.estado', VisitaAgendaModel.estadosActivos);
      consulta = esCliente
          ? consulta.eq('solicitud.cliente_id', uid)
          : consulta.eq('tecnico_id', uid);
      final filas = await consulta.order('inicio_visita').limit(500);
      return [
        for (final f in filas)
          ?VisitaAgendaModel.desdeFila(f, esCliente: esCliente, miId: uid),
      ];
    });
  }
}
