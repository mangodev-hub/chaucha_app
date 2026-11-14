import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_agenda_repository.dart';
import '../../domain/entities/visita_agenda.dart';

enum VistaAgenda { mes, semana, lista }

/// Vista elegida (null = la de por defecto: Mes en web, Lista en móvil).
/// Sin autoDispose: se recuerda al salir y volver a la agenda.
class VistaAgendaElegida extends Notifier<VistaAgenda?> {
  @override
  VistaAgenda? build() => null;

  void elegir(VistaAgenda vista) => state = vista;
}

final vistaAgendaProvider = NotifierProvider<VistaAgendaElegida, VistaAgenda?>(
  VistaAgendaElegida.new,
);

typedef RangoAgenda = ({DateTime desde, DateTime hasta, bool esCliente});

final visitasRangoProvider = FutureProvider.autoDispose
    .family<List<VisitaAgenda>, RangoAgenda>((ref, r) {
      ref.watch(usuarioActualProvider.select((u) => u?.id));
      return ref
          .watch(agendaRepositoryProvider)
          .visitas(desde: r.desde, hasta: r.hasta, esCliente: r.esCliente);
    });

/// Desde el inicio de hoy y hasta un año: las de hoy (aunque ya pasaron) y
/// las siguientes, en orden.
final visitasProximasProvider = FutureProvider.autoDispose
    .family<List<VisitaAgenda>, bool>((ref, esCliente) {
      ref.watch(usuarioActualProvider.select((u) => u?.id));
      final hoy = DateUtils.dateOnly(DateTime.now());
      return ref
          .watch(agendaRepositoryProvider)
          .visitas(
            desde: hoy,
            hasta: hoy.add(const Duration(days: 366)),
            esCliente: esCliente,
          );
    });
