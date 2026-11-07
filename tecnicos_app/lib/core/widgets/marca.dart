// Marca de la app: ícono + nombre.
//
// PROVISIONAL: es un ícono de Material, no un logo. Se reemplaza cuando el
// equipo defina la identidad visual (ver `docs/DISENO.md`).
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class Marca extends StatelessWidget {
  const Marca({super.key, this.grande = false, this.sobreOscuro = false});

  /// Versión grande (splash, panel de login en escritorio).
  final bool grande;

  /// Colores invertidos para fondos oscuros.
  final bool sobreOscuro;

  static const String nombre = 'Técnicos a domicilio';

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final lado = grande ? 56.0 : 40.0;
    final colorTexto = sobreOscuro ? Colors.white : Colores.tinta;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: lado,
          height: lado,
          decoration: BoxDecoration(
            color: sobreOscuro ? Colors.white : Colores.tinta,
            borderRadius: BorderRadius.circular(Radios.medio),
          ),
          child: Icon(
            Icons.handyman_rounded,
            size: lado * 0.55,
            color: sobreOscuro ? Colores.tinta : Colors.white,
          ),
        ),
        const SizedBox(width: Espacios.m),
        Flexible(
          child: Text(
            nombre,
            style: (grande ? textos.headlineSmall : textos.titleLarge)
                ?.copyWith(color: colorTexto),
          ),
        ),
      ],
    );
  }
}
