import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Fila de chips para filtrar; desliza de lado si no caben.
class FiltroChips<T> extends StatelessWidget {
  const FiltroChips({
    super.key,
    required this.opciones,
    required this.seleccionado,
    required this.onCambio,
  });

  /// Valor y etiqueta de cada chip.
  final List<(T, String)> opciones;
  final T seleccionado;
  final ValueChanged<T> onCambio;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (valor, etiqueta) in opciones)
            Padding(
              padding: const EdgeInsets.only(right: Espacios.s),
              child: ChoiceChip(
                label: Text(etiqueta),
                selected: valor == seleccionado,
                onSelected: (_) => onCambio(valor),
              ),
            ),
        ],
      ),
    );
  }
}
