// Calendario mensual de la agenda: marca con un punto los días con visitas y
// deja elegir un día para filtrar la lista. El día elegido va en verde
// bosque, hoy lleva un borde verde y los puntos son verde brote.
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../providers/agenda_provider.dart';

class CalendarioAgenda extends StatefulWidget {
  const CalendarioAgenda({
    super.key,
    required this.visitas,
    required this.diaElegido,
    required this.alElegir,
  });

  final List<ItemAgenda> visitas;
  final DateTime? diaElegido;
  final ValueChanged<DateTime?> alElegir;

  static const meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  /// Iniciales de lunes a domingo, como en los calendarios de Ecuador.
  static const diasSemana = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  State<CalendarioAgenda> createState() => _CalendarioAgendaState();
}

class _CalendarioAgendaState extends State<CalendarioAgenda> {
  DateTime _enfoque = DateTime.now();

  List<ItemAgenda> _deDia(DateTime dia) => [
    for (final v in widget.visitas)
      if (v.fecha != null && isSameDay(v.fecha, dia)) v,
  ];

  void _mover(int meses) => setState(
    () => _enfoque = DateTime(_enfoque.year, _enfoque.month + meses, 1),
  );

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final hoy = DateUtils.dateOnly(DateTime.now());
    final radio = BorderRadius.circular(Radios.medio);
    return TarjetaApp(
      padding: const EdgeInsets.fromLTRB(
        Espacios.s + 2,
        Espacios.m,
        Espacios.s + 2,
        Espacios.s + 2,
      ),
      child: Column(
        children: [
          // Cabecera propia, en español, sin depender del locale del sistema.
          Row(
            children: [
              IconButton(
                tooltip: 'Mes anterior',
                onPressed: () => _mover(-1),
                icon: const Icon(Icons.chevron_left_rounded),
                color: Colores.primario,
              ),
              Expanded(
                child: Text(
                  '${CalendarioAgenda.meses[_enfoque.month - 1]} '
                  '${_enfoque.year}',
                  textAlign: TextAlign.center,
                  style: textos.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Mes siguiente',
                onPressed: () => _mover(1),
                icon: const Icon(Icons.chevron_right_rounded),
                color: Colores.primario,
              ),
            ],
          ),
          TableCalendar<ItemAgenda>(
            firstDay: hoy.subtract(const Duration(days: 365)),
            lastDay: hoy.add(const Duration(days: 365)),
            focusedDay: _enfoque,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
            rowHeight: 46,
            daysOfWeekHeight: 26,
            eventLoader: _deDia,
            selectedDayPredicate: (d) =>
                widget.diaElegido != null && isSameDay(widget.diaElegido, d),
            onDaySelected: (elegido, enfoque) {
              setState(() => _enfoque = enfoque);
              widget.alElegir(
                isSameDay(elegido, widget.diaElegido) ? null : elegido,
              );
            },
            onPageChanged: (enfoque) => setState(() => _enfoque = enfoque),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (dia, _) =>
                  CalendarioAgenda.diasSemana[dia.weekday - 1],
              weekdayStyle: textos.labelSmall!.copyWith(
                color: Colores.tintaSuave,
                fontWeight: FontWeight.w700,
              ),
              weekendStyle: textos.labelSmall!.copyWith(
                color: Colores.tintaSuave,
                fontWeight: FontWeight.w700,
              ),
            ),
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(3),
              defaultTextStyle: textos.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              weekendTextStyle: textos.bodyMedium!.copyWith(
                color: Colores.tintaSuave,
                fontWeight: FontWeight.w600,
              ),
              outsideTextStyle: textos.bodyMedium!.copyWith(
                color: Colores.tintaSuave.withValues(alpha: 0.5),
              ),
              defaultDecoration: BoxDecoration(borderRadius: radio),
              weekendDecoration: BoxDecoration(borderRadius: radio),
              outsideDecoration: BoxDecoration(borderRadius: radio),
              selectedDecoration: BoxDecoration(
                color: Colores.primario,
                borderRadius: radio,
              ),
              selectedTextStyle: textos.bodyMedium!.copyWith(
                color: Colores.tarjeta,
                fontWeight: FontWeight.w800,
              ),
              todayDecoration: BoxDecoration(
                border: Border.all(color: Colores.primarioVivo, width: 1.5),
                borderRadius: radio,
              ),
              todayTextStyle: textos.bodyMedium!.copyWith(
                color: Colores.primario,
                fontWeight: FontWeight.w800,
              ),
              markersMaxCount: 1,
              markersAutoAligned: false,
            ),
            // El punto del día con visitas: verde brote, o celeste sobre el
            // día elegido para que se siga viendo.
            calendarBuilders: CalendarBuilders<ItemAgenda>(
              markerBuilder: (context, dia, visitas) {
                if (visitas.isEmpty) return null;
                final elegido =
                    widget.diaElegido != null &&
                    isSameDay(widget.diaElegido, dia);
                return Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: elegido
                            ? Colores.cieloClaro
                            : Colores.primarioClaro,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
