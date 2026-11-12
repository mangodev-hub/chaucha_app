// Fila de datos: una píldora ancha y neutra con la etiqueta a la izquierda y
// el valor grande a la derecha (precio de la visita, ticket, fecha). El valor
// va en celeste oscuro: es información, no una acción.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class FilaDato extends StatelessWidget {
  const FilaDato({
    super.key,
    required this.etiqueta,
    this.valor,
    this.detalle,
    this.icono,
    this.trailing,
  });

  /// Texto principal de la izquierda ("Precio de la visita", "Ticket: $15").
  final String etiqueta;

  /// Valor grande a la derecha ("$15,00"). Opcional si hay [trailing].
  final String? valor;

  /// Segunda línea bajo la etiqueta ("Visita: mar 24 de nov · 10:00").
  final String? detalle;
  final IconData? icono;

  /// Lo que va al final en lugar del valor, o después de él (una `Pildora`).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final valor = this.valor;
    final detalle = this.detalle;
    final icono = this.icono;
    final trailing = this.trailing;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.l,
        vertical: Espacios.m,
      ),
      decoration: BoxDecoration(
        color: Colores.neutro,
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      child: Row(
        children: [
          if (icono != null) ...[
            Icon(icono, size: 22, color: Colores.cieloOscuro),
            const SizedBox(width: Espacios.m),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: detalle == null
                      ? textos.bodyMedium?.copyWith(color: Colores.tintaSuave)
                      : textos.titleSmall,
                ),
                if (detalle != null)
                  Text(
                    detalle,
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
              ],
            ),
          ),
          if (valor != null) ...[
            const SizedBox(width: Espacios.m),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  valor,
                  style: textos.headlineSmall?.copyWith(
                    color: Colores.cieloOscuro,
                  ),
                ),
              ),
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: Espacios.s),
            Flexible(child: trailing),
          ],
        ],
      ),
    );
  }
}
