import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../data/repositories/supabase_solicitud_repository.dart';
import '../../domain/entities/solicitud.dart';

class ItemAgenda {
  const ItemAgenda(this.oferta, this.solicitud);

  final Cotizacion oferta;
  final Solicitud solicitud;

  DateTime? get fecha => oferta.tarifa?.fechaServicio;
}

class Agenda {
  const Agenda({required this.tickets, required this.proximos});

  final List<ItemAgenda> tickets;
  final List<ItemAgenda> proximos;
}

/// El parámetro es `esCliente`.
final agendaProvider = FutureProvider.autoDispose.family<Agenda, bool>((
  ref,
  esCliente,
) async {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  final repoOfertas = ref.watch(cotizacionRepositoryProvider);
  final repoSolicitudes = ref.watch(solicitudRepositoryProvider);

  List<Solicitud> solicitudes;
  List<Cotizacion> ofertas;
  if (esCliente) {
    solicitudes = await repoSolicitudes.misSolicitudes();
    ofertas = await repoOfertas.deSolicitudes([
      for (final s in solicitudes) s.id,
    ]);
  } else {
    ofertas = await repoOfertas.misOfertas();
    solicitudes = await repoSolicitudes.porIds([
      for (final o in ofertas)
        if (o.tarifaPendiente || o.estado == EstadoCotizacion.aceptada)
          o.solicitudId,
    ]);
  }

  final porId = {for (final s in solicitudes) s.id: s};
  final items = <ItemAgenda>[
    for (final o in ofertas)
      if (porId[o.solicitudId] != null) ItemAgenda(o, porId[o.solicitudId]!),
  ];

  final tickets = [
    for (final i in items)
      if (i.oferta.tarifaPendiente && i.solicitud.estado.recibeCotizaciones) i,
  ];
  final proximos =
      [
        for (final i in items)
          if (i.oferta.estado == EstadoCotizacion.aceptada &&
              i.solicitud.estado == EstadoSolicitud.aceptada)
            i,
      ]..sort((a, b) {
        final fa = a.fecha;
        final fb = b.fecha;
        if (fa == null && fb == null) return 0;
        if (fa == null) return 1;
        if (fb == null) return -1;
        return fa.compareTo(fb);
      });

  return Agenda(tickets: tickets, proximos: proximos);
});
