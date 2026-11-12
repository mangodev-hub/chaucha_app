// Selector de visita: día y franjas de 1 hora. Las franjas que ya pasaron o
// que se cruzan con otra visita (del técnico o del cliente) salen
// deshabilitadas.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../domain/entities/rango_ocupado.dart';

typedef CargarOcupados =
    Future<List<RangoOcupado>> Function(DateTime desde, DateTime hasta);

Future<DateTime?> elegirFranja(
  BuildContext context, {
  required CargarOcupados cargarOcupados,
  DateTime? inicial,
  String titulo = 'Fecha y hora de la visita',
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => _DialogoFranja(
      cargarOcupados: cargarOcupados,
      inicial: inicial,
      titulo: titulo,
    ),
  );
}

class _DialogoFranja extends StatefulWidget {
  const _DialogoFranja({
    required this.cargarOcupados,
    required this.titulo,
    this.inicial,
  });

  final CargarOcupados cargarOcupados;
  final String titulo;
  final DateTime? inicial;

  @override
  State<_DialogoFranja> createState() => _DialogoFranjaState();
}

class _DialogoFranjaState extends State<_DialogoFranja> {
  static const _horaPrimera = 7;
  static const _horaUltima = 19;
  static const _diasMaximos = 90;
  static const _duracion = Duration(hours: 1);

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

  bool _libre(DateTime inicio) =>
      inicio.isAfter(DateTime.now()) &&
      !_ocupados.any((o) => o.seCruzaCon(inicio, _duracion));

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final franjas = [
      for (var h = _horaPrimera; h <= _horaUltima; h++)
        DateTime(_dia.year, _dia.month, _dia.day, h),
    ];
    final hayLibres = franjas.any(_libre);
    return Dialog(
      insetPadding: const EdgeInsets.all(Espacios.m),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Espacios.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.titulo, style: textos.titleLarge),
              const SizedBox(height: Espacios.s),
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
              Text('Hora de la visita (1 hora)', style: textos.titleSmall),
              const SizedBox(height: Espacios.s),
              if (_cargando)
                const Center(child: CircularProgressIndicator())
              else if (_error != null) ...[
                Text(
                  AsyncValueView.mensajeDe(_error!),
                  style: textos.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                TextButton(
                  onPressed: _reintentar,
                  child: const Text('Reintentar'),
                ),
              ] else ...[
                Wrap(
                  spacing: Espacios.s,
                  runSpacing: Espacios.s,
                  children: [
                    for (final f in franjas)
                      ChoiceChip(
                        label: Text(Formatos.hora(f)),
                        selected: _franja == f,
                        onSelected: _libre(f)
                            ? (_) => setState(() => _franja = f)
                            : null,
                      ),
                  ],
                ),
                const SizedBox(height: Espacios.s),
                Text(
                  hayLibres
                      ? 'Las horas deshabilitadas ya pasaron o están ocupadas.'
                      : 'No hay horas libres este día. Elige otro día.',
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
              const SizedBox(height: Espacios.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: Espacios.s),
                  FilledButton(
                    onPressed: _franja == null
                        ? null
                        : () => Navigator.pop(context, _franja),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}