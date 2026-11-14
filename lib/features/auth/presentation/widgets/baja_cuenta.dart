import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/widgets/boton_baja.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../domain/entities/rol.dart';
import '../providers/sesion_provider.dart';

Future<void> confirmarBaja(BuildContext context, WidgetRef ref) {
  final esTecnico = ref.read(usuarioActualProvider)?.rol == Rol.tecnico;
  final messenger = ScaffoldMessenger.maybeOf(context);
  return mostrarDialogoBaja(
    context,
    detalle: esTecnico
        ? 'Tu cuenta quedará desactivada y se retirarán tus ofertas. Las '
              'visitas que tenías aceptadas volverán a estar disponibles '
              'para otros técnicos.'
        : 'Tu cuenta quedará desactivada y se cancelarán tus solicitudes '
              'activas.',
    onConfirmar: () async {
      try {
        await ref.read(sesionProvider.notifier).darseDeBaja();
      } on AppFailure catch (e) {
        if (context.mounted) {
          context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
        } else {
          messenger?.showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
    },
  );
}
