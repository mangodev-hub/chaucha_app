// Selector de visita: día y franjas de 1 hora en una cuadrícula. Las franjas
// que ya pasaron salen atenuadas y las que se cruzan con otra visita (del
// técnico o del cliente) salen bloqueadas con un candado: así nadie queda con
// dos trabajos a la misma hora. Hoja inferior en móvil, diálogo en escritorio.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entities/rango_ocupado.dart';

typedef CargarOcupados =
    Future<List<RangoOcupado>> Function(DateTime desde, DateTime hasta);

Future<DateTime?> elegirFranja(
  BuildContext context, {
  required CargarOcupados cargarOcupados,
  DateTime? inicial,
  String titulo = 'Fecha y hora de la visita',
}) {
  if (ResponsiveLayout.isDesktop(context)) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(Espacios.l),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: _SelectorFranja(
            cargarOcupados: cargarOcupados,
            inicial: inicial,
            titulo: titulo,
          ),
        ),
      ),
    );
  }
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _SelectorFranja(
      cargarOcupados: cargarOcupados,
      inicial: inicial,
      titulo: titulo,
    ),
  );
}

class _SelectorFranja extends StatefulWidget {
  const _SelectorFranja({
    required this.cargarOcupados,
    required this.titulo,
    this.inicial,
  });

  final CargarOcupados cargarOcupados;
  final String titulo;
  final DateTime? inicial;

  @override
  State<_SelectorFranja> createState() => _SelectorFranjaState();
}

class _SelectorFranjaState extends State<_SelectorFranja> {
  static const _horaPrimera = 7;
  static const _horaUltima = 19;
  static const _diasMaximos = 90;
  static const _duracion = Duration(hours: 1);

  static const _diasCortos = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
  static const _mesesCortos = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  final _hoy = DateUtils.dateOnly(DateTime.now());
  late DateTime _dia;
  DateTime? _franja;
  List<RangoOcupado> _ocupados = const [];
  Object? _error;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    final inicial = widget.inicial;
    _dia = inicial == null || inicial.isBefore(_hoy)
        ? _hoy
        : DateUtils.dateOnly(inicial);
    unawaited(_cargar());
  }

  Future<void> _cargar() async {
    try {
      final ocupados = await widget.cargarOcupados(
        _hoy,
        _hoy.add(const Duration(days: _diasMaximos + 1)),
      );
      if (!mounted) return;
      setState(() {
        _ocupados = ocupados;
        _error = null;
        _cargando = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _cargando = false;
      });
    }
  }

  void _reintentar() {
    setState(() {
      _cargando = true;
      _error = null;
    });
    unawaited(_cargar());
  }

  bool _pasada(DateTime inicio) => !inicio.isAfter(DateTime.now());

  bool _ocupada(DateTime inicio) =>
      _ocupados.any((o) => o.seCruzaCon(inicio, _duracion));

  bool _libre(DateTime inicio) => !_pasada(inicio) && !_ocupada(inicio);

  String _etiquetaDia(DateTime d) =>
      '${_diasCortos[d.weekday - 1]} ${d.day} de ${_mesesCortos[d.month - 1]}';

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final franjas = [
      for (var h = _horaPrimera; h <= _horaUltima; h++)
        DateTime(_dia.year, _dia.month, _dia.day, h),
    ];
    final hayLibres = franjas.any(_libre);
    final elegida = _franja;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Espacios.l,
        Espacios.s,
        Espacios.l,
        Espacios.l,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.titulo, style: textos.titleLarge),
                    Text(
                      'Franjas de 1 hora',
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Cerrar',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          CalendarDatePicker(
            initialDate: _dia,
            firstDate: _hoy,
            lastDate: _hoy.add(const Duration(days: _diasMaximos)),
            onDateChanged: (d) => setState(() {
              _dia = DateUtils.dateOnly(d);
              _franja = null;
            }),
          ),
          const SizedBox(height: Espacios.s),
          Text(
            'Hora de la visita · ${_etiquetaDia(_dia)}',
            style: textos.titleSmall,
          ),
          const SizedBox(height: Espacios.s),
          const _Leyenda(),
          const SizedBox(height: Espacios.m),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.all(Espacios.xl),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null) ...[
            AvisoBanner(
              tipo: TipoAviso.error,
              mensaje: AsyncValueView.mensajeDe(_error!),
            ),
            TextButton(onPressed: _reintentar, child: const Text('Reintentar')),
          ] else ...[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Espacios.s,
              crossAxisSpacing: Espacios.s,
              childAspectRatio: 3.6,
              children: [
                for (final f in franjas)
                  _Franja(
                    inicio: f,
                    estado: _pasada(f)
                        ? _EstadoFranja.pasada
                        : _ocupada(f)
                        ? _EstadoFranja.ocupada
                        : elegida == f
                        ? _EstadoFranja.elegida
                        : _EstadoFranja.libre,
                    onTap: () => setState(() => _franja = f),
                  ),
              ],
            ),
            const SizedBox(height: Espacios.m),
            AvisoBanner(
              compacto: true,
              tipo: hayLibres ? TipoAviso.info : TipoAviso.aviso,
              mensaje: hayLibres
                  ? 'Las franjas ocupadas son visitas que el técnico o el '
                        'cliente ya tienen agendadas: nadie queda con dos '
                        'trabajos a la misma hora.'
                  : 'No hay horas libres este día. Elige otro día.',
            ),
          ],
          const SizedBox(height: Espacios.l),
          FilledButton(
            onPressed: elegida == null
                ? null
                : () => Navigator.pop(context, elegida),
            child: Text(
              elegida == null
                  ? 'Elige una franja libre'
                  : 'Confirmar ${_etiquetaDia(elegida)}, '
                        '${Formatos.hora(elegida)} a '
                        '${Formatos.hora(elegida.add(_duracion))}',
            ),
          ),
        ],
      ),
    );
  }
}

