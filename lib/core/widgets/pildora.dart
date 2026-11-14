import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class Pildora extends StatelessWidget {
  const Pildora({
    super.key,
    required this.texto,
    required this.color,
    this.icono,
  });

  final String texto;
  final Color color;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final colorTexto = Color.lerp(color, Colores.tinta, 0.4)!;
    final duracion = Movimiento.de(context, Movimiento.normal);
    return AnimatedContainer(
      duration: duracion,
      curve: Movimiento.entrada,
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.m - 2,
        vertical: Espacios.xs,
      ),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withValues(alpha: 0.12), Colores.tarjeta),
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: AnimatedSize(
        duration: duracion,
        curve: Movimiento.entrada,
        child: AnimatedSwitcher(
          duration: duracion,
          child: Row(
            key: ValueKey((texto, color, icono)),
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icono != null) ...[
                Icon(icono, size: 15, color: colorTexto),
                const SizedBox(width: Espacios.xs),
              ],
              Flexible(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorTexto,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
