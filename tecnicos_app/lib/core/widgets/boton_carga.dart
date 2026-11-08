// Botón principal que se desactiva y muestra un indicador mientras [cargando].
import 'package:flutter/material.dart';

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
    if (cargando) {
      return const FilledButton(
        onPressed: null,
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final icono = this.icono;
    if (icono != null) {
      return FilledButton.icon(
        style: iconoAlFinal
            ? const ButtonStyle(iconAlignment: IconAlignment.end)
            : null,
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(texto),
      );
    }
    return FilledButton(onPressed: onPressed, child: Text(texto));
  }
}
