// Pestaña "Mis trabajos" del técnico: solicitudes con su cotización aceptada.
// Se filtran por estado y, si trabaja en más de un oficio, por oficio. Con el
// filtro "Todos" se separan en "En curso" y "Finalizados".
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/filtro_chips.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/seccion.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/listas_provider.dart';
import '../widgets/solicitud_widgets.dart';

/// Filtros por estado de la pestaña.
enum _FiltroEstado {
  todos('Todos'),
  enCurso('En curso'),
  porConfirmar('Por confirmar'),
  completados('Completados'),
  cancelados('Cancelados');

  const _FiltroEstado(this.etiqueta);

  final String etiqueta;

  bool incluye(EstadoSolicitud estado) => switch (this) {
    todos => true,
    enCurso => estado.activa && estado != EstadoSolicitud.porConfirmar,
    porConfirmar => estado == EstadoSolicitud.porConfirmar,
    completados => estado == EstadoSolicitud.completada,
    cancelados => estado == EstadoSolicitud.cancelada,
  };

  String get sinResultados => switch (this) {
    todos => 'No tienes trabajos de este oficio.',
    enCurso => 'No tienes trabajos en curso.',
    porConfirmar => 'No tienes trabajos esperando confirmación del cliente.',
    completados => 'Todavía no tienes trabajos completados.',
    cancelados => 'No tienes trabajos cancelados.',
  };
}

class MisTrabajosView extends ConsumerStatefulWidget {
  const MisTrabajosView({super.key});

  @override
  ConsumerState<MisTrabajosView> createState() => _MisTrabajosViewState();
}

class _MisTrabajosViewState extends ConsumerState<MisTrabajosView> {
  _FiltroEstado _estado = _FiltroEstado.todos;

  /// Id del oficio elegido; null = todos los oficios.
  int? _oficioId;

  Future<void> _abrir(Solicitud solicitud) async {
    await context.push(
      AppRoutes.detalleSolicitud(solicitud.id, esCliente: false),
    );
    if (!mounted) return;
    ref.invalidate(misTrabajosProvider);
  }

  Widget _grupo(String titulo, List<Solicitud> trabajos) => Seccion(
    titulo: '$titulo (${trabajos.length})',
    child: CuadriculaAdaptable(
      children: [
        for (final t in trabajos)
          SolicitudCard(solicitud: t, onTap: () => _abrir(t)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AsyncValueView<List<Solicitud>>(
      value: ref.watch(misTrabajosProvider),
      onRetry: () => ref.invalidate(misTrabajosProvider),
      onData: (context, trabajos) => RefreshIndicator(
        onRefresh: () =>
            esperarSinError(ref.refresh(misTrabajosProvider.future)),
        child: trabajos.isEmpty
            ? const ListaDePagina(
                children: [
                  EstadoMensaje(
                    icono: Icons.work_outline,
                    titulo: 'Aún no tienes trabajos',
                    mensaje:
                        'Cuando un cliente acepte tu oferta, '
                        'el trabajo aparecerá aquí.',
                  ),
                ],
              )
            : _lista(trabajos),
      ),
    );
  }

  Widget _lista(List<Solicitud> trabajos) {
    // Oficios distintos de sus trabajos, en orden alfabético.
    final oficios = <int, String>{
      for (final t in trabajos) t.oficioId: t.oficioNombre,
    }.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    // Si tras recargar ya no hay trabajos del oficio elegido, se ven todos.
    final oficioId = oficios.any((o) => o.key == _oficioId) ? _oficioId : null;
    final delOficio = [
      for (final t in trabajos)
        if (oficioId == null || t.oficioId == oficioId) t,
    ];
    int cuantos(_FiltroEstado f) =>
        delOficio.where((t) => f.incluye(t.estado)).length;

    final List<Widget> contenido;
    if (_estado == _FiltroEstado.todos) {
      final enCurso = [
        for (final t in delOficio)
          if (t.estado.activa) t,
      ];
      final finalizados = [
        for (final t in delOficio)
          if (!t.estado.activa) t,
      ];
      contenido = [
        if (enCurso.isNotEmpty) _grupo('En curso', enCurso),
        if (finalizados.isNotEmpty) _grupo('Finalizados', finalizados),
      ];
    } else {
      final visibles = [
        for (final t in delOficio)
          if (_estado.incluye(t.estado)) t,
      ];
      contenido = [if (visibles.isNotEmpty) _grupo(_estado.etiqueta, visibles)];
    }

    return ListaDePagina(
      padding: ScrollDePagina.activo(context)
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(
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
              FiltroChips<_FiltroEstado>(
                opciones: [
                  for (final f in _FiltroEstado.values)
                    (f, '${f.etiqueta} (${cuantos(f)})'),
                ],
                seleccionado: _estado,
                onCambio: (f) => setState(() => _estado = f),
              ),
              if (oficios.length > 1) ...[
                const SizedBox(height: Espacios.s),
                FiltroChips<int?>(
                  opciones: [
                    (null, 'Todos los oficios'),
                    for (final o in oficios) (o.key, o.value),
                  ],
                  seleccionado: oficioId,
                  onCambio: (id) => setState(() => _oficioId = id),
                ),
              ],
              if (contenido.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: Espacios.xl),
                  child: EstadoMensaje(
                    compacto: true,
                    icono: Icons.filter_list_off_rounded,
                    mensaje: _estado.sinResultados,
                  ),
                )
              else
                ...contenido,
            ],
          ),
        ),
      ],
    );
  }
}
