import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../solicitudes/data/repositories/supabase_solicitud_repository.dart';
import '../../../solicitudes/domain/entities/servicio_completado.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/presentation/providers/listas_provider.dart';
import 'sesion_provider.dart';

typedef SolicitudActiva = ({Solicitud solicitud, int ofertas});

const _estadosActivos = {
  EstadoSolicitud.abierta,
  EstadoSolicitud.cotizada,
  EstadoSolicitud.aceptada,
  EstadoSolicitud.porConfirmar,
};

/// Las solicitudes en curso, las más recientes primero, con cuántas
/// ofertas tiene cada una (una sola consulta para todas).
final solicitudesActivasProvider =
    FutureProvider.autoDispose<List<SolicitudActiva>>((ref) async {
      final lista = await ref.watch(misSolicitudesProvider.future);
      final activas = [
        for (final s in lista)
          if (_estadosActivos.contains(s.estado)) s,
      ]..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
      if (activas.isEmpty) return const [];
      final ofertas = await ref
          .watch(cotizacionRepositoryProvider)
          .deSolicitudes([for (final s in activas) s.id]);
      final porSolicitud = <String, int>{};
      for (final o in ofertas) {
        if (o.estado == EstadoCotizacion.rechazada) continue;
        porSolicitud.update(o.solicitudId, (n) => n + 1, ifAbsent: () => 1);
      }
      return [
        for (final s in activas)
          (solicitud: s, ofertas: porSolicitud[s.id] ?? 0),
      ];
    });

/// Servicios completados del cliente conectado (hasta 50).
final historialServiciosProvider =
    FutureProvider.autoDispose<List<ServicioCompletado>>((ref) {
      final uid = ref.watch(usuarioActualProvider.select((u) => u?.id));
      if (uid == null) return const <ServicioCompletado>[];
      return ref.watch(solicitudRepositoryProvider).historialServicios(uid);
    });

/// Un técnico con el que el cliente ya trabajó.
class TecnicoRecurrente {
  const TecnicoRecurrente({required this.ultimo, required this.servicios});

  /// El servicio más reciente con él (nombre, foto, oficio, calificación).
  final ServicioCompletado ultimo;
  final int servicios;
}

/// Técnicos distintos del historial, del más reciente al más antiguo.
List<TecnicoRecurrente> tecnicosRecurrentes(
  List<ServicioCompletado> historial, {
  int maximo = 6,
}) {
  final orden = <String>[];
  final ultimo = <String, ServicioCompletado>{};
  final cuenta = <String, int>{};
  for (final s in historial) {
    if (!ultimo.containsKey(s.tecnicoId)) {
      orden.add(s.tecnicoId);
      ultimo[s.tecnicoId] = s;
    }
    cuenta.update(s.tecnicoId, (n) => n + 1, ifAbsent: () => 1);
  }
  return [
    for (final id in orden.take(maximo))
      TecnicoRecurrente(ultimo: ultimo[id]!, servicios: cuenta[id]!),
  ];
}
