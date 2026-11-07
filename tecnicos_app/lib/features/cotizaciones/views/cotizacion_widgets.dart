// Tarjeta de una cotización con sus montos y acciones opcionales.
import 'package:flutter/material.dart';

import '../../../core/utils/formatos.dart';
import '../../../core/validators/form_validators.dart';
import '../models/cotizacion.dart';


class CotizacionCard extends StatelessWidget {
  const CotizacionCard({
    super.key,
    required this.cotizacion,
    this.onAceptar,
    this.onChat,
  });

  final Cotizacion cotizacion;
  final VoidCallback? onAceptar;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final c = cotizacion;
    final detalle = c.detalle;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.tecnicoNombre, style: textos.titleMedium)),
                const Icon(Icons.star, size: 18, color: Colors.amber),
                Text(' ${c.tecnicoCalificacion.toStringAsFixed(1)}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Mano de obra: ${Formatos.dinero(c.manoObra)}'),
            Text('Materiales: ${Formatos.dinero(c.materiales)}'),
            Text('Total: ${Formatos.dinero(c.total)}', style: textos.titleSmall),
            if (detalle != null && detalle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(detalle),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(_etiqueta(c.estado))),
                const Spacer(),
                if (onChat != null)
                  TextButton.icon(
                    onPressed: onChat,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                  ),
                if (onAceptar != null)
                  FilledButton(
                    onPressed: onAceptar,
                    child: const Text('Aceptar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _etiqueta(EstadoCotizacion estado) => switch (estado) {
        EstadoCotizacion.pendiente => 'Pendiente',
        EstadoCotizacion.aceptada => 'Aceptada',
        EstadoCotizacion.rechazada => 'Rechazada',
      };
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
    const teclado = TextInputType.numberWithOptions(decimal: true);
    return AlertDialog(
      title: const Text('Enviar cotización'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _manoObra,
                keyboardType: teclado,
                decoration: const InputDecoration(
                  labelText: 'Mano de obra (USD)',
                  prefixText: '\$ ',
                ),
                validator: (v) => FormValidators.monto(v, campo: 'La mano de obra'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _materiales,
                keyboardType: teclado,
                decoration: const InputDecoration(
                  labelText: 'Materiales (USD)',
                  prefixText: '\$ ',
                ),
                validator: (v) => FormValidators.monto(v, campo: 'Materiales'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detalle,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Detalle (opcional)',
                  hintText: 'Qué incluye, tiempo estimado...',
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
        FilledButton(onPressed: _enviar, child: const Text('Enviar')),
      ],
    );
  }
}