enum _EstadoFranja { libre, elegida, ocupada, pasada }

/// Una franja de la cuadrícula. Libre: blanca con borde; elegida: verde
/// bosque; ocupada: rayada con candado; pasada: atenuada.
class _Franja extends StatelessWidget {
  const _Franja({
    required this.inicio,
    required this.estado,
    required this.onTap,
  });

  final DateTime inicio;
  final _EstadoFranja estado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final hora = Formatos.hora(inicio);
    final bloqueada =
        estado == _EstadoFranja.ocupada || estado == _EstadoFranja.pasada;
    final elegida = estado == _EstadoFranja.elegida;
    final duracion = Movimiento.de(context, Movimiento.normal);

    final decoracion = switch (estado) {
      _EstadoFranja.elegida => BoxDecoration(
        color: Colores.primario,
        borderRadius: BorderRadius.circular(Radios.medio),
      ),
      _EstadoFranja.ocupada => BoxDecoration(
        // Rayas finas en diagonal: "este espacio ya está tomado".
        gradient: const LinearGradient(
          begin: Alignment(-1, -1),
          end: Alignment(-0.85, -0.7),
          tileMode: TileMode.repeated,
          stops: [0, 0.5, 0.5, 1],
          colors: [
            Colores.superficie,
            Colores.superficie,
            Colores.superficieFuerte,
            Colores.superficieFuerte,
          ],
        ),
        borderRadius: BorderRadius.circular(Radios.medio),
        border: Border.all(color: Colores.linea),
      ),
      _EstadoFranja.pasada => BoxDecoration(
        borderRadius: BorderRadius.circular(Radios.medio),
        border: Border.all(color: Colores.linea),
      ),
      _EstadoFranja.libre => BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.medio),
        border: Border.all(color: Colores.linea, width: 1.5),
      ),
    };
    final colorTexto = switch (estado) {
      _EstadoFranja.elegida => Colores.tarjeta,
      _EstadoFranja.ocupada => Colores.tintaSuave,
      _EstadoFranja.pasada => Colores.tintaSuave.withValues(alpha: 0.6),
      _EstadoFranja.libre => Colores.tinta,
    };
    final descripcion = switch (estado) {
      _EstadoFranja.elegida => '$hora, elegida',
      _EstadoFranja.ocupada => '$hora, ocupada por otra visita',
      _EstadoFranja.pasada => '$hora, ya pasó',
      _EstadoFranja.libre => '$hora, libre',
    };

    return Semantics(
      button: true,
      enabled: !bloqueada,
      selected: elegida,
      label: descripcion,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: duracion,
          curve: Movimiento.entrada,
          decoration: decoracion,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: bloqueada ? null : onTap,
              borderRadius: BorderRadius.circular(Radios.medio),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (estado == _EstadoFranja.ocupada) ...[
                      Icon(Icons.lock_outline_rounded, size: 16, color: colorTexto),
                      const SizedBox(width: Espacios.xs + 2),
                    ],
                    Text(
                      hora,
                      style: textos.labelLarge?.copyWith(
                        color: colorTexto,
                        fontWeight: FontWeight.w700,
                        decoration: estado == _EstadoFranja.pasada
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  const _Leyenda();

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: Colores.tintaSuave);
    Widget muestra(BoxDecoration decoracion, String texto) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: decoracion),
        const SizedBox(width: Espacios.xs + 1),
        Text(texto, style: estilo),
      ],
    );
    final radio = BorderRadius.circular(4);
    return Wrap(
      spacing: Espacios.m,
      runSpacing: Espacios.xs,
      children: [
        muestra(
          BoxDecoration(
            color: Colores.tarjeta,
            borderRadius: radio,
            border: Border.all(color: Colores.linea, width: 1.5),
          ),
          'Libre',
        ),
        muestra(
          BoxDecoration(
            color: Colores.superficieFuerte,
            borderRadius: radio,
          ),
          'Ocupada por otra visita',
        ),
        muestra(
          BoxDecoration(
            borderRadius: radio,
            border: Border.all(color: Colores.linea),
          ),
          'Ya pasó',
        ),
      ],
    );
  }
}
