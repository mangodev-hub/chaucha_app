import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'presionable.dart';

class BotonCarga extends StatelessWidget {
  const BotonCarga({
    super.key,
    required this.texto,
    required this.cargando,
    required this.onPressed,
    this.icono,
    this.iconoAlFinal = false,
  });

  final String texto;
  final bool cargando;

  /// Si es null, el botón queda desactivado.
  final VoidCallback? onPressed;

  /// Ícono opcional junto al texto.
  final IconData? icono;

  /// Pone el ícono a la derecha del texto ("Iniciar sesión →").
  final bool iconoAlFinal;

  @override
  Widget build(BuildContext context) {
    final duracion = Movimiento.de(context, Movimiento.normal);
    final boton = FilledButton(
      onPressed: cargando ? null : onPressed,
      child: AnimatedSize(
        duration: duracion,
        curve: Movimiento.entrada,
        child: AnimatedSwitcher(
          duration: duracion,
          switchInCurve: Movimiento.entrada,
          switchOutCurve: Movimiento.entrada,
          transitionBuilder: (child, animacion) => FadeTransition(
            opacity: animacion,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1).animate(animacion),
              child: child,
            ),
          ),
          child: cargando
              ? const SizedBox.square(
                  key: ValueKey('cargando'),
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    semanticsLabel: 'Cargando',
                  ),
                )
              : KeyedSubtree(
                  key: ValueKey(('contenido', texto, icono)),
                  child: _contenido(),
                ),
        ),
      ),
    );
    return Presionable(
      activo: !cargando && onPressed != null,
      escala: 0.96,
      child: boton,
    );
  }

  Widget _contenido() {
    final icono = this.icono;
    if (icono == null) return Text(texto);
    final partes = [
      Icon(icono),
      const SizedBox(width: Espacios.s),
      Flexible(child: Text(texto)),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconoAlFinal ? partes.reversed.toList() : partes,
    );
  }
}
