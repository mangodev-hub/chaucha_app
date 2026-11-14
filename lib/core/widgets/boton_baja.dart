import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class BotonBaja extends StatelessWidget {
  const BotonBaja({super.key, this.onConfirmar});

  /// Se ejecuta cuando la persona confirma la baja.
  final Future<void> Function()? onConfirmar;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => mostrarDialogoBaja(context, onConfirmar: onConfirmar),
      icon: const Icon(Icons.person_remove_outlined, size: 18),
      label: const Text(
        'Darse de baja',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colores.error,
        backgroundColor: Colores.error.withValues(alpha: 0.08),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.medio),
          side: BorderSide(color: Colores.error.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}

Future<void> mostrarDialogoBaja(
  BuildContext context, {
  Future<void> Function()? onConfirmar,
  String detalle =
      'Tu cuenta quedará desactivada y dejarás de recibir solicitudes.',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colores.tarjeta,
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Colores.error,
        size: 40,
      ),
      title: const Text('¿Quieres darte de baja de ChauchaApp?'),
      content: Text(detalle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Mantener mi cuenta'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await onConfirmar?.call();
          },
          style: FilledButton.styleFrom(backgroundColor: Colores.error),
          child: const Text('Continuar con la baja'),
        ),
      ],
    ),
  );
}
