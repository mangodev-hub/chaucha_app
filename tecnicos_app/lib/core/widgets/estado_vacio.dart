// Mensaje centrado para listas vacías.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key, required this.icono, required this.mensaje});

  final IconData icono;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espacios.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Colores.superficie,
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 40, color: Colores.tinta),
              ),
              const SizedBox(height: Espacios.l),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colores.tintaSuave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
