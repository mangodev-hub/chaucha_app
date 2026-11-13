// Progreso por pasos: barras horizontales, con encabezado ("Paso 2 de 3")
// y etiquetas bajo cada paso, ambos opcionales. Al avanzar, la barra se
// llena con una animación y la etiqueta del paso actual pasa a negrita.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class IndicadorPasos extends StatelessWidget {
  const IndicadorPasos({
    super.key,
    required this.total,
    required this.completados,
    this.titulo,
    this.detalle,
    this.etiquetas,
    this.color = Colores.primarioOscuro,
  }) : assert(etiquetas == null || etiquetas.length == total);

  final int total;

  /// Cuántas barras van llenas (de izquierda a derecha).
  final int completados;

  /// Texto a la izquierda, arriba de las barras ("Paso 2 de 3").
  final String? titulo;

  /// Texto azul a la derecha, arriba de las barras.
  final String? detalle;

  /// Una etiqueta bajo cada barra. Se resalta la del último paso completado.
  final List<String>? etiquetas;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final titulo = this.titulo;
    final detalle = this.detalle;
    final etiquetas = this.etiquetas;
    final actual = completados - 1;
    final duracion = Movimiento.de(context, Movimiento.normal);

    return Semantics(
      label:
          titulo ??
          (etiquetas != null && actual >= 0
              ? 'Paso ${actual + 1} de $total: ${etiquetas[actual]}'
              : '$completados de $total'),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (titulo != null || detalle != null) ...[
              Row(
                children: [
                  if (titulo != null)
                    Expanded(
                      child: Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textos.labelLarge,
                      ),
                    )
                  else
                    const Spacer(),
                  if (detalle != null)
                    Flexible(
                      child: Text(
                        detalle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: textos.labelLarge?.copyWith(
                          color: Colores.primario,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Espacios.s),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < total; i++) ...[
                  if (i > 0) const SizedBox(width: Espacios.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fondo claro con el relleno encima, que crece de
                        // izquierda a derecha al completar el paso.
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colores.primarioClaro,
                            borderRadius: BorderRadius.circular(Radios.pildora),
                          ),
                          child: AnimatedFractionallySizedBox(
                            duration: duracion,
                            curve: Movimiento.entrada,
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: i < completados ? 1 : 0,
                            heightFactor: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(
                                  Radios.pildora,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (etiquetas != null) ...[
                          const SizedBox(height: Espacios.xs),
                          AnimatedDefaultTextStyle(
                            duration: duracion,
                            style: (textos.labelSmall ?? const TextStyle())
                                .copyWith(
                                  color: i == actual
                                      ? Colores.tinta
                                      : Colores.tintaSuave,
                                  fontWeight: i == actual
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                            child: Text(etiquetas[i], maxLines: 2),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
