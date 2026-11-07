// Pestaña "Mis trabajos" del técnico: solicitudes con su cotización aceptada.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_vacio.dart';
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

    return AsyncValueView<List<Solicitud>>(
      value: ref.watch(misTrabajosProvider),
      onRetry: () => ref.invalidate(misTrabajosProvider),
      onData: (context, trabajos) => RefreshIndicator(
        onRefresh: () => esperarSinError(ref.refresh(misTrabajosProvider.future)),
        child: trabajos.isEmpty
            ? ListView(
                children: const [
                  EstadoVacio(
                    icono: Icons.work_outline,
                    mensaje: 'Cuando un cliente acepte tu cotización, '
                        'el trabajo aparecerá aquí.',
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trabajos.length,
                itemBuilder: (context, i) => AnchoMaximo(
                  child: SolicitudCard(
                    solicitud: trabajos[i],
                    onTap: () => abrir(trabajos[i]),
                  ),
                ),
              ),
      ),
    );
  }
}
