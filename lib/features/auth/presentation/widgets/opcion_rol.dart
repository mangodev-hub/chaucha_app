import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/tarjeta_app.dart';

class OpcionRol extends StatelessWidget {
  const OpcionRol({
    super.key,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.elegida,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool elegida;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: elegida,
      child: TarjetaApp(
        onTap: onTap,
        radio: Radios.medio,
        conBorde: false,
        color: elegida ? Colores.tarjeta : Colores.superficie,
        colorBorde: elegida ? Colores.primario : Colores.superficie,
        padding: const EdgeInsets.all(Espacios.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconoRecuadro(icono: icono, lado: 32),
                const Spacer(),
                if (elegida)
                  const Icon(
                    Icons.check_circle,
                    color: Colores.primario,
                    size: 22,
                  ),
              ],
            ),
            const SizedBox(height: Espacios.s),
            Text(titulo, style: textos.titleSmall),
            const SizedBox(height: 2),
            Text(
              descripcion,
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
          ],
        ),
      ),
    );
  }
}
