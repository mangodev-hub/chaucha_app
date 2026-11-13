// "¿No tienes cuenta? Regístrate": pregunta en gris y enlace azul en negrita.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class EnlaceAuth extends StatelessWidget {
  const EnlaceAuth({
    super.key,
    required this.pregunta,
    required this.accion,
    required this.onPressed,
  });

  final String pregunta;
  final String accion;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          pregunta,
          style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: Espacios.xs + 2),
            textStyle: textos.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          child: Text(accion),
        ),
      ],
    );
  }
}
