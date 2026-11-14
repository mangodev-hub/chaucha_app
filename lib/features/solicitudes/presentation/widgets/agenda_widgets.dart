import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../../domain/entities/visita_agenda.dart';

const _gris = Colores.tintaGris;
const _tinta = Colores.tintaTitulo;
const _finde = Color(0xFFFAFCFA);
const _rojoAhora = Color(0xFFD93025);

const diasCortos = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];
const diasLargos = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];
const mesesNombre = [
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

/// "Sábado 14 de noviembre".
String tituloDia(DateTime d) =>
    '${diasLargos[d.weekday - 1]} ${d.day} de '
    '${mesesNombre[d.month - 1].toLowerCase()}';

/// (fondo, texto) de cada estado; iguales en todas las vistas.
(Color, Color) coloresVisita(EstadoVisita e) => switch (e) {
  EstadoVisita.agendada => (Colores.cieloSuave, Colores.cieloOscuro),
  EstadoVisita.enCurso => (Colores.primarioSuave, Colores.primario),
  EstadoVisita.porConfirmar => (Colores.avisoSuave, Colores.aviso),
};

String nombreEstado(EstadoVisita e) => switch (e) {
  EstadoVisita.agendada => 'Agendada',
  EstadoVisita.enCurso => 'En curso',
  EstadoVisita.porConfirmar => 'Por confirmar',
};

/// Lunes de la semana de [d].
DateTime lunesDe(DateTime d) =>
    DateUtils.dateOnly(d).subtract(Duration(days: d.weekday - 1));

/// Los 42 días (6 semanas) de la grilla del mes de [mes].
List<DateTime> diasGrillaMes(DateTime mes) {
  final inicio = lunesDe(DateTime(mes.year, mes.month));
  return [for (var i = 0; i < 42; i++) DateUtils.addDaysToDate(inicio, i)];
}

Map<DateTime, List<VisitaAgenda>> porDia(List<VisitaAgenda> visitas) {
  final mapa = <DateTime, List<VisitaAgenda>>{};
  for (final v in visitas) {
    mapa.putIfAbsent(DateUtils.dateOnly(v.inicio), () => []).add(v);
  }
  return mapa;
}

// ------------------------------------------------------------ selector

class SelectorVistaAgenda<T> extends StatelessWidget {
  const SelectorVistaAgenda({
    super.key,
    required this.opciones,
    required this.valor,
    required this.onCambio,
  });

  final Map<T, String> opciones;
  final T valor;
  final ValueChanged<T> onCambio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colores.divisor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(:key, :value) in opciones.entries)
            Semantics(
              button: true,
              selected: key == valor,
              child: GestureDetector(
                onTap: () => onCambio(key),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: key == valor ? Colores.tarjeta : null,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: key == valor
                          ? const [
                              BoxShadow(
                                color: Color(0x140E2A14),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      value,
                      style: textos.labelLarge?.copyWith(
                        fontSize: 13,
                        color: key == valor ? _tinta : _gris,
                        fontWeight: key == valor
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------- cabecera calendario

class CabeceraCalendario extends StatelessWidget {
  const CabeceraCalendario({
    super.key,
    required this.titulo,
    required this.onHoy,
    required this.onAnterior,
    required this.onSiguiente,
  });

  final String titulo;
  final VoidCallback onHoy;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radios.pequeno),
    );
    Widget flecha(IconData icono, String ayuda, VoidCallback onTap) =>
        SizedBox.square(
          dimension: 36,
          child: IconButton.outlined(
            tooltip: ayuda,
            onPressed: onTap,
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              side: const BorderSide(color: Colores.linea),
              shape: forma,
            ),
            icon: Icon(icono, size: 20, color: _tinta),
          ),
        );
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _tinta,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: onHoy,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            side: const BorderSide(color: Colores.linea),
            foregroundColor: _tinta,
            shape: forma,
          ),
          child: const Text('Hoy'),
        ),
        const SizedBox(width: Espacios.s),
        flecha(Icons.chevron_left_rounded, 'Anterior', onAnterior),
        const SizedBox(width: Espacios.xs),
        flecha(Icons.chevron_right_rounded, 'Siguiente', onSiguiente),
      ],
    );
  }
}

