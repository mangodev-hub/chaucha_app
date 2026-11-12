// Tarjeta de la oferta de un técnico (precio de la visita y solución) con sus
// acciones, y el formulario con el que el técnico ofrece sus servicios.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/cotizacion.dart';
import '../../domain/entities/tarifa.dart';

extension EstadoCotizacionVista on EstadoCotizacion {
  String get etiqueta => switch (this) {
    EstadoCotizacion.pendiente => 'Pendiente',
    EstadoCotizacion.aceptada => 'Aceptada',
    EstadoCotizacion.rechazada => 'No elegida',
  };

  /// Mismo criterio que los estados de solicitud: acento solo para lo positivo.
  Color get color => switch (this) {
    EstadoCotizacion.pendiente => Colores.info,
    EstadoCotizacion.aceptada => Colores.acento,
    EstadoCotizacion.rechazada => Colores.tintaSuave,
  };
}

/// Oferta de un técnico. Los botones solo aparecen si su callback no es null.
class CotizacionCard extends StatelessWidget {
  const CotizacionCard({
    super.key,
    required this.cotizacion,
    this.onChat,
    this.textoChat = 'Escribir al técnico',
    this.onVerPerfil,
    this.accionesActivas = true,
    this.destacada = false,
    this.miId,
    this.onReagendar,
    this.onResponderReagendado,
    this.onCancelarVisita,
  });

  final Cotizacion cotizacion;

  /// Abre el chat con el técnico.
  final VoidCallback? onChat;
  final String textoChat;

  /// Abre el perfil público del técnico (al tocar su nombre).
  final VoidCallback? onVerPerfil;

  /// En false, los botones se ven pero desactivados (hay una acción en curso).
  final bool accionesActivas;

  /// Borde de acento para la oferta aceptada.
  final bool destacada;

  /// Id del usuario conectado, para saber quién hizo la propuesta de fecha.
  final String? miId;
  final VoidCallback? onReagendar;
  final void Function(bool acepta)? onResponderReagendado;
  final VoidCallback? onCancelarVisita;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final c = cotizacion;
    final falta = c.tarifa?.fechaServicio?.difference(DateTime.now());
    final puedeCambiar = falta == null || falta >= const Duration(hours: 24);
    final f = c.fechaPropuesta;
    final solucion = c.solucion;
    return TarjetaApp(
      margin: const EdgeInsets.only(bottom: Espacios.m),
      colorBorde: destacada ? Colores.acento : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Tecnico(cotizacion: c, onVerPerfil: onVerPerfil),
          const SizedBox(height: Espacios.l),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Espacios.m + 2,
              vertical: Espacios.m,
            ),
            decoration: BoxDecoration(
              color: Colores.primarioSuave,
              borderRadius: BorderRadius.circular(Radios.medio),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Precio de la visita',
                    style: textos.titleSmall?.copyWith(
                      color: Colores.primarioOscuro,
                    ),
                  ),
                ),
                const SizedBox(width: Espacios.s),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      Formatos.dinero(c.precioBase),
                      style: textos.titleLarge?.copyWith(
                        color: Colores.primarioOscuro,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (solucion != null) ...[
            const SizedBox(height: Espacios.m),
            Text('Cómo lo resolvería', style: textos.labelLarge),
            const SizedBox(height: Espacios.xs),
            Text(
              solucion,
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
          ],
          if (c.tarifa case final tarifa?) ...[
            const SizedBox(height: Espacios.m),
            _ResumenTicket(
              tarifa: tarifa,
              confirmado: c.estado == EstadoCotizacion.aceptada,
            ),
          ],
          if (onReagendar != null ||
              onResponderReagendado != null ||
              onCancelarVisita != null) ...[
            const SizedBox(height: Espacios.m),
            _AccionesVisita(
              cotizacion: c,
              miId: miId,
              activas: accionesActivas,
              onReagendar: onReagendar,
              onResponder: onResponderReagendado,
              onCancelar: onCancelarVisita,
            ),
          ],
          if (onChat != null) ...[
            const SizedBox(height: Espacios.l),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
              onPressed: accionesActivas ? onChat : null,
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(textoChat),
            ),
          ],
        ],
      ),
    );
  }
}

