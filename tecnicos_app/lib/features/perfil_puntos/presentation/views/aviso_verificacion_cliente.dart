import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import 'verificacion_view.dart';
import '../../../../core/errors/app_failure.dart';

class AvisoVerificacionCliente extends ConsumerWidget {
  const AvisoVerificacionCliente({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null || usuario.verificado) return const SizedBox.shrink();
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      onTap: () async {
        await mostrarVerificacion(context);
        await refrescarVerificacion(ref);
      },
      colorBorde: Colores.primarioClaro,
      child: Row(
        children: [
          const IconoRecuadro(icono: Icons.shield_outlined, lado: 44),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verifica tu identidad', style: textos.titleSmall),
                Text(
                  'Necesitas verificarte para pedir un técnico. '
                  'Sube tu cédula y una selfie.',
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colores.primario),
        ],
      ),
    );
  }
}

/// Devuelve true si el cliente puede continuar. Si no está verificado,
/// muestra un diálogo que lo lleva a verificarse y devuelve false.
Future<bool> exigirVerificado(BuildContext context, WidgetRef ref) async {
  if (ref.read(usuarioActualProvider)?.verificado ?? true) return true;
  await refrescarVerificacion(ref);
  if (ref.read(usuarioActualProvider)?.verificado ?? true) return true;
  if (!context.mounted) return false;
  final ir = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Verifica tu identidad'),
      content: const Text(
        'Para pedir un técnico primero debes verificar tu cédula. '
        'Mientras tanto puedes navegar y chatear.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Ahora no'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Verificarme'),
        ),
      ],
    ),
  );
  if (ir == true && context.mounted) mostrarVerificacion(context);
  return false;
}

Future<void> refrescarVerificacion(WidgetRef ref) async {
  try {
    await ref.read(sesionProvider.notifier).recargarUsuario();
  } on AppFailure {
    return;
  }
}