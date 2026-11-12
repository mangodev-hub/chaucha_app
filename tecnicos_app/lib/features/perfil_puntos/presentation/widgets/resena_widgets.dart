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
                label: 'Valoración ${resena.calificacion >= 4 ? "excelente" : resena.calificacion == 3 ? "neutra" : "mala"}',
                child: ExcludeSemantics(
                  child: Icon(
  resena.calificacion >= 4
      ? Icons.sentiment_very_satisfied_rounded
      : resena.calificacion == 3
          ? Icons.thumb_up_alt_outlined
          : Icons.sentiment_very_dissatisfied_rounded,
  size: 22,
  color: Colores.estrella,
)
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