// ------------------------------------------------------------- vista mes

class VistaMesAgenda extends StatelessWidget {
  const VistaMesAgenda({
    super.key,
    required this.mes,
    required this.visitas,
    required this.onVisita,
    this.compacta = false,
    this.diaElegido,
    this.onDia,
    this.hoy,
  });

  final DateTime mes;
  final List<VisitaAgenda> visitas;
  final ValueChanged<VisitaAgenda> onVisita;

  /// Móvil: celdas de 44 px con puntos de color; tocar un día lo elige.
  final bool compacta;
  final DateTime? diaElegido;
  final ValueChanged<DateTime>? onDia;

  /// Solo para pruebas.
  final DateTime? hoy;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final dias = diasGrillaMes(mes);
    final mapa = porDia(visitas);
    final hoy = DateUtils.dateOnly(this.hoy ?? DateTime.now());

    Widget celda(DateTime d) {
      final delMes = d.month == mes.month;
      final esHoy = d == hoy;
      final finde = d.weekday >= 6;
      final lista = mapa[d] ?? const <VisitaAgenda>[];
      final elegido = compacta && diaElegido == d;
      final numero = esHoy
          ? Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colores.primario,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${d.day}',
                style: textos.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colores.tarjeta,
                ),
              ),
            )
          : Text(
              '${d.day}',
              style: textos.labelSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: delMes ? _tinta : Colores.linea,
              ),
            );
      final fondo = elegido
          ? Colores.primarioSuave
          : esHoy
          ? Colores.fondoClaro
          : finde
          ? _finde
          : Colores.tarjeta;
      final borde = Border(
        right: d.weekday == 7
            ? BorderSide.none
            : const BorderSide(color: Colores.divisor),
        bottom: const BorderSide(color: Colores.divisor),
      );

      if (compacta) {
        return Semantics(
          button: true,
          selected: elegido,
          label:
              '${tituloDia(d)}${lista.isEmpty ? '' : ', ${lista.length} visitas'}',
          excludeSemantics: true,
          child: InkWell(
            onTap: onDia == null ? null : () => onDia!(d),
            child: Container(
              height: 44,
              decoration: BoxDecoration(color: fondo, border: borde),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  numero,
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final v in lista.take(3))
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: coloresVisita(v.estado).$2,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Container(
        constraints: const BoxConstraints(minHeight: 96),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: fondo, border: borde),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                numero,
                if (esHoy) ...[
                  const SizedBox(width: 4),
                  Text(
                    'Hoy',
                    style: textos.labelSmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colores.primario,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            for (final v in lista.take(2))
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: PildoraVisita(visita: v, onTap: () => onVisita(v)),
              ),
            if (lista.length > 2)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '+${lista.length - 2} más',
                  style: textos.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _gris,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colores.divisor)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (final d in diasCortos)
                Expanded(
                  child: Text(
                    compacta ? d.substring(0, 1) : d,
                    textAlign: compacta ? TextAlign.center : TextAlign.start,
                    style: textos.labelSmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _gris,
                    ),
                  ).paddingSiNo(!compacta),
                ),
            ],
          ),
        ),
        for (var semana = 0; semana < 6; semana++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(child: celda(dias[semana * 7 + i])),
              ],
            ),
          ),
      ],
    );
  }
}

extension on Widget {
  Widget paddingSiNo(bool si) =>
      si ? Padding(padding: const EdgeInsets.only(left: 6), child: this) : this;
}

/// Píldora de una visita en la celda del mes: la hora y el oficio.
class PildoraVisita extends StatelessWidget {
  const PildoraVisita({super.key, required this.visita, required this.onTap});

