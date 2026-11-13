// Tarjeta blanca del inicio del cliente: radio de 18 y sombra suave.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class TarjetaInicio extends StatelessWidget {
  const TarjetaInicio({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.alto,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double? alto;

  @override
  Widget build(BuildContext context) {
    final borde = BorderRadius.circular(Radios.tarjeta);
    return Container(
      height: alto,
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: borde,
        boxShadow: Sombras.tarjeta,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: borde,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
