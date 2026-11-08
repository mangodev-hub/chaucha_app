// Pestaña "Solicitudes cerca" del técnico: resumen de su zona y las
// solicitudes de sus oficios, de la más cercana a la más lejana.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../perfil_puntos/domain/entities/perfil_tecnico.dart';
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

    // Deslizar hacia abajo recarga también el perfil.
    Future<void> recargar() {
      ref.invalidate(perfilTecnicoProvider);
      return esperarSinError(ref.refresh(feedProvider.future));
    }

    return AsyncValueView<DatosFeed>(
      value: ref.watch(feedProvider),
      onRetry: () => ref.invalidate(perfilTecnicoProvider),
      onData: (context, datos) {
        if (!datos.perfil.estaCompleto) {
          return const EstadoMensaje(
            icono: Icons.person_pin_circle_outlined,
            titulo: 'Completa tu perfil',
            mensaje:
                'Elige tus oficios y tu zona en la pestaña "Mi perfil" '
                'para ver solicitudes cerca de ti.',
          );
        }
        final n = datos.items.length;
        return RefreshIndicator(
          onRefresh: recargar,
          child: ListView(
            padding: const EdgeInsets.all(Espacios.l),
            children: [
              AnchoMaximo(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ResumenZona(perfil: datos.perfil),
                    const SizedBox(height: Espacios.xl),
                    Text(
                      n == 0
                          ? 'Sin solicitudes cerca'
                          : n == 1
                          ? '1 solicitud cerca'
                          : '$n solicitudes cerca',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Espacios.m),
                    if (n == 0)
                      const EstadoMensaje(
                        compacto: true,
                        icono: Icons.search_off,
                        mensaje:
                            'No hay solicitudes de tus oficios en tu '
                            'zona. Desliza hacia abajo para actualizar.',
                      )
                    else
                      CuadriculaAdaptable(
                        children: [
                          for (final item in datos.items)
                            SolicitudCard(
                              solicitud: item.solicitud,
                              distancia: Formatos.distancia(
                                item.distanciaMetros,
                              ),
                              yaCotice: item.yaCotice,
                              onTap: () => abrir(item.solicitud),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// "Tu zona de trabajo": oficios y radio que filtran el feed.
class _ResumenZona extends ConsumerWidget {
  const _ResumenZona({required this.perfil});

  final PerfilTecnico perfil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final catalogo = ref.watch(oficiosProvider).value ?? const [];
    final nombres = [
      for (final oficio in catalogo)
        if (perfil.oficioIds.contains(oficio.id)) oficio.nombre,
    ];
    final oficios = nombres.isNotEmpty
        ? nombres.join(', ')
        : '${perfil.oficioIds.length} oficios';
    return TarjetaApp(
      child: Row(
        children: [
          const IconoRecuadro(icono: Icons.travel_explore, lado: 44),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu zona de trabajo',
                  style: textos.labelMedium?.copyWith(
                    color: Colores.tintaSuave,
                  ),
                ),
                Text(oficios, style: textos.titleSmall),
                Text(
                  'Hasta ${Formatos.distancia(perfil.rangoCoberturaM.toDouble())} '
                  'a la redonda',
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
