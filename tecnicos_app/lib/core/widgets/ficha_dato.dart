// Ficha oscura con un dato corto (día, mes, hora): verde bosque con texto
// blanco. Varias en fila arman una fecha: [jue] [12] [nov]  [10:00].
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class FichaDato extends StatelessWidget {
  const FichaDato({super.key, required this.texto, this.grande = false});

  final String texto;

  /// Más alta y con letra mayor (la hora).
  final bool grande;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Espacios.m,
        vertical: grande ? Espacios.l : Espacios.m + 2,
      ),
      decoration: BoxDecoration(
        color: Colores.primario,
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: (grande ? textos.titleLarge : textos.titleMedium)?.copyWith(
          color: Colores.sobreOscuro,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Fecha y hora como fichas: "jue 12 nov · 10:00".
class FichasFecha extends StatelessWidget {
  const FichasFecha({super.key, required this.fecha});

  final DateTime fecha;

  static const _dias = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
  static const _meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  @override
  Widget build(BuildContext context) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return Wrap(
      spacing: Espacios.s,
      runSpacing: Espacios.s,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FichaDato(texto: _dias[fecha.weekday - 1]),
        FichaDato(texto: '${fecha.day}'),
        FichaDato(texto: _meses[fecha.month - 1]),
        const SizedBox(width: Espacios.s),
        FichaDato(
          texto: '${dos(fecha.hour)}:${dos(fecha.minute)}',
          grande: true,
        ),
      ],
    );
  }
}