/// Una línea con el ticket de trabajo: total acordado, fecha y su estado.
class _ResumenTicket extends StatelessWidget {
  const _ResumenTicket({required this.tarifa, required this.confirmado});

  final Tarifa tarifa;
  final bool confirmado;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final fecha = tarifa.fechaServicio;
    return Container(
      padding: const EdgeInsets.all(Espacios.m),
      decoration: BoxDecoration(
        color: Colores.superficie,
        borderRadius: BorderRadius.circular(Radios.medio),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 20,
            color: Colores.primario,
          ),
          const SizedBox(width: Espacios.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket: ${Formatos.dinero(tarifa.total)}',
                  style: textos.titleSmall,
                ),
                if (fecha != null)
                  Text(
                    'Servicio: ${Formatos.fechaCorta(fecha)}',
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Espacios.s),
          Flexible(
            child: confirmado
                ? const Pildora(texto: 'Confirmado', color: Colores.acento)
                : const Pildora(texto: 'Por confirmar', color: Colores.aviso),
          ),
        ],
      ),
    );
  }
}

/// Reagendar (por propuesta) y cancelar la visita acordada.
class _AccionesVisita extends StatelessWidget {
  const _AccionesVisita({
    required this.cotizacion,
    required this.miId,
    required this.activas,
    this.onReagendar,
    this.onResponder,
    this.onCancelar,
  });

  final Cotizacion cotizacion;
  final String? miId;
  final bool activas;
  final VoidCallback? onReagendar;
  final void Function(bool acepta)? onResponder;
  final VoidCallback? onCancelar;

  @override
  Widget build(BuildContext context) {
    final c = cotizacion;

    // Reagendar y cancelar exigen 24 h de anticipación (la base también lo valida).
    final falta = c.tarifa?.fechaServicio?.difference(DateTime.now());
    final puedeCambiar = falta == null || falta >= const Duration(hours: 24);

    // Una propuesta vencida ya no cuenta (la base tampoco la considera).
    final f = c.fechaPropuesta;
    final propuesta = f != null && f.isAfter(DateTime.now()) ? f : null;
    final esMia = c.propuestaPor != null && c.propuestaPor == miId;
    final cuando = propuesta == null
        ? ''
        : '${Formatos.fechaCorta(propuesta)} · ${Formatos.hora(propuesta)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (propuesta != null) ...[
          AvisoBanner(
            compacto: true,
            mensaje: esMia
                ? 'Propusiste reagendar para $cuando. Esperando respuesta.'
                : 'Te proponen reagendar la visita para $cuando.',
          ),
          const SizedBox(height: Espacios.s),
        ],
        if (propuesta != null && !esMia && onResponder != null)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: activas ? () => onResponder!(false) : null,
                  child: const Text('Rechazar'),
                ),
              ),
              const SizedBox(width: Espacios.s),
              Expanded(
                child: FilledButton(
                  onPressed: activas ? () => onResponder!(true) : null,
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          )
        else if (propuesta == null && onReagendar != null && puedeCambiar)
          OutlinedButton.icon(
            onPressed: activas ? onReagendar : null,
            icon: const Icon(Icons.event_repeat_outlined),
            label: const Text('Reagendar visita'),
          ),
        if (onCancelar != null && puedeCambiar)
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: activas ? onCancelar : null,
            icon: const Icon(Icons.event_busy_outlined),
            label: const Text('Cancelar visita'),
          ),
        if (!puedeCambiar && (onReagendar != null || onCancelar != null))
          Text(
            'Ya no se puede reagendar ni cancelar: faltan menos de 24 horas.',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Colores.tintaSuave),
          ),
      ],
    );
  }
}

/// Inicial, nombre y calificación del técnico, con el estado a la derecha.
/// Si hay [onVerPerfil], la fila se puede tocar para ver su perfil.
class _Tecnico extends StatelessWidget {
  const _Tecnico({required this.cotizacion, this.onVerPerfil});

