import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/estado_mensaje.dart';

class SolicitudPublicada extends StatelessWidget {
  const SolicitudPublicada({
    super.key,
    required this.onVerSolicitud,
    required this.onVolver,
  });

  final VoidCallback onVerSolicitud;
  final VoidCallback onVolver;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Movimiento.de(context, Movimiento.normal),
      curve: Movimiento.entrada,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, Espacios.l * (1 - t)),
          child: child,
        ),
      ),
      // Los lectores de pantalla anuncian el éxito al aparecer.
      child: Semantics(
        liveRegion: true,
        child: EstadoMensaje(
          icono: Icons.assignment_turned_in_outlined,
          tipo: TipoEstado.exito,
          titulo: '¡Solicitud registrada con éxito!',
          mensaje:
              'Los técnicos de tu zona ya pueden verla y enviarte '
              'ofertas.',
          textoAccion: 'Ver mi solicitud',
          onAccion: onVerSolicitud,
          textoAccionSecundaria: 'Volver al inicio',
          onAccionSecundaria: onVolver,
        ),
      ),
    );
  }
}
