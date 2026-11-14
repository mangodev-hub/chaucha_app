import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'tarjeta_inicio.dart';

class TarjetaCerca extends StatelessWidget {
  const TarjetaCerca({
    super.key,
    required this.titulo,
    required this.km,
    required this.minKm,
    required this.maxKm,
    required this.onKm,
    required this.mapa,
    required this.lista,
    this.onKmFin,
    this.etiquetaRadio,
    this.chips,
    this.cargando = false,
  });

  final String titulo;
  final double km;
  final double minKm;
  final double maxKm;
  final ValueChanged<double> onKm;
  final ValueChanged<double>? onKmFin;

  /// Texto antes del slider ("Mi radio de cobertura").
  final String? etiquetaRadio;
  final Widget? chips;

  /// El mapa con el alto que le toca.
  final Widget Function(double alto) mapa;

  /// La lista; con [conScroll] va en una caja de alto fijo junto al mapa.
  final Widget Function(bool conScroll) lista;
  final bool cargando;

  static const double anchoDosColumnas = 1100;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final ancho = MediaQuery.sizeOf(context).width >= anchoDosColumnas;
    final etiqueta = etiquetaRadio;
    final kmTexto = '${km.round()} km';

    final radio = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (etiqueta != null)
          Text(
            etiqueta,
            style: textos.labelMedium?.copyWith(color: Colores.tintaSuave),
          ),
        SizedBox(
          width: 200,
          child: Slider(
            value: km.clamp(minKm, maxKm),
            min: minKm,
            max: maxKm,
            divisions: (maxKm - minKm).round(),
            label: kmTexto,
            semanticFormatterCallback: (v) => '${v.round()} kilómetros',
            onChanged: onKm,
            onChangeEnd: onKmFin,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colores.cieloSuave,
            borderRadius: BorderRadius.circular(Radios.pildora),
          ),
          child: Text(
            kmTexto,
            style: textos.labelMedium?.copyWith(
              color: Colores.cieloOscuro,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );

    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Espacios.m,
            runSpacing: Espacios.xs,
            children: [
              Text(
                titulo,
                style: textos.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              FittedBox(fit: BoxFit.scaleDown, child: radio),
            ],
          ),
          if (chips != null) ...[const SizedBox(height: Espacios.s), chips!],
          const SizedBox(height: Espacios.m),
          SizedBox(
            height: 2,
            child: cargando
                ? const LinearProgressIndicator(minHeight: 2)
                : null,
          ),
          const SizedBox(height: Espacios.s),
          if (ancho)
            SizedBox(
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 6, child: mapa(400)),
                  const SizedBox(width: Espacios.m),
                  Expanded(flex: 4, child: lista(true)),
                ],
              ),
            )
          else ...[
            mapa(300),
            const SizedBox(height: Espacios.m),
            lista(false),
          ],
        ],
      ),
    );
  }
}

/// Fila de chips de oficio de selección única ("Todos" primero).
class ChipsOficio extends StatelessWidget {
  const ChipsOficio({
    super.key,
    required this.opciones,
    required this.seleccionado,
    required this.onCambio,
  });

  /// (id, nombre)
  final List<(int, String)> opciones;
  final int? seleccionado;
  final ValueChanged<int?> onCambio;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (id, nombre) in [(null, 'Todos'), ...opciones]) ...[
            ChoiceChip(
              label: Text(nombre),
              selected: seleccionado == id,
              onSelected: (_) => onCambio(id),
            ),
            const SizedBox(width: Espacios.s),
          ],
        ],
      ),
    );
  }
}
