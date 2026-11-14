import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'presionable.dart';

class TarjetaOpcion extends StatelessWidget {
  const TarjetaOpcion({
    super.key,
    required this.titulo,
    required this.icono,
    this.subtitulo,
    this.onTap,
    this.color = Colores.cieloSuave,
    this.colorIcono = Colores.cieloOscuro,
  });

  final String titulo;
  final String? subtitulo;
  final IconData icono;
  final VoidCallback? onTap;
  final Color color;
  final Color colorIcono;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final subtitulo = this.subtitulo;
    final radio = BorderRadius.circular(Radios.subtarjeta);
    final tarjeta = Material(
      color: Colores.tarjeta,
      borderRadius: radio,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 96,
              color: color,
              alignment: Alignment.center,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colores.tarjeta.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, color: colorIcono, size: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Espacios.m + 2,
                Espacios.m,
                Espacios.m,
                Espacios.m,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.titleSmall,
                        ),
                        if (subtitulo != null)
                          Text(
                            subtitulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textos.labelSmall?.copyWith(
                              color: Colores.tintaSuave,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: Espacios.s),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colores.primarioSuave,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colores.primario,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) return tarjeta;
    return Presionable(escala: 0.97, child: tarjeta);
  }
}
