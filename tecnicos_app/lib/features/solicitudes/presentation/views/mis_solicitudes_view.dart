// Inicio del cliente: sus solicitudes y el botón para crear una nueva.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_vacio.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/listas_provider.dart';
import '../widgets/solicitud_widgets.dart';

class MisSolicitudesView extends ConsumerWidget {
  const MisSolicitudesView({super.key, required this.onCerrarSesion});

  final VoidCallback onCerrarSesion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> nueva() async {
      final creada = await context.push<String>(
        AppRoutes.clienteNuevaSolicitud,
      );
      if (!context.mounted) return;
      if (creada != null) ref.invalidate(misSolicitudesProvider);
    }

    Future<void> abrir(Solicitud solicitud) async {
      await context.push(
        AppRoutes.detalleSolicitud(solicitud.id, esCliente: true),
      );
      if (!context.mounted) return;
      // Al volver, la solicitud pudo cambiar de estado.
      ref.invalidate(misSolicitudesProvider);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: onCerrarSesion,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: nueva,
        icon: const Icon(Icons.add),
        label: const Text('Nueva solicitud'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Saludo(),
          Expanded(child: _lista(ref, abrir)),
        ],
      ),
    );
  }

  Widget _lista(WidgetRef ref, Future<void> Function(Solicitud) abrir) {
    return AsyncValueView<List<Solicitud>>(
      value: ref.watch(misSolicitudesProvider),
      onRetry: () => ref.invalidate(misSolicitudesProvider),
      onData: (context, solicitudes) => RefreshIndicator(
        onRefresh: () =>
            esperarSinError(ref.refresh(misSolicitudesProvider.future)),
        child: solicitudes.isEmpty
            ? ListView(
                children: const [
                  EstadoVacio(
                    icono: Icons.handyman_outlined,
                    mensaje:
                        'Aún no tienes solicitudes.\n'
                        'Toca "Nueva solicitud" para pedir un técnico.',
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: solicitudes.length,
                itemBuilder: (context, i) => AnchoMaximo(
                  child: SolicitudCard(
                    solicitud: solicitudes[i],
                    onTap: () => abrir(solicitudes[i]),
                  ),
                ),
              ),
      ),
    );
  }
}

/// Encabezado del inicio del cliente: saludo grande con su nombre.
class _Saludo extends ConsumerWidget {
  const _Saludo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final nombre = ref.watch(usuarioActualProvider)?.nombres;
    return AnchoMaximo(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Espacios.l,
          0,
          Espacios.l,
          Espacios.s,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre == null ? 'Hola' : 'Hola, $nombre',
              style: textos.headlineLarge,
            ),
            const SizedBox(height: Espacios.xs),
            Text(
              '¿Qué necesitas arreglar hoy?',
              style: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
            ),
            const SizedBox(height: Espacios.l),
            Text('Mis solicitudes', style: textos.titleLarge),
          ],
        ),
      ),
    );
  }
}
