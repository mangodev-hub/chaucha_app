// Piezas del ticket de trabajo (tarifa) en el chat: la franja bajo la barra
// superior, el detalle del ticket y el formulario con el que el técnico lo
// envía ("Empezar trabajo").
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/cotizacion.dart';
import '../../domain/entities/tarifa.dart';

/// Desglose del ticket: precio de la visita y fecha.
class DesgloseTarifa extends StatelessWidget {
  const DesgloseTarifa({
    super.key,
    required this.tarifa,
    required this.precioBase,
  });

  final Tarifa tarifa;
  final double precioBase;

  @override
  Widget build(BuildContext context) {
    final fecha = tarifa.fechaServicio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if ((tarifa.precioAcordado - precioBase).abs() > 0.001)
          _Fila(
            etiqueta: 'Precio de referencia',
            valor: Formatos.dinero(precioBase),
            tenue: true,
          ),
        _Fila(
          etiqueta: 'Precio de la visita',
          valor: Formatos.dinero(tarifa.precioAcordado),
        ),
        if (fecha != null)
          _Fila(
            etiqueta: 'Fecha y hora',
            valor: '${Formatos.fechaCorta(fecha)} · ${Formatos.hora(fecha)}',
          ),
      ],
    );
  }
}

class _Fila extends StatelessWidget {
  const _Fila({
    required this.etiqueta,
    required this.valor,
    this.tenue = false,
  });

  final String etiqueta;
  final String valor;
  final bool tenue;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
          ),
          const SizedBox(width: Espacios.s),
          Text(
            valor,
            style: textos.bodyMedium?.copyWith(
              color: tenue ? Colores.tintaSuave : Colores.tinta,
            ),
          ),
        ],
      ),
    );
  }
}

/// Hoja inferior con el ticket. Si hay [onConfirmar] y [onRechazar] (cliente
/// con ticket pendiente), muestra los botones; la hoja se cierra al tocarlos.
Future<void> mostrarDetalleTarifa(
  BuildContext context, {
  required Cotizacion oferta,
  VoidCallback? onConfirmar,
  VoidCallback? onRechazar,
}) {
  final tarifa = oferta.tarifa;
  if (tarifa == null) return Future.value();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (hoja) {
      final textos = Theme.of(hoja).textTheme;
      final aceptada = oferta.estado == EstadoCotizacion.aceptada;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Espacios.xl,
          0,
          Espacios.xl,
          Espacios.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const IconoRecuadro(icono: Icons.receipt_long_outlined),
                const SizedBox(width: Espacios.m),
                Expanded(
                  child: Text('Ticket de trabajo', style: textos.titleLarge),
                ),
                const SizedBox(width: Espacios.s),
                Flexible(
                  child: aceptada
                      ? const Pildora(
                          texto: 'Confirmado',
                          color: Colores.acento,
                        )
                      : const Pildora(
                          texto: 'Por confirmar',
                          color: Colores.aviso,
                        ),
                ),
              ],
            ),
            const SizedBox(height: Espacios.xs),
            Text(
              'Enviado por ${oferta.tecnicoNombre}',
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
            const SizedBox(height: Espacios.l),
            DesgloseTarifa(tarifa: tarifa, precioBase: oferta.precioBase),
            if (onConfirmar != null && onRechazar != null) ...[
              const SizedBox(height: Espacios.xl),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(hoja);
                  onConfirmar();
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirmar ticket'),
              ),
              const SizedBox(height: Espacios.s),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(hoja).colorScheme.error,
                ),
                onPressed: () {
                  Navigator.pop(hoja);
                  onRechazar();
                },
                child: const Text('Rechazar'),
              ),
            ],
          ],
        ),
      );
    },
  );
}

/// Franja fija bajo la barra superior del chat: el botón "Empezar trabajo"
/// del técnico, o el estado del ticket.
class FranjaTarifa extends StatelessWidget {
  const FranjaTarifa({
    super.key,
    required this.soyCliente,
    this.oferta,
    this.onEmpezar,
    this.onVerTicket,
    this.cargando = false,
    this.error,
  });

  final bool soyCliente;

  /// Oferta del técnico de la conversación (con su ticket, si lo hay).
  final Cotizacion? oferta;

  /// Si no es null, se muestra "Empezar trabajo" (técnico).
  final VoidCallback? onEmpezar;

  /// Abre el detalle del ticket.
  final VoidCallback? onVerTicket;
  final bool cargando;

  /// Si no se pudo cargar la información del ticket.
  final String? error;

  @override
  Widget build(BuildContext context) {
    final contenido = _contenido(context);
    if (contenido == null) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colores.tarjeta,
        border: Border(bottom: BorderSide(color: Colores.linea)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.l,
          vertical: Espacios.s + 2,
        ),
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: contenido,
          ),
        ),
      ),
    );
  }

  Widget? _contenido(BuildContext context) {
    final error = this.error;
    if (error != null) {
      return AvisoBanner(compacto: true, tipo: TipoAviso.error, mensaje: error);
    }
    final oferta = this.oferta;
    final tarifa = oferta?.tarifa;
    if (oferta != null && tarifa != null) {
      final aceptada = oferta.estado == EstadoCotizacion.aceptada;
      final mensaje = aceptada
          ? 'Trabajo acordado por ${Formatos.dinero(tarifa.total)}.'
          : soyCliente
          ? 'El técnico te envió un ticket por '
                '${Formatos.dinero(tarifa.total)}.'
          : 'Enviaste un ticket por ${Formatos.dinero(tarifa.total)}. '
                'Esperando al cliente.';
      return _ConBoton(
        aviso: AvisoBanner(
          compacto: true,
          tipo: aceptada ? TipoAviso.exito : TipoAviso.info,
          icono: aceptada
              ? Icons.handshake_outlined
              : Icons.receipt_long_outlined,
          mensaje: mensaje,
        ),
        boton: onVerTicket == null
            ? null
            : TextButton(
                onPressed: onVerTicket,
                child: Text(
                  soyCliente && oferta.tarifaPendiente ? 'Revisar' : 'Ver',
                ),
              ),
      );
    }
    final onEmpezar = this.onEmpezar;
    if (onEmpezar == null) return null;
    // Botón a la izquierda; en pantallas angostas la ayuda baja debajo.
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: Espacios.m,
        runSpacing: Espacios.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
            onPressed: cargando ? null : onEmpezar,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Empezar trabajo'),
          ),
          Text(
            '¿Ya acordaron el precio?',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}