  final Cotizacion cotizacion;
  final VoidCallback? onVerPerfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final c = cotizacion;
    final nombre = c.tecnicoNombre.trim();
    final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();
    final esNuevo = c.tecnicoCalificacion <= 0;
    final fila = Row(
      children: [
        CircleAvatar(
          backgroundColor: Colores.primarioSuave,
          foregroundColor: Colores.primarioOscuro,
          child: Text(
            inicial,
            style: textos.titleMedium?.copyWith(color: Colores.primarioOscuro),
          ),
        ),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.tecnicoNombre,
                style: textos.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  if (!esNuevo) ...[
                    const Icon(Icons.star, size: 16, color: Colores.estrella),
                    const SizedBox(width: Espacios.xs),
                  ],
                  Flexible(
                    child: Text(
                      // Sin reseñas todavía: "0.0" parecería una mala nota.
                      [
                        if (esNuevo)
                          'Técnico nuevo'
                        else
                          c.tecnicoCalificacion.toStringAsFixed(1),
                        if (onVerPerfil != null) 'Ver perfil',
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: onVerPerfil != null
                            ? Colores.primario
                            : Colores.tintaSuave,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: Espacios.s),
        Flexible(
          child: Pildora(texto: c.estado.etiqueta, color: c.estado.color),
        ),
      ],
    );
    if (onVerPerfil == null) return fila;
    return Semantics(
      button: true,
      label: 'Ver perfil de ${c.tecnicoNombre}',
      child: InkWell(
        onTap: onVerPerfil,
        borderRadius: BorderRadius.circular(Radios.medio),
        child: fila,
      ),
    );
  }
}

/// Formulario del técnico: precio de la visita y cómo resolvería el problema.
Future<String?> mostrarFormularioOferta(
  BuildContext context, {
  required double tarifaBase,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _FormularioOferta(tarifaBase: tarifaBase),
  );
}

class _FormularioOferta extends StatefulWidget {
  const _FormularioOferta({required this.tarifaBase});

  final double tarifaBase;

  @override
  State<_FormularioOferta> createState() => _FormularioOfertaState();
}

class _FormularioOfertaState extends State<_FormularioOferta> {
  final _formKey = GlobalKey<FormState>();
  final _solucion = TextEditingController();

  @override
  void dispose() {
    _solucion.dispose();
    super.dispose();
  }

  String? _validarPrecio(String? valor) {
    final error = FormValidators.monto(valor, campo: 'El precio de la visita');
    if (error != null) return error;
    final precio = double.parse(valor!.trim().replaceAll(',', '.'));
    return precio <= 0 ? 'El precio de la visita debe ser mayor que 0.' : null;
  }

  void _enviar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop<String>(context, _solucion.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.handyman_outlined),
      title: const Text('Ofrecer mis servicios'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(Espacios.m),
                decoration: BoxDecoration(
                  color: Colores.superficie,
                  borderRadius: BorderRadius.circular(Radios.medio),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: Colores.tintaSuave,
                    ),
                    const SizedBox(width: Espacios.s),
                    Expanded(
                      child: Text(
                        'Tu tarifa base (de tu perfil)',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: Colores.tintaSuave),
                      ),
                    ),
                    Text(
                      Formatos.dinero(widget.tarifaBase),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Espacios.l),
              CampoEtiquetado(
                etiqueta: '¿Cómo lo resolverías?',
                child: TextFormField(
                  controller: _solucion,
                  minLines: 3,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText:
                        'Qué harías, cuánto tiempo te tomaría y qué incluye '
                        'tu precio.',
                  ),
                  validator: (v) =>
                      FormValidators.requerido(v, campo: 'La solución'),
                ),
              ),
              const SizedBox(height: Espacios.l),
              const AvisoBanner(
                compacto: true,
                mensaje:
                    'Si al cliente le interesa, te escribirá para acordar el '
                    'precio final.',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: _enviar,
          child: const Text('Enviar oferta'),
        ),
      ],
    );
  }
}
