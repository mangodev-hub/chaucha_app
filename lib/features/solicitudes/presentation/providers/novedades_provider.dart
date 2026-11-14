import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../notificaciones/domain/entities/notificacion.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';
import 'listas_provider.dart';

const tiposDeSolicitud = ['cotizacion', 'tarifa', 'cierre'];

final novedadesPorSolicitudProvider =
    FutureProvider.autoDispose<Map<String, int>>((ref) async {
      final sinLeer =
          ref.watch(notificacionesNoLeidasProvider).value ??
          const <Notificacion>[];
      final relevantes = [
        for (final n in sinLeer)
          if (tiposDeSolicitud.contains(n.tipo) && n.referenciaId != null) n,
      ];
      if (relevantes.isEmpty) return const {};

      final solicitudes = await ref.watch(misSolicitudesProvider.future);
      final ids = {for (final s in solicitudes) s.id};
      final cotizaciones = await ref
          .watch(cotizacionRepositoryProvider)
          .deSolicitudes(ids.toList());
      final cotASolicitud = {for (final c in cotizaciones) c.id: c.solicitudId};

      final cuenta = <String, int>{};
      for (final n in relevantes) {
        final solicitud = n.tipo == 'cierre'
            ? n.referenciaId!
            : cotASolicitud[n.referenciaId];
        if (solicitud != null && ids.contains(solicitud)) {
          cuenta[solicitud] = (cuenta[solicitud] ?? 0) + 1;
        }
      }
      return cuenta;
    });
