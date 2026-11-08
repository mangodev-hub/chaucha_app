// Etiqueta corta en forma de píldora: fondo suave del color dado y texto en
// una versión más oscura del mismo color (para que se lea bien, AA).
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.m - 2,
        vertical: Espacios.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Row(
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
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: colorTexto, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