/// Aviso que ocupa el ancho disponible, con un botón opcional a la derecha.
class _ConBoton extends StatelessWidget {
  const _ConBoton({required this.aviso, this.boton});

  final Widget aviso;
  final Widget? boton;

  @override
  Widget build(BuildContext context) {
    final boton = this.boton;
    if (boton == null) return aviso;
    return Row(
      children: [
        Expanded(child: aviso),
        const SizedBox(width: Espacios.s),
        boton,
      ],
    );
  }
}
/// Formulario del técnico: el precio de referencia queda fijo; el precio de
/// la visita empieza igual y se puede cambiar; la fecha y hora es obligatoria.
Future<NuevaTarifa?> mostrarFormularioTarifa(
  BuildContext context, {
  required double precioBase,
}) {
  return showDialog<NuevaTarifa>(
    context: context,
    builder: (context) => _FormularioTarifa(precioBase: precioBase),
  );
}

class _FormularioTarifa extends StatefulWidget {
  const _FormularioTarifa({required this.precioBase});

  final double precioBase;

  @override
  State<_FormularioTarifa> createState() => _FormularioTarifaState();
}

class _FormularioTarifaState extends State<_FormularioTarifa> {
  final _formKey = GlobalKey<FormState>();
  late final _precio = TextEditingController(
    text: widget.precioBase.toStringAsFixed(2),
  );
  DateTime? _fecha;

  @override
  void dispose() {
    _precio.dispose();
    super.dispose();
  }

  static double? _leer(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  String? _validarPrecio(String? valor) {
    final error = FormValidators.monto(valor, campo: 'El precio de la visita');
    if (error != null) return error;
    return (_leer(_precio) ?? 0) <= 0
        ? 'El precio de la visita debe ser mayor que 0.'
        : null;
  }

  Future<void> _elegirFecha() async {
    final hoy = DateUtils.dateOnly(DateTime.now());
    final dia = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 90)),
      helpText: 'Fecha de la visita',
    );
    if (dia == null || !mounted) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: _fecha == null
          ? const TimeOfDay(hour: 9, minute: 0)
          : TimeOfDay.fromDateTime(_fecha!),
      helpText: 'Hora de la visita',
    );
    if (hora == null || !mounted) return;
    setState(
      () => _fecha = DateTime(
        dia.year,
        dia.month,
        dia.day,
        hora.hour,
        hora.minute,
      ),
    );
  }

  void _enviar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_fecha == null) {
      context.mostrarMensaje(
        'Elige la fecha de la visita.',
        tipo: TipoMensaje.error,
      );
      return;
    }
    if (!_fecha!.isAfter(DateTime.now())) {
      context.mostrarMensaje(
        'Elige una fecha y hora futuras.',
        tipo: TipoMensaje.error,
      );
      return;
    }
    Navigator.pop<NuevaTarifa>(
      context,
      NuevaTarifa(precioAcordado: _leer(_precio)!, fechaServicio: _fecha),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final fecha = _fecha;
    return AlertDialog(
      icon: const Icon(Icons.receipt_long_outlined),
      title: const Text('Agendar visita'),
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
                        'Tu precio de la visita (referencia)',
                        style: textos.bodyMedium?.copyWith(
                          color: Colores.tintaSuave,
                        ),
                      ),
                    ),
                    Text(
                      Formatos.dinero(widget.precioBase),
                      style: textos.titleSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Espacios.l),
              CampoEtiquetado(
                etiqueta: 'Precio de la visita',
                ayuda: 'USD',
                child: TextFormField(
                  controller: _precio,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: _validarPrecio,
                ),
              ),
              const SizedBox(height: Espacios.s),
              Text(
                'El trabajo en sí lo acuerdan directamente con el cliente.',
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
              const SizedBox(height: Espacios.l),
              CampoEtiquetado(
                etiqueta: 'Fecha y hora de la visita',
                ayuda: 'Obligatoria',
                child: OutlinedButton.icon(
                  onPressed: _elegirFecha,
                  icon: const Icon(Icons.event_outlined),
                  label: Text(
                    fecha == null
                        ? 'Elegir fecha y hora'
                        : '${Formatos.fechaCorta(fecha)} · ${Formatos.hora(fecha)}',
                  ),
                ),
              ),
              const SizedBox(height: Espacios.m),
              const AvisoBanner(
                compacto: true,
                mensaje: 'El cliente debe confirmar el ticket para agendar.',
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
          child: const Text('Enviar ticket'),
        ),
      ],
    );
  }
}