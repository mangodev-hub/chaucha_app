// Gran tarjeta clara donde va el contenido de cada pantalla que no se arma
// en bloques sueltos (listas, formularios, detalle, chat, admin). Sobre el
// fondo verde bosque nada queda suelto: el texto y las tarjetas viven aquí,
// sobre la superficie clara, con las esquinas muy redondeadas.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class HojaClara extends StatelessWidget {
  const HojaClara({
    super.key,
    required this.child,
    this.color = Colores.lienzo,
    this.margen = const EdgeInsets.fromLTRB(
      Espacios.s,
      Espacios.xs,
      Espacios.s,
      Espacios.s,
    ),
    this.abajoRecto = false,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry margen;

  /// Esquinas de abajo rectas y sin margen inferior: la hoja llega hasta el
  /// borde (pantallas con una barra de acción o un campo fijo abajo).
  final bool abajoRecto;

  @override
  Widget build(BuildContext context) {
    const radio = Radius.circular(Radios.bento);
    final borde = abajoRecto
        ? const BorderRadius.vertical(top: radio)
        : const BorderRadius.all(radio);
    return Padding(
      padding: abajoRecto
          ? margen.resolve(TextDirection.ltr).copyWith(bottom: 0)
          : margen,
      // Un Material (y no un ColoredBox) para que los toques de las listas
      // se dibujen encima de la hoja y no debajo.
      child: Material(
        color: color,
        borderRadius: borde,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
