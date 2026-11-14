import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/tokens.dart';
import '../utils/formatos.dart';
import 'presencia_service.dart';

class IndicadorPresencia extends ConsumerWidget {
  const IndicadorPresencia({super.key, required this.usuarioId});

  final String usuarioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(estadoPresenciaProvider(usuarioId)).value;
    final visto = estado?.visto;
    if (estado == null || (!estado.enLinea && visto == null)) {
      return const SizedBox.shrink();
    }
    final texto = estado.enLinea
        ? 'En línea'
        : 'Activo ${Formatos.haceTiempo(visto!)}';
    return Semantics(
      label: texto,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: estado.enLinea ? Colores.primarioVivo : Colores.linea,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: estado.enLinea ? Colores.primario : Colores.tintaGris,
              fontWeight: estado.enLinea ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
