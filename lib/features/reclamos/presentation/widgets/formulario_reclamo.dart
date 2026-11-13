// "Reportar un problema": diálogo en pantallas anchas y hoja inferior en el
// teléfono. Al enviar muestra la confirmación con el código del reclamo.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../domain/entities/reclamo.dart';
import '../providers/reclamos_provider.dart';

const int _minimoCaracteres = 20;
const int _maximoFotos = 3;

/// Abre el formulario y, si se envía, la confirmación. Desde ahí lleva al
/// reclamo o al inicio.
Future<void> reportarProblema(
  BuildContext context, {
  required String solicitudId,
  required bool esCliente,
}) async {
  final ancho = MediaQuery.sizeOf(context).width >= 700;
  final formulario = _FormularioReclamo(
    solicitudId: solicitudId,
    esCliente: esCliente,
  );
  final reclamo = ancho
      ? await showDialog<Reclamo>(
          context: context,
          builder: (_) => Dialog(
            insetPadding: const EdgeInsets.all(Espacios.l),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: formulario,
            ),
          ),
        )
      : await showModalBottomSheet<Reclamo>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => formulario,
        );
  if (reclamo == null || !context.mounted) return;

  final verReclamo = await showDialog<bool>(
    context: context,
    builder: (_) => ConfirmacionReclamo(reclamo: reclamo),
  );
  if (!context.mounted) return;
  if (verReclamo == true) {
    unawaited(
      context.push(AppRoutes.reclamo(reclamo.id, esCliente: esCliente)),
    );
  } else if (verReclamo == false) {
    context.go(esCliente ? AppRoutes.clienteInicio : AppRoutes.tecnicoInicio);
  }
}

class _FormularioReclamo extends ConsumerStatefulWidget {
  const _FormularioReclamo({
    required this.solicitudId,
    required this.esCliente,
  });

  final String solicitudId;
  final bool esCliente;

  @override
  ConsumerState<_FormularioReclamo> createState() => _FormularioReclamoState();
}

class _FormularioReclamoState extends ConsumerState<_FormularioReclamo> {
  final _texto = TextEditingController();
  final _fotos = <Uint8List>[];
  CategoriaReclamo? _categoria;

  @override
  void initState() {
    super.initState();
    _texto.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  bool get _valido =>
      _categoria != null && _texto.text.trim().length >= _minimoCaracteres;

  Future<void> _agregarFotos() async {
    final nuevas = await SelectorFotos.elegir(
      maximo: _maximoFotos - _fotos.length,
    );
    if (!mounted || nuevas.isEmpty) return;
    setState(() => _fotos.addAll(nuevas.take(_maximoFotos - _fotos.length)));
  }

  Future<void> _enviar() async {
    final categoria = _categoria;
    if (categoria == null) return;
    final notifier = ref.read(crearReclamoProvider.notifier);
    final reclamo = await notifier.enviar(
      solicitudId: widget.solicitudId,
      categoria: categoria,
      descripcion: _texto.text,
      fotos: List.of(_fotos),
    );
    if (!mounted) return;
    if (reclamo != null) {
      Navigator.of(context).pop(reclamo);
      return;
    }
    if (ref.read(crearReclamoProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final enviando = ref.watch(crearReclamoProvider).isLoading;
    final largo = _texto.text.trim().length;
    final faltan = _minimoCaracteres - largo;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Espacios.xl,
          Espacios.l,
          Espacios.xl,
          Espacios.xl + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Reportar un problema', style: textos.titleLarge),
            const SizedBox(height: Espacios.xs),
            Text(
              'Un asesor de ChauchaApp revisará tu caso. La otra persona no '
              've tu reclamo.',
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
            const SizedBox(height: Espacios.l),
            Text('¿Qué pasó?', style: textos.titleSmall),
            const SizedBox(height: Espacios.s),
            Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.s,
              children: [
                for (final c in CategoriaReclamo.para(
                  esCliente: widget.esCliente,
                ))
                  ChoiceChip(
                    label: Text(c.etiqueta),
                    selected: _categoria == c,
                    onSelected: enviando
                        ? null
                        : (_) => setState(() => _categoria = c),
                  ),
              ],
            ),
            const SizedBox(height: Espacios.l),
            TextField(
              controller: _texto,
              enabled: !enviando,
              minLines: 4,
              maxLines: 8,
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Cuéntanos qué pasó',
                alignLabelWithHint: true,
                helperText: faltan > 0
                    ? 'Escribe al menos $faltan caracteres más.'
                    : null,
              ),
            ),
            const SizedBox(height: Espacios.m),
            Text(
              'Fotos (opcional, hasta $_maximoFotos)',
              style: textos.titleSmall,
            ),
            const SizedBox(height: Espacios.s),
            Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.s,
              children: [
                for (var i = 0; i < _fotos.length; i++)
                  _Miniatura(
                    bytes: _fotos[i],
                    onQuitar: enviando
                        ? null
                        : () => setState(() => _fotos.removeAt(i)),
                  ),
                if (_fotos.length < _maximoFotos)
                  _AgregarFoto(onTap: enviando ? null : _agregarFotos),
              ],
            ),
            const SizedBox(height: Espacios.xl),
            BotonCarga(
              texto: 'Enviar reclamo',
              icono: Icons.send_rounded,
              cargando: enviando,
              onPressed: _valido ? _enviar : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Miniatura extends StatelessWidget {
  const _Miniatura({required this.bytes, required this.onQuitar});

  final Uint8List bytes;
  final VoidCallback? onQuitar;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 80,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radios.pequeno),
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: Material(
              color: Colores.tinta.withValues(alpha: 0.7),
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Quitar foto',
                visualDensity: VisualDensity.compact,
                iconSize: 16,
                onPressed: onQuitar,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colores.sobreOscuro,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgregarFoto extends StatelessWidget {
  const _AgregarFoto({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borde = BorderRadius.circular(Radios.pequeno);
    return Semantics(
      button: true,
      label: 'Agregar foto',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: borde,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colores.superficie,
            borderRadius: borde,
            border: Border.all(color: Colores.linea),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: Colores.primario),
              SizedBox(height: 4),
              Text('Agregar', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmación tras enviar. Devuelve true para ver el reclamo y false
/// para volver al inicio.
class ConfirmacionReclamo extends StatelessWidget {
  const ConfirmacionReclamo({super.key, required this.reclamo});

  final Reclamo reclamo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radios.pequeno),
    );
    return Dialog(
      insetPadding: const EdgeInsets.all(Espacios.l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(Espacios.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Colores.primarioSuave,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  size: 44,
                  color: Colores.primarioVivo,
                ),
              ),
              const SizedBox(height: Espacios.l),
              Text(
                'Recibimos tu reclamo ${reclamo.codigo}',
                textAlign: TextAlign.center,
                style: textos.titleLarge,
              ),
              const SizedBox(height: Espacios.s),
              Text(
                'Un asesor de ChauchaApp lo está evaluando. Te escribiremos '
                'por aquí y te avisaremos con una notificación.',
                textAlign: TextAlign.center,
                style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
              ),
              const SizedBox(height: Espacios.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: forma,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Ver mi reclamo'),
                ),
              ),
              const SizedBox(height: Espacios.s),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: forma,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Volver al inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
