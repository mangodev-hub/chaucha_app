// Pestaña "Solicitudes cerca" del técnico.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_vacio.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../domain/entities/feed.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/feed_provider.dart';
import '../widgets/solicitud_widgets.dart';

class FeedView extends ConsumerWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> abrir(Solicitud solicitud) async {
      await context.push(
        AppRoutes.detalleSolicitud(solicitud.id, esCliente: false),
      );
      if (!context.mounted) return;
      // Al volver puede haber cotizado: se recalcula "Ya cotizaste".
      ref.invalidate(feedProvider);
    }

    // Deslizar hacia abajo recarga también el perfil, como antes.
    Future<void> recargar() {
      ref.invalidate(perfilTecnicoProvider);
      return esperarSinError(ref.refresh(feedProvider.future));
    }

    return AsyncValueView<DatosFeed>(
      value: ref.watch(feedProvider),
      onRetry: () => ref.invalidate(perfilTecnicoProvider),
      onData: (context, datos) {
        if (!datos.perfil.estaCompleto) {
          return const EstadoVacio(
            icono: Icons.person_pin_circle_outlined,
            mensaje: 'Completa tu perfil (oficios y ubicación) en la '
                'pestaña "Perfil" para ver solicitudes cerca de ti.',
          );
        }
        return RefreshIndicator(
          onRefresh: recargar,
          child: datos.items.isEmpty
              ? ListView(
                  children: [
                    EstadoVacio(
                      icono: Icons.search_off,
                      mensaje: 'No hay solicitudes de tus oficios a menos de '
                          '${Formatos.distancia(datos.perfil.rangoCoberturaM.toDouble())}.'
                          '\nDesliza hacia abajo para actualizar.',
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: datos.items.length,
                  itemBuilder: (context, i) {
                    final item = datos.items[i];
                    return AnchoMaximo(
                      child: SolicitudCard(
                        solicitud: item.solicitud,
                        extra: [
                          'a ${Formatos.distancia(item.distanciaMetros)}',
                          if (item.yaCotice) 'Ya cotizaste',
                        ].join(' · '),
                        onTap: () => abrir(item.solicitud),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
