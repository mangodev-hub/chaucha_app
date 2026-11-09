import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../domain/entities/solicitud.dart';

typedef DatosEdicion = ({int oficioId, String descripcion, String? direccion});

Future<DatosEdicion?> mostrarEditarSolicitud(
  BuildContext context,
  Solicitud solicitud,
) => showDialog<DatosEdicion>(
  context: context,
  builder: (_) => _EditarDialog(solicitud: solicitud),
);

class _EditarDialog extends ConsumerStatefulWidget {
  const _EditarDialog({required this.solicitud});

  final Solicitud solicitud;

  @override
  ConsumerState<_EditarDialog> createState() => _EditarDialogState();
}

class _EditarDialogState extends ConsumerState<_EditarDialog> {
  final _form = GlobalKey<FormState>();
  late final _descripcion = TextEditingController(
    text: widget.solicitud.descripcion,
  );
  late final _direccion = TextEditingController(
    text: widget.solicitud.direccionReferencia ?? '',
  );
  late int _oficioId = widget.solicitud.oficioId;

  @override
  void dispose() {
    _descripcion.dispose();
    _direccion.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!(_form.currentState?.validate() ?? false)) return;
    final direccion = _direccion.text.trim();
    Navigator.pop(context, (
      oficioId: _oficioId,
      descripcion: _descripcion.text.trim(),
      direccion: direccion.isEmpty ? null : direccion,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final suave = textos.bodySmall?.copyWith(color: Colores.tintaSuave);
    return AlertDialog(
      title: const Text('Editar solicitud'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.solicitud.estado.oficioEditable)
                  ref.watch(oficiosProvider).when(
                        data: (lista) => DropdownButtonFormField<int>(
                          value: _oficioId,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de servicio',
                          ),
                          items: [
                            for (final o in lista)
                              DropdownMenuItem(
                                value: o.id,
                                child: Text(o.nombre),
                              ),
                          ],
                          onChanged: (v) =>
                              setState(() => _oficioId = v ?? _oficioId),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, s) => const SizedBox.shrink(),
                      )
                else
                  Text(
                    'El tipo de servicio no se puede cambiar porque ya hay '
                    'propuestas de técnicos.',
                    style: suave,
                  ),
                const SizedBox(height: Espacios.l),
                TextFormField(
                  controller: _descripcion,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: '¿Qué problema tienes?',
                  ),
                  validator: (v) => (v?.trim().length ?? 0) < 10
                      ? 'Describe el problema con al menos 10 caracteres.'
                      : null,
                ),
                const SizedBox(height: Espacios.l),
                TextFormField(
                  controller: _direccion,
                  decoration: const InputDecoration(
                    labelText: 'Referencia de la dirección (opcional)',
                  ),
                ),
                const SizedBox(height: Espacios.m),
                Text(
                  'Los técnicos que ya te enviaron una propuesta verán los '
                  'cambios.',
                  style: suave,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _guardar, child: const Text('Guardar cambios')),
      ],
    );
  }
}