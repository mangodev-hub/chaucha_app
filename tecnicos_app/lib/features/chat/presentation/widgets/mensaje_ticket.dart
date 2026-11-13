import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/mensaje.dart';

class MensajeTicket extends StatelessWidget {
  const MensajeTicket({
    super.key,
    required this.mensaje,
    required this.esMio,
    required this.pendiente,
    required this.puedeResponder,
    this.onAceptar,
    this.onRechazar,
  });

  final Mensaje mensaje;
  final bool esMio;

  /// Es el último ticket y nadie lo ha respondido.
  final bool pendiente;

  /// Soy el cliente y puedo aceptar o rechazar.
  final bool puedeResponder;
  final VoidCallback? onAceptar;
  final VoidCallback? onRechazar;

  double _valor(String clave) =>
      (mensaje.datos?[clave] as num?)?.toDouble() ?? 0;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final fecha = DateTime.tryParse('${mensaje.datos?['fecha_servicio']}')
        ?.toLocal();
    final estado = pendiente
        ? 'Esperando respuesta del cliente'
        : 'Ticket respondido';
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Espacios.xs),
          child: TarjetaApp(
            padding: const EdgeInsets.all(Espacios.m + 2),
            colorBorde: pendiente ? Colores.primario : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const IconoRecuadro(
                      icono: Icons.receipt_long_outlined,
                      lado: 32,
                    ),
                    const SizedBox(width: Espacios.s),
                    Text('Ticket de trabajo', style: textos.titleSmall),
                  ],
                ),
                const SizedBox(height: Espacios.m),
                // El precio, grande: es lo que el cliente decide.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      Formatos.dinero(_valor('total')),
                      style: textos.headlineSmall,
                    ),
                    const SizedBox(width: Espacios.s),
                    Expanded(
                      child: Text(
                        'la visita',
                        style: textos.bodySmall?.copyWith(
                          color: Colores.tintaSuave,
                        ),
                      ),
                    ),
                  ],
                ),
                if (fecha != null) ...[
                  const SizedBox(height: Espacios.s),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_outlined,
                        size: 18,
                        color: Colores.cielo,
                      ),
                      const SizedBox(width: Espacios.xs + 2),
                      Expanded(
                        child: Text(
                          '${Formatos.fechaCorta(fecha)} · '
                          '${Formatos.hora(fecha)} a '
                          '${Formatos.hora(fecha.add(const Duration(hours: 1)))}',
                          style: textos.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: Espacios.m),
                if (puedeResponder)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRechazar,
                          child: const Text('Rechazar'),
                        ),
                      ),
                      const SizedBox(width: Espacios.s),
                      Expanded(
                        child: FilledButton(
                          onPressed: onAceptar,
                          child: const Text('Aceptar'),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    estado,
                    textAlign: TextAlign.center,
                    style: textos.labelMedium?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Aviso centrado para mensajes del sistema (ticket aceptado, rechazado...):
/// verde claro con texto verde bosque.
class NotaSistema extends StatelessWidget {
  const NotaSistema(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Espacios.s),
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.m,
          vertical: Espacios.s,
        ),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colores.primarioSuave,
          borderRadius: BorderRadius.circular(Radios.medio),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colores.primarioOscuro,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
