// Inicio del cliente: saludo con el botón para pedir un técnico y sus
// solicitudes, separadas en activas y finalizadas.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/marca.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/listas_provider.dart';
import '../widgets/solicitud_widgets.dart';

class MisSolicitudesView extends ConsumerStatefulWidget {
  const MisSolicitudesView({super.key, required this.onCerrarSesion});

  final VoidCallback onCerrarSesion;

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
    return Scaffold(
      appBar: AppBar(
        title: const Marca(),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: widget.onCerrarSesion,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            esperarSinError(ref.refresh(misSolicitudesProvider.future)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.l,
            Espacios.s,
            Espacios.l,
            Espacios.xxl,
          ),
          children: [
            AnchoMaximo(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Bienvenida(onNueva: _nueva),
                  const SizedBox(height: Espacios.xl),
                  Text('Mis solicitudes', style: textos.titleLarge),
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
            'Pide un técnico y recibe cotizaciones de profesionales '
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

/// Encabezado azul: saludo con el nombre y el botón para pedir un técnico.
class _Bienvenida extends ConsumerWidget {
  const _Bienvenida({required this.onNueva});

  final VoidCallback onNueva;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    final nombre = ref.watch(usuarioActualProvider)?.nombres;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radios.grande),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colores.primario, Colores.primarioOscuro],
          ),
        ),
        child: Stack(
          children: [
            // Ícono grande decorativo, recortado en la esquina.
            Positioned(
              right: -18,
              bottom: -22,
              child: ExcludeSemantics(
                child: Icon(
                  Icons.build_rounded,
                  size: 130,
                  color: blanco.withValues(alpha: 0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Espacios.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre == null ? 'Hola' : 'Hola, $nombre',
                    style: textos.headlineMedium?.copyWith(color: blanco),
                  ),
                  const SizedBox(height: Espacios.xs),
                  Text(
                    '¿Qué necesitas arreglar hoy?',
                    style: textos.bodyLarge?.copyWith(
                      color: blanco.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: Espacios.l + 4),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colores.tarjeta,
                      foregroundColor: Colores.primario,
                    ),
                    onPressed: onNueva,
                    icon: const Icon(Icons.add),
                    label: const Text('Pedir un técnico'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
