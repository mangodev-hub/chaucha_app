// Tarjeta de una reseña: estrellas, fecha, comentario y autor (nombre corto).
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        Icon(
                          i <= resena.calificacion
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 18,
                          color: Colores.estrella,
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
