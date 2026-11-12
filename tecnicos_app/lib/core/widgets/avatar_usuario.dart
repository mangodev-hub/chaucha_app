import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/core_providers.dart';
import '../storage/storage_service.dart';
import '../theme/tokens.dart';

class AvatarUsuario extends ConsumerWidget {
  const AvatarUsuario({
    super.key,
    required this.nombre,
    this.rutaFoto,
    this.radio = 24,
  });

  final String nombre;
  final String? rutaFoto;
  final double radio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = rutaFoto == null
        ? null
        : ref
              .watch(storageServiceProvider)
              .urlPublica(bucket: Buckets.perfiles, ruta: rutaFoto!);
    final t = nombre.trim();
    // Celeste: las personas son contexto, no acción.
    return CircleAvatar(
      radius: radio,
      backgroundColor: Colores.cieloSuave,
      backgroundImage: url == null ? null : NetworkImage(url),
      child: url != null
          ? null
          : Text(
              t.isEmpty ? '?' : t[0].toUpperCase(),
              style: TextStyle(
                color: Colores.cieloOscuro,
                fontSize: radio * 0.7,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}