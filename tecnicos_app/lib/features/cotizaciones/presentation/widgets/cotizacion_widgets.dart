// Tarjeta de una cotización con sus montos y acciones opcionales, y el
// formulario para enviar una.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/cotizacion.dart';

extension EstadoCotizacionVista on EstadoCotizacion {
  String get etiqueta => switch (this) {
    EstadoCotizacion.pendiente => 'Pendiente',
    EstadoCotizacion.aceptada => 'Aceptada',
    EstadoCotizacion.rechazada => 'Rechazada',
  };

  /// Mismo criterio que los estados de solicitud: acento solo para lo positivo.
  Color get color => switch (this) {
    EstadoCotizacion.pendiente => Colores.info,
    EstadoCotizacion.aceptada => Colores.acento,
    EstadoCotizacion.rechazada => Colores.tintaSuave,
  };
}

class CotizacionCard extends StatelessWidget {
  const CotizacionCard({
    super.key,
    required this.cotizacion,
    this.onAceptar,
    this.onChat,
    this.accionesActivas = true,
    this.destacada = false,
  });

  final Cotizacion cotizacion;

  /// Si es null, no se muestra el botón.
  final VoidCallback? onAceptar;
  final VoidCallback? onChat;

  /// En false, los botones se ven pero desactivados (hay una acción en curso).
  final bool accionesActivas;

  /// Borde de acento para la cotización aceptada.
  final bool destacada;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final c = cotizacion;
    final detalle = c.detalle;
    final hayAcciones = onChat != null || onAceptar != null;
    return TarjetaApp(
      margin: const EdgeInsets.only(bottom: Espacios.m),
      colorBorde: destacada ? Colores.acento : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Tecnico(cotizacion: c),
          const SizedBox(height: Espacios.l),
          _FilaMonto(etiqueta: 'Mano de obra', valor: c.manoObra),
          const SizedBox(height: Espacios.xs),
          _FilaMonto(etiqueta: 'Materiales', valor: c.materiales),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Espacios.m),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Total', style: textos.titleMedium),
              const Spacer(),
              Text(Formatos.dinero(c.total), style: textos.headlineSmall),
            ],
          ),
          if (detalle != null && detalle.isNotEmpty) ...[
            const SizedBox(height: Espacios.m),
            Text(
              detalle,
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
          ],
          if (hayAcciones) ...[
            const SizedBox(height: Espacios.l),
            Row(
              children: [
                if (onChat != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: accionesActivas ? onChat : null,
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Chat'),
                    ),
                  ),
                if (onChat != null && onAceptar != null)
                  const SizedBox(width: Espacios.s),
                if (onAceptar != null)
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: accionesActivas ? onAceptar : null,
                      child: const Text('Aceptar'),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Inicial, nombre y calificación del técnico, con el estado a la derecha.
class _Tecnico extends StatelessWidget {
  const _Tecnico({required this.cotizacion});

  final Cotizacion cotizacion;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final c = cotizacion;
    final nombre = c.tecnicoNombre.trim();
    final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();
    final esNuevo = c.tecnicoCalificacion <= 0;
    return Row(
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
                  Text(
                    // Sin reseñas todavía: "0.0" parecería una mala nota.
                    esNuevo
                        ? 'Técnico nuevo'
                        : c.tecnicoCalificacion.toStringAsFixed(1),
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
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
  }
}

class _FilaMonto extends StatelessWidget {
  const _FilaMonto({required this.etiqueta, required this.valor});

  final String etiqueta;
  final double valor;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            etiqueta,
            style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
          ),
        ),
        const SizedBox(width: Espacios.s),
        Text(Formatos.dinero(valor), style: textos.bodyMedium),
      ],
    );
  }
}

typedef DatosCotizacion = ({
  double manoObra,
  double materiales,
  String? detalle,
});

Future<DatosCotizacion?> mostrarFormularioCotizacion(BuildContext context) {
  return showDialog<DatosCotizacion>(
    context: context,
    builder: (context) => const _FormularioCotizacion(),
  );
}

class _FormularioCotizacion extends StatefulWidget {
  const _FormularioCotizacion();

  @override
  State<_FormularioCotizacion> createState() => _FormularioCotizacionState();
}

class _FormularioCotizacionState extends State<_FormularioCotizacion> {
  final _formKey = GlobalKey<FormState>();
  final _manoObra = TextEditingController();
  final _materiales = TextEditingController(text: '0');
  final _detalle = TextEditingController();

  @override
  void dispose() {
    _manoObra.dispose();
    _materiales.dispose();
    _detalle.dispose();
    super.dispose();
  }

  double _leer(TextEditingController c) =>
      double.parse(c.text.trim().replaceAll(',', '.'));

  /// Para el total en vivo: lo que no es número cuenta como 0.
  double _leerOCero(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;

  void _enviar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final detalle = _detalle.text.trim();
    Navigator.pop<DatosCotizacion>(context, (
      manoObra: _leer(_manoObra),
      materiales: _leer(_materiales),
      detalle: detalle.isEmpty ? null : detalle,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    const teclado = TextInputType.numberWithOptions(decimal: true);
    return AlertDialog(
      icon: const Icon(Icons.request_quote_outlined),
      title: const Text('Enviar cotización'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CampoEtiquetado(
                etiqueta: 'Mano de obra',
                ayuda: 'USD',
                child: TextFormField(
                  controller: _manoObra,
                  keyboardType: teclado,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (v) =>
                      FormValidators.monto(v, campo: 'La mano de obra'),
                ),
              ),
              const SizedBox(height: Espacios.l),
              CampoEtiquetado(
                etiqueta: 'Materiales',
                ayuda: 'USD',
                child: TextFormField(
                  controller: _materiales,
                  keyboardType: teclado,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (v) =>
                      FormValidators.monto(v, campo: 'Materiales'),
                ),
              ),
              const SizedBox(height: Espacios.l),
              CampoEtiquetado(
                etiqueta: 'Detalle',
                ayuda: 'Opcional',
                child: TextFormField(
                  controller: _detalle,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Qué incluye, tiempo estimado...',
                  ),
                ),
              ),
              const SizedBox(height: Espacios.l),
              // Total que ve el cliente, recalculado mientras se escribe.
              ListenableBuilder(
                listenable: Listenable.merge([_manoObra, _materiales]),
                builder: (context, _) => Container(
                  padding: const EdgeInsets.all(Espacios.m + 2),
                  decoration: BoxDecoration(
                    color: Colores.primarioSuave,
                    borderRadius: BorderRadius.circular(Radios.medio),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Total',
                        style: textos.titleMedium?.copyWith(
                          color: Colores.primarioOscuro,
                        ),
                      ),
                      const SizedBox(width: Espacios.s),
                      // En diálogos angostos, el monto se achica en vez de
                      // desbordarse.
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            Formatos.dinero(
                              _leerOCero(_manoObra) + _leerOCero(_materiales),
                            ),
                            style: textos.titleLarge?.copyWith(
                              color: Colores.primarioOscuro,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
