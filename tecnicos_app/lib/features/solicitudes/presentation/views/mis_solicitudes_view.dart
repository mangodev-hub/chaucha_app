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

class MisSolicitudesView extends ConsumerStatefulWidget {
  const MisSolicitudesView({super.key});

  @override
  ConsumerState<MisSolicitudesView> createState() => _MisSolicitudesViewState();
}

class _MisSolicitudesViewState extends ConsumerState<MisSolicitudesView> {
  /// Filtro elegido (estado de la pantalla, no de un provider).
  bool _verActivas = true;

  Future<void> _nueva() async {
    final creada = await context.push<String>(AppRoutes.clienteNuevaSolicitud);
    if (!mounted) return;
    if (creada != null) ref.invalidate(misSolicitudesProvider);
  }

  Future<void> _abrir(Solicitud solicitud) async {
    await context.push(
      AppRoutes.detalleSolicitud(solicitud.id, esCliente: true),
    );
    if (!mounted) return;
    // Al volver, la solicitud pudo cambiar de estado.
    ref.invalidate(misSolicitudesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: () =>
          esperarSinError(ref.refresh(misSolicitudesProvider.future)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Espacios.l,
          Espacios.l,
          Espacios.l,
          Espacios.xxl,
        ),
        children: [
          AnchoMaximo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Mis solicitudes', style: textos.titleLarge),
                    ),
                    FilledButton.icon(
                      onPressed: _nueva,
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva solicitud'),
                    ),
                  ],
                ),
                const SizedBox(height: Espacios.m),
                AsyncValueView<List<Solicitud>>(
                  value: ref.watch(misSolicitudesProvider),
                  onRetry: () => ref.invalidate(misSolicitudesProvider),
                  onData: (context, solicitudes) => _lista(solicitudes),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lista(List<Solicitud> solicitudes) {
    if (solicitudes.isEmpty) {
      return const EstadoMensaje(
        compacto: true,
        icono: Icons.handyman_outlined,
        titulo: 'Aún no tienes solicitudes',
        mensaje:
            'Pide un técnico y recibe ofertas de profesionales '
            'cerca de ti.',
      );
    }
    final activas = [
      for (final s in solicitudes)
        if (s.estado.activa) s,
    ];
    final finalizadas = [
      for (final s in solicitudes)
        if (!s.estado.activa) s,
    ];
    final visibles = _verActivas ? activas : finalizadas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: Espacios.s,
          children: [
            ChoiceChip(
              label: Text('Activas (${activas.length})'),
              selected: _verActivas,
              onSelected: (_) => setState(() => _verActivas = true),
            ),
            ChoiceChip(
              label: Text('Finalizadas (${finalizadas.length})'),
              selected: !_verActivas,
              onSelected: (_) => setState(() => _verActivas = false),
            ),
          ],
        ),
        const SizedBox(height: Espacios.m),
        if (visibles.isEmpty)
          EstadoMensaje(
            compacto: true,
            icono: _verActivas ? Icons.inbox_outlined : Icons.history,
            mensaje: _verActivas
                ? 'No tienes solicitudes en curso.'
                : 'Todavía no tienes solicitudes finalizadas.',
          )
        else
          CuadriculaAdaptable(
            children: [
              for (final s in visibles)
                SolicitudCard(solicitud: s, onTap: () => _abrir(s)),
            ],
          ),
      ],
    );
  }
}
