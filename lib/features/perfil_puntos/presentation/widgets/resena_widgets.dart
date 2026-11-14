import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/perfil_publico.dart';

class TarjetaResena extends StatelessWidget {
  const TarjetaResena({super.key, required this.resena});

  final ResenaPublica resena;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final comentario = resena.comentario;
    return TarjetaApp(
      margin: const EdgeInsets.only(bottom: Espacios.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Semantics(
                label: '${resena.calificacion} de 5 estrellas',
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: i <= resena.calificacion
                              ? Colores.estrella
                              : Colores.linea,
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                Formatos.dia(resena.creadoEn),
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
            ],
          ),
          if (resena.etiquetas.isNotEmpty) ...[
            const SizedBox(height: Espacios.s),
            Wrap(
              spacing: Espacios.s,
              runSpacing: 4,
              children: [
                for (final e in resena.etiquetas)
                  Chip(
                    label: Text(e),
                    visualDensity: VisualDensity.compact,
                    labelStyle: textos.labelSmall,
                  ),
              ],
            ),
          ],
          if (comentario != null) ...[
            const SizedBox(height: Espacios.s),
            Text(comentario, style: textos.bodyMedium),
          ],
          const SizedBox(height: Espacios.s),
          Text(
            resena.autor,
            style: textos.labelMedium?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}
