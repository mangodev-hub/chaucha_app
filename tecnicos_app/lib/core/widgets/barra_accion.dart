// Barra fija en la parte inferior con la acción principal de la pantalla
// (móvil). Se usa como `bottomNavigationBar` debajo de una
// `HojaClara(abajoRecto: true)`: continúa la hoja con el mismo margen
// lateral y la cierra con las esquinas redondeadas. También puede ir al
// final de una Column que ya está dentro de la hoja.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class BarraAccion extends StatelessWidget {
  const BarraAccion({super.key, required this.child, this.ancho = 900});

  final Widget child;
  final double ancho;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Espacios.s,
          0,
          Espacios.s,
          Espacios.s,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colores.lienzo,
            border: Border(top: BorderSide(color: Colores.linea)),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Radios.bento),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Espacios.l,
              Espacios.m,
              Espacios.l,
              Espacios.m,
            ),
            // No se usa AnchoMaximo: su Align ocuparía todo el alto
            // disponible y la barra taparía la pantalla. heightFactor: 1
            // ajusta al botón.
            child: Align(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: ancho),
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
