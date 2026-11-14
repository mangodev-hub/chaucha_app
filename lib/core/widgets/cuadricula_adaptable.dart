import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class CuadriculaAdaptable extends StatelessWidget {
  const CuadriculaAdaptable({
    super.key,
    required this.children,
    this.columnas = 2,
    this.anchoMinimo = 640,
    this.espacio = Espacios.m,
  });

  final List<Widget> children;

  /// Columnas cuando hay al menos [anchoMinimo] de ancho disponible.
  final int columnas;
  final double anchoMinimo;
  final double espacio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        final porFila = restricciones.maxWidth >= anchoMinimo ? columnas : 1;
        final filas = <Widget>[];
        for (var i = 0; i < children.length; i += porFila) {
          if (i > 0) filas.add(SizedBox(height: espacio));
          filas.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var j = 0; j < porFila; j++) ...[
                  if (j > 0) SizedBox(width: espacio),
                  Expanded(
                    child: i + j < children.length
                        ? children[i + j]
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: filas,
        );
      },
    );
  }
}
