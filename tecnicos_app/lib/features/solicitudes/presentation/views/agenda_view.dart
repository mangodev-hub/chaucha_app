// Agenda: el calendario mensual arriba y, debajo, las visitas del día elegido
// (o las próximas) como una línea de tiempo: la hora a la izquierda y una
// tarjeta con borde de color según el estado. Los tickets por confirmar van
// primero.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../providers/agenda_provider.dart';
import '../widgets/calendario_agenda.dart';

class AgendaView extends ConsumerStatefulWidget {
  const AgendaView({super.key, required this.esCliente});

  final bool esCliente;

  @override
  ConsumerState<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends ConsumerState<AgendaView> {
  DateTime? _dia;

  static const _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  String _tituloDia(DateTime dia) {
    final mes = CalendarioAgenda.meses[dia.month - 1].toLowerCase();
    return '${_diasSemana[dia.weekday - 1]} ${dia.day} de $mes';
  }

  @override
  Widget build(BuildContext context) {
    final esCliente = widget.esCliente;
    final provider = agendaProvider(esCliente);
    final textos = Theme.of(context).textTheme;

    Future<void> abrir(ItemAgenda item) async {
      await context.push(
        AppRoutes.detalleSolicitud(item.solicitud.id, esCliente: esCliente),
      );
      if (!mounted) return;
      ref.invalidate(provider);
    }

    List<Widget> filas(List<ItemAgenda> items, {required bool ticket}) => [
      for (final i in items)
        Padding(
          padding: const EdgeInsets.only(bottom: Espacios.s),
          child: _FilaAgenda(
            item: i,
            esCliente: esCliente,
            ticket: ticket,
            onTap: () => abrir(i),
          ),
        ),
    ];

    return AsyncValueView<Agenda>(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      onData: (context, agenda) {
        final vacia = agenda.tickets.isEmpty && agenda.proximos.isEmpty;
        final dia = _dia;
        final proximos = dia == null
            ? agenda.proximos
            : [
                for (final i in agenda.proximos)
                  if (DateUtils.isSameDay(i.fecha, dia)) i,
              ];
        final tituloLista = dia == null
            ? 'Próximos trabajos (${proximos.length})'
            : _tituloDia(dia);
        final cuantas = dia == null
            ? null
            : proximos.isEmpty
            ? 'Libre'
            : proximos.length == 1
            ? '1 visita'
            : '${proximos.length} visitas';

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
                          'trabajos próximos en el calendario.',
                    ),
                  ],
                )
              : ListView(
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
                          if (agenda.tickets.isNotEmpty) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Tickets por confirmar',
                                    style: textos.titleLarge,
                                  ),
                                ),
                                Pildora(
                                  texto: '${agenda.tickets.length}',
                                  color: Colores.aviso,
                                  icono: Icons.schedule_rounded,
                                ),
                              ],
                            ),
                            const SizedBox(height: Espacios.m),
                            ...filas(agenda.tickets, ticket: true),
                            const SizedBox(height: Espacios.l),
                          ],
                          CalendarioAgenda(
                            visitas: agenda.proximos,
                            diaElegido: dia,
                            alElegir: (d) => setState(() => _dia = d),
                          ),
                          const SizedBox(height: Espacios.xl),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                child: Text(
                                  tituloLista,
                                  style: textos.titleLarge,
                                ),
                              ),
                              if (cuantas != null)
                                Text(
                                  cuantas,
                                  style: textos.labelLarge?.copyWith(
                                    color: Colores.tintaSuave,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: Espacios.m),
                          if (proximos.isEmpty)
                            EstadoMensaje(
                              icono: Icons.event_busy_outlined,
                              compacto: true,
                              mensaje: dia == null
                                  ? 'No tienes visitas agendadas.'
                                  : 'Sin visitas ese día.',
                            )
                          else
                            ...filas(proximos, ticket: false),
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
  if (dias < 0) return 'Atrasado';
  return Formatos.fechaCorta(fecha);
}

/// Una visita en la línea de tiempo: la hora a la izquierda y la tarjeta con
/// un borde de color a la derecha (ámbar si es un ticket por confirmar, verde
/// si es hoy, celeste si es más adelante).
class _FilaAgenda extends StatelessWidget {
  const _FilaAgenda({
    required this.item,
    required this.esCliente,
    required this.ticket,
    required this.onTap,
  });

  final ItemAgenda item;
  final bool esCliente;
  final bool ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final fecha = item.fecha;
    final total = item.oferta.tarifa?.total ?? item.oferta.precioBase;
    final esHoy = fecha != null && DateUtils.isSameDay(fecha, DateTime.now());
    final color = ticket
        ? Colores.aviso
        : esHoy
        ? Colores.primarioVivo
        : Colores.cieloClaro;
    final estado = ticket
        ? 'Por confirmar'
        : esHoy
        ? 'Hoy'
        : 'Agendada';
    final colorEstado = ticket
        ? Colores.aviso
        : esHoy
        ? Colores.primario
        : Colores.info;

    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.grande),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 52,
              child: Padding(
                padding: const EdgeInsets.only(top: Espacios.m),
                child: Column(
                  children: [
                    Text(
                      fecha == null ? '--:--' : Formatos.hora(fecha),
                      style: textos.labelLarge?.copyWith(
                        color: Colores.primario,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      fecha == null ? 'Sin fecha' : _cuando(fecha),
                      textAlign: TextAlign.center,
                      style: textos.labelSmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: Espacios.s),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  Espacios.m + 2,
                  Espacios.m,
                  Espacios.m + 2,
                  Espacios.m,
                ),
                decoration: BoxDecoration(
                  color: Colores.tarjeta,
                  borderRadius: BorderRadius.circular(Radios.grande),
                  border: Border(left: BorderSide(color: color, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.solicitud.oficioNombre,
                            style: textos.titleMedium,
                          ),
                        ),
                        const SizedBox(width: Espacios.s),
                        Pildora(texto: estado, color: colorEstado),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      esCliente
                          ? '${item.oferta.tecnicoNombre} · '
                                '${item.solicitud.descripcion}'
                          : item.solicitud.descripcion,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                    const SizedBox(height: Espacios.xs),
                    Text(
                      '${Formatos.dinero(total)} la visita',
                      style: textos.labelMedium?.copyWith(
                        color: Colores.tintaSuave,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
