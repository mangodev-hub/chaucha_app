import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class EncabezadoPantalla extends StatelessWidget {
  const EncabezadoPantalla({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.icono,
    this.centrado = false,
    this.grande = false,
  });

  final String titulo;
  final String? subtitulo;

  /// Ícono azul junto al título (por ejemplo, el escudo de verificación).
  final IconData? icono;
  final bool centrado;

  /// Título más grande (registro).
  final bool grande;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final subtitulo = this.subtitulo;
    final icono = this.icono;
    final alineacion = centrado ? TextAlign.center : TextAlign.start;
    final titulo = Text(
      this.titulo,
      textAlign: alineacion,
      style: grande ? textos.headlineMedium : textos.headlineSmall,
    );
    return Column(
      crossAxisAlignment: centrado
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (icono == null)
          titulo
        else
          Row(
            mainAxisSize: centrado ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Icon(icono, color: Colores.primario, size: 28),
              const SizedBox(width: Espacios.s),
              Flexible(child: titulo),
            ],
          ),
        if (subtitulo != null) ...[
          const SizedBox(height: Espacios.xs + 2),
          Text(
            subtitulo,
            textAlign: alineacion,
            style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ],
    );
  }
}
