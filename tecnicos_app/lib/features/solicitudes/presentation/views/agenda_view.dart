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
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../providers/agenda_provider.dart';

class AgendaView extends ConsumerWidget {
  const AgendaView({super.key, required this.esCliente});

  final bool esCliente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = agendaProvider(esCliente);

    Future<void> abrir(ItemAgenda item) async {
      await context.push(
        AppRoutes.detalleSolicitud(item.solicitud.id, esCliente: esCliente),
      );
      if (!context.mounted) return;
      ref.invalidate(provider);
    }

    List<Widget> grupo(String titulo, List<ItemAgenda> items) => [
      if (items.isNotEmpty)
        Seccion(
          titulo: '$titulo (${items.length})',
          child: CuadriculaAdaptable(
            children: [
              for (final i in items)
                _TarjetaAgenda(
                  item: i,
                  esCliente: esCliente,
                  onTap: () => abrir(i),
                ),
            ],
          ),
        ),
    ];

    return AsyncValueView<Agenda>(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      onData: (context, agenda) {
        final vacia = agenda.tickets.isEmpty && agenda.proximos.isEmpty;
        return RefreshIndicator(
          onRefresh: () => esperarSinError(ref.refresh(provider.future)),
          child: vacia
              ? ListView(
                  children: const [
                    EstadoMensaje(
                      icono: Icons.event_available_outlined,
                      titulo: 'Agenda vacía',
                      mensaje:
                          'Aquí verás los tickets por confirmar y los '
                          'trabajos próximos con su fecha.',
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
                          ...grupo('Tickets por confirmar', agenda.tickets),
                          ...grupo('Próximos trabajos', agenda.proximos),
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

String _cuando(DateTime fecha) {
  final hoy = DateUtils.dateOnly(DateTime.now());
  final dias = DateUtils.dateOnly(fecha).difference(hoy).inDays;
  if (dias == 0) return 'Hoy';
  if (dias == 1) return 'Mañana';
  if (dias < 0) return 'Atrasado · ${Formatos.fechaCorta(fecha)}';
  return Formatos.fechaCorta(fecha);
}

class _TarjetaAgenda extends StatelessWidget {
  const _TarjetaAgenda({
    required this.item,
    required this.esCliente,
    required this.onTap,
  });

  final ItemAgenda item;
  final bool esCliente;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final fecha = item.fecha;
    final total = item.oferta.tarifa?.total ?? item.oferta.precioBase;
    return TarjetaApp(
      onTap: onTap,
      child: Row(
        children: [
          const IconoRecuadro(icono: Icons.event_outlined),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.solicitud.oficioNombre, style: textos.titleMedium),
                Text(
                  esCliente
                      ? '${item.oferta.tecnicoNombre} · ${item.solicitud.descripcion}'
                      : item.solicitud.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
                const SizedBox(height: Espacios.s),
                Wrap(
                  spacing: Espacios.s,
                  runSpacing: Espacios.xs,
                  children: [
                    Pildora(
                      texto: fecha == null
                          ? 'Sin fecha'
                          : '${_cuando(fecha)} · ${Formatos.hora(fecha)}',
                      color: Colores.primario,
                      icono: Icons.event,
                    ),
                    Pildora(
                      texto: Formatos.dinero(total),
                      color: Colores.tintaSuave,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
