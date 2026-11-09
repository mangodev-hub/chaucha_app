// Pestaña "Mis trabajos" del técnico: solicitudes con su cotización aceptada,
// separadas en "En curso" y "Finalizados".
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/seccion.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/listas_provider.dart';
import '../widgets/solicitud_widgets.dart';

class MisTrabajosView extends ConsumerWidget {
  const MisTrabajosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> abrir(Solicitud solicitud) async {
      await context.push(
        AppRoutes.detalleSolicitud(solicitud.id, esCliente: false),
      );
      if (!context.mounted) return;
      ref.invalidate(misTrabajosProvider);
    }

    List<Widget> grupo(String titulo, List<Solicitud> trabajos) => [
      if (trabajos.isNotEmpty)
        Seccion(
          titulo: '$titulo (${trabajos.length})',
          child: CuadriculaAdaptable(
            children: [
              for (final t in trabajos)
                SolicitudCard(solicitud: t, onTap: () => abrir(t)),
            ],
          ),
        ),
    ];

    return AsyncValueView<List<Solicitud>>(
      value: ref.watch(misTrabajosProvider),
      onRetry: () => ref.invalidate(misTrabajosProvider),
      onData: (context, trabajos) {
        final enCurso = [
          for (final t in trabajos)
            if (t.estado.activa) t,
        ];
        final finalizados = [
          for (final t in trabajos)
            if (!t.estado.activa) t,
        ];
        return RefreshIndicator(
          onRefresh: () =>
              esperarSinError(ref.refresh(misTrabajosProvider.future)),
          child: trabajos.isEmpty
              ? ListView(
                  children: const [
                    EstadoMensaje(
                      icono: Icons.work_outline,
                      titulo: 'Aún no tienes trabajos',
                      mensaje:
                          'Cuando un cliente acepte tu oferta, '
                          'el trabajo aparecerá aquí.',
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Espacios.l,
                    0,
                    Espacios.l,
                    Espacios.xxl,
                  ),
                  children: [
                    AnchoMaximo(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...grupo('En curso', enCurso),
                          ...grupo('Finalizados', finalizados),
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
