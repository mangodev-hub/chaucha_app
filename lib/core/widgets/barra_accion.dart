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
