// Calendario mensual de la agenda: marca los días con visitas y deja elegir
// un día para filtrar la lista.
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

  @override
  State<CalendarioAgenda> createState() => _CalendarioAgendaState();
}

class _CalendarioAgendaState extends State<CalendarioAgenda> {
  DateTime _enfoque = DateTime.now();

  List<ItemAgenda> _deDia(DateTime dia) => [
    for (final v in widget.visitas)
      if (v.fecha != null && isSameDay(v.fecha, dia)) v,
  ];

  @override
  Widget build(BuildContext context) {
    final hoy = DateUtils.dateOnly(DateTime.now());
    return TarjetaApp(
      child: TableCalendar<ItemAgenda>(
        firstDay: hoy.subtract(const Duration(days: 365)),
        lastDay: hoy.add(const Duration(days: 365)),
        focusedDay: _enfoque,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        eventLoader: _deDia,
        selectedDayPredicate: (d) =>
            widget.diaElegido != null && isSameDay(widget.diaElegido, d),
        onDaySelected: (elegido, enfoque) {
          setState(() => _enfoque = enfoque);
          widget.alElegir(
            isSameDay(elegido, widget.diaElegido) ? null : elegido,
          );
        },
        onPageChanged: (enfoque) => _enfoque = enfoque,
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Colores.primario,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colores.primarioSuave,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(color: Colores.tinta),
          markerDecoration: const BoxDecoration(
            color: Colores.primario,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}