  final VisitaAgenda visita;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final (fondo, color) = coloresVisita(visita.estado);
    return Semantics(
      button: true,
      label:
          '${Formatos.hora(visita.inicio)} ${visita.oficio}, '
          '${nombreEstado(visita.estado)}',
      excludeSemantics: true,
      child: Material(
        color: fondo,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatos.hora(visita.inicio),
                  style: textos.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  visita.oficio,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.labelSmall?.copyWith(
                    fontSize: 11,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------- vista semana

class VistaSemanaAgenda extends StatelessWidget {
  const VistaSemanaAgenda({
    super.key,
    required this.lunes,
    required this.visitas,
    required this.onVisita,
    this.diasVisibles = 7,
    this.ahora,
  });

  final DateTime lunes;
  final List<VisitaAgenda> visitas;
  final ValueChanged<VisitaAgenda> onVisita;

  /// En el móvil se ven 3 días y el resto se desliza.
  final int diasVisibles;

  /// Solo para pruebas.
  final DateTime? ahora;

  static const int horaInicio = 7;
  static const int horaFin = 20;
  static const double altoHora = 48;
  static const double anchoHoras = 48;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final ahora = this.ahora ?? DateTime.now();
    final hoy = DateUtils.dateOnly(ahora);
    final dias = [
      for (var i = 0; i < 7; i++) DateUtils.addDaysToDate(lunes, i),
    ];
    final mapa = porDia(visitas);
    const horas = horaFin - horaInicio;
    const alto = horas * altoHora;

    double y(DateTime t) =>
        ((t.hour + t.minute / 60) - horaInicio).clamp(0, horas.toDouble()) *
        altoHora;

    Widget columna(DateTime d, double ancho) {
      final esHoy = d == hoy;
      final lista = mapa[d] ?? const <VisitaAgenda>[];
      return SizedBox(
        width: ancho,
        child: Column(
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: esHoy ? Colores.fondoClaro : null,
                border: const Border(
                  bottom: BorderSide(color: Colores.divisor),
                  left: BorderSide(color: Colores.divisor),
                ),
              ),
              child: Text(
                '${diasCortos[d.weekday - 1]} ${d.day}',
                style: textos.labelSmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: esHoy ? Colores.primario : _gris,
                ),
              ),
            ),
            SizedBox(
              height: alto,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: esHoy
                            ? Colores.fondoClaro
                            : d.weekday >= 6
                            ? _finde
                            : null,
                        border: const Border(
                          left: BorderSide(color: Colores.divisor),
                        ),
                      ),
                    ),
                  ),
                  for (var h = 1; h < horas; h++)
                    Positioned(
                      top: h * altoHora,
                      left: 0,
                      right: 0,
                      child: const Divider(height: 1, color: Colores.divisor),
                    ),
                  for (final v in lista)
                    if (v.fin.hour + v.fin.minute / 60 > horaInicio &&
                        v.inicio.hour < horaFin)
                      Positioned(
                        top: y(v.inicio) + 1,
                        height: (y(v.fin) - y(v.inicio) - 2).clamp(22, alto),
                        left: 3,
                        right: 3,
                        child: _BloqueSemana(
                          visita: v,
                          onTap: () => onVisita(v),
                        ),
                      ),
                  if (esHoy && ahora.hour >= horaInicio && ahora.hour < horaFin)
                    Positioned(
                      top: y(ahora),
                      left: 0,
                      right: 0,
                      child: Semantics(
                        label: 'Hora actual',
                        child: Container(height: 2, color: _rojoAhora),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final columnaHoras = SizedBox(
      width: anchoHoras,
      child: Column(
        children: [
          const SizedBox(height: 40),
          SizedBox(
            height: alto,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (var h = 0; h < horas; h++)
                  Positioned(
                    top: h * altoHora - (h == 0 ? 0 : 7),
                    right: 6,
                    child: Text(
                      '${(horaInicio + h).toString().padLeft(2, '0')}:00',
                      style: textos.labelSmall?.copyWith(
                        fontSize: 11,
                        color: _gris,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, r) {
        final ancho = (r.maxWidth - anchoHoras) / diasVisibles;
        final columnas = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final d in dias) columna(d, ancho)],
        );
        // En el móvil (3 días a la vista) se abre en hoy, si está en la semana.
        final indiceHoy = dias.indexOf(hoy);
        final inicial = indiceHoy < 0
            ? 0.0
            : (indiceHoy * ancho).clamp(0.0, (7 - diasVisibles) * ancho);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            columnaHoras,
            Expanded(
              child: diasVisibles >= 7
                  ? columnas
                  : _DeslizableDesde(
                      key: ValueKey(lunes),
                      inicial: inicial.toDouble(),
                      child: columnas,
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// Scroll horizontal que arranca en [inicial] (la columna de hoy). Crea su
/// controlador una sola vez y lo libera al salir.
class _DeslizableDesde extends StatefulWidget {
  const _DeslizableDesde({
    super.key,
    required this.inicial,
    required this.child,
  });

  final double inicial;
  final Widget child;

  @override
  State<_DeslizableDesde> createState() => _DeslizableDesdeState();
}

class _DeslizableDesdeState extends State<_DeslizableDesde> {
  late final ScrollController _control = ScrollController(
    initialScrollOffset: widget.inicial,
  );

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: _control,
    scrollDirection: Axis.horizontal,
    child: widget.child,
  );
}

class _BloqueSemana extends StatelessWidget {
  const _BloqueSemana({required this.visita, required this.onTap});

  final VisitaAgenda visita;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final (fondo, color) = coloresVisita(visita.estado);
    final estilo = textos.labelSmall?.copyWith(fontSize: 11, color: color);
    return Semantics(
      button: true,
      label:
          '${Formatos.hora(visita.inicio)} ${visita.oficio} con '
          '${visita.otraPersonaNombre}, ${nombreEstado(visita.estado)}',
      excludeSemantics: true,
      child: Material(
        color: fondo,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: color, width: 3)),
            ),
            padding: const EdgeInsets.fromLTRB(6, 3, 4, 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatos.hora(visita.inicio),
                  maxLines: 1,
                  style: estilo?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${visita.oficio} · ${visita.otraPersonaNombre}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: estilo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------- tarjeta "Hoy"

class TarjetaHoyAgenda extends StatelessWidget {
  const TarjetaHoyAgenda({super.key, required this.proximas, this.ahora});

  /// Visitas desde el inicio de hoy, en orden.
  final List<VisitaAgenda> proximas;

  /// Solo para pruebas.
  final DateTime? ahora;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final ahora = this.ahora ?? DateTime.now();
    final hoy = DateUtils.dateOnly(ahora);
    final deHoy = [
      for (final v in proximas)
        if (DateUtils.dateOnly(v.inicio) == hoy) v,
    ];
    final siguientes = [
      for (final v in proximas)
        if (v.inicio.isAfter(ahora)) v,
    ];

    final String titulo;
    final String detalle;
    if (deHoy.isEmpty) {
      titulo = 'Hoy no tienes visitas';
      final proxima = siguientes.isEmpty ? null : siguientes.first;
      if (proxima == null) {
        detalle = 'No tienes visitas próximas.';
      } else {
        final dia = DateUtils.dateOnly(proxima.inicio);
        final cuando = dia == DateUtils.addDaysToDate(hoy, 1)
            ? 'mañana'
            : 'el ${diasCortos[dia.weekday - 1].toLowerCase()} ${dia.day}';
        detalle =
            'La próxima es $cuando a las ${Formatos.hora(proxima.inicio)}.';
      }
    } else {
      titulo = deHoy.length == 1
          ? 'Hoy tienes 1 visita'
          : 'Hoy tienes ${deHoy.length} visitas';
      final siguienteHoy = [
        for (final v in deHoy)
          if (v.inicio.isAfter(ahora)) v,
      ];
      detalle = siguienteHoy.isEmpty
          ? 'Ya pasaron todas las de hoy.'
          : 'La siguiente es a las ${Formatos.hora(siguienteHoy.first.inicio)} '
                'con ${siguienteHoy.first.otraPersonaNombre}.';
    }

    return _Tarjeta(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 60,
            decoration: BoxDecoration(
              color: Colores.primario,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  diasCortos[hoy.weekday - 1],
                  style: textos.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colores.tarjeta,
                  ),
                ),
                Text(
                  '${hoy.day}',
                  style: textos.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: Colores.tarjeta,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: textos.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: _tinta,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detalle,
                  style: textos.bodySmall?.copyWith(fontSize: 12, color: _gris),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Espacios.l),
    decoration: BoxDecoration(
      color: Colores.tarjeta,
      borderRadius: BorderRadius.circular(Radios.tarjeta),
      boxShadow: Sombras.tarjeta,
    ),
    child: child,
  );
}

// ----------------------------------------------------- tarjeta de trabajo

class TarjetaTrabajo extends StatelessWidget {
  const TarjetaTrabajo({
    super.key,
    required this.visita,
    required this.onReagendar,
    required this.onEscribir,
    required this.onConfirmar,
    this.onTap,
    this.ocupado = false,
  });

  final VisitaAgenda visita;
  final VoidCallback onReagendar;
  final VoidCallback onEscribir;
  final VoidCallback onConfirmar;
  final VoidCallback? onTap;
  final bool ocupado;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final v = visita;
    final (fondo, color) = coloresVisita(v.estado);
    final confirmar = v.meTocaConfirmar;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radios.pequeno),
    );
    final reagenda = v.reagendaInicio;
    final estiloBoton = textos.labelLarge?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w700,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colores.divisor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(Espacios.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 48,
                      decoration: BoxDecoration(
                        color: fondo,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            diasCortos[v.inicio.weekday - 1],
                            style: textos.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          Text(
                            '${v.inicio.day}',
                            style: textos.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Espacios.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${Formatos.hora(v.inicio)} a '
                            '${Formatos.hora(v.fin)} · ${v.oficio}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textos.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: _tinta,
                            ),
                          ),
                          Text(
                            v.descripcion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textos.bodySmall?.copyWith(
                              fontSize: 12,
                              color: _gris,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (v.estado == EstadoVisita.porConfirmar &&
                    reagenda != null) ...[
                  const SizedBox(height: Espacios.s),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colores.avisoSuave,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      v.reagendaPorMi
                          ? 'Propusiste cambiarla al '
                                '${Formatos.fechaCorta(reagenda)} a las '
                                '${Formatos.hora(reagenda)}. Esperando respuesta.'
                          : 'Propone cambiarla al '
                                '${Formatos.fechaCorta(reagenda)} a las '
                                '${Formatos.hora(reagenda)}.',
                      style: textos.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Colores.aviso,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: Espacios.s),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colores.fondoClaro,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      FotoPerfilCaja(
                        tamano: 28,
                        circular: true,
                        rutaFoto: v.otraPersonaFoto,
                        iniciales: v.iniciales,
                        colorFondo: Colores.cieloSuave,
                        estiloTexto: textos.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colores.cieloOscuro,
                        ),
                      ),
                      const SizedBox(width: Espacios.s),
                      Expanded(
                        child: Text(
                          v.otraPersonaNombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _tinta,
                          ),
                        ),
                      ),
                      Text(
                        Formatos.precio(v.precioVisita),
                        style: textos.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colores.cieloOscuro,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Espacios.s),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ocupado ? null : onReagendar,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          side: const BorderSide(color: Colores.linea),
                          foregroundColor: _tinta,
                          shape: forma,
                          textStyle: estiloBoton,
                        ),
                        child: Text(
                          confirmar ? 'Otra hora' : 'Reagendar',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    const SizedBox(width: Espacios.s),
                    Expanded(
                      child: FilledButton(
                        onPressed: ocupado
                            ? null
                            : confirmar
                            ? onConfirmar
                            : onEscribir,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: forma,
                          textStyle: estiloBoton,
                        ),
                        child: Text(
                          confirmar ? 'Confirmar' : 'Escribir',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
