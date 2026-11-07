// Implementa verificacion_view para la aplicación.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/media/selector_fotos.dart';
import '../../../core/widgets/mensajes.dart';
import '../../../core/widgets/seccion.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../models/documento_tecnico.dart';
import '../viewmodels/verificacion_view_model.dart';

extension TipoDocumentoVista on TipoDocumento {
  String get titulo => switch (this) {
        TipoDocumento.cedulaFrontal => 'Cédula · anverso',
        TipoDocumento.cedulaPosterior => 'Cédula · reverso',
        TipoDocumento.selfie => 'Selfie con tu cédula',
      };

  String get ayuda => switch (this) {
        TipoDocumento.cedulaFrontal =>
          'Parte delantera, con foto y número legibles.',
        TipoDocumento.cedulaPosterior => 'Parte trasera, completa y sin reflejos.',
        TipoDocumento.selfie =>
          'Tu rostro junto a la cédula, para comprobar que eres tú.',
      };

  IconData get icono => switch (this) {
        TipoDocumento.cedulaFrontal => Icons.badge_outlined,
        TipoDocumento.cedulaPosterior => Icons.flip_outlined,
        TipoDocumento.selfie => Icons.face_retouching_natural,
      };
}

class VerificacionView extends StatefulWidget {
  const VerificacionView({super.key, required this.crearViewModel});

  final VerificacionViewModel Function() crearViewModel;

  @override
  State<VerificacionView> createState() => _VerificacionViewState();
}

class _VerificacionViewState extends State<VerificacionView> {
  late final VerificacionViewModel _vm = widget.crearViewModel();

  @override
  void initState() {
    super.initState();
    _vm.cargar();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _subir(TipoDocumento tipo) async {
    final camara = kIsWeb ? false : await _elegirOrigen();
    if (camara == null) return;
    final Uint8List? bytes = await SelectorFotos.una(camara: camara);
    if (bytes == null) return;
    final error = await _vm.subir(tipo, bytes);
    if (mounted) {
      context.mostrarMensaje(error ?? '${tipo.titulo}: enviado para revisión.');
    }
  }

  Future<bool?> _elegirOrigen() {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context, true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar identidad')),
      body: ViewStateBuilder<Verificacion>(
        listenable: _vm,
        onRetry: _vm.cargar,
        onLoaded: (context, verificacion) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AnchoMaximo(
              ancho: 720,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    verificacion.todoEnviado
                        ? 'Tus documentos están en revisión. Te avisaremos '
                            'cuando tu cuenta quede verificada.'
                        : 'Para que los clientes confíen en ti, sube estas '
                            'tres fotos. Solo las verá el equipo de revisión.',
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _vm.procesando,
                    builder: (context, subiendo, _) => subiendo
                        ? const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: LinearProgressIndicator(),
                          )
                        : const SizedBox(height: 12),
                  ),
                  for (final tipo in TipoDocumento.values)
                    _TarjetaDocumento(
                      tipo: tipo,
                      documento: verificacion.documentos[tipo],
                      onSubir: verificacion.puedeSubir(tipo)
                          ? () => _subir(tipo)
                          : null,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaDocumento extends StatelessWidget {
  const _TarjetaDocumento({
    required this.tipo,
    required this.documento,
    required this.onSubir,
  });

  final TipoDocumento tipo;
  final DocumentoTecnico? documento;
  final VoidCallback? onSubir;

  @override
  Widget build(BuildContext context) {
    final doc = documento;
    final url = doc?.url;
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: url == null
                    ? ColoredBox(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(tipo.icono, size: 32),
                      )
                    : Image.network(url, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tipo.titulo, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(tipo.ayuda, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  _EstadoDocumento(estado: doc?.estado),
                ],
              ),
            ),
            if (onSubir != null)
              FilledButton.tonal(
                onPressed: onSubir,
                child: Text(doc == null ? 'Subir' : 'Reenviar'),
              ),
          ],
        ),
      ),
    );
  }
}

class _EstadoDocumento extends StatelessWidget {
  const _EstadoDocumento({required this.estado});

  final EstadoDocumento? estado;

  @override
  Widget build(BuildContext context) {
    final (texto, color) = switch (estado) {
      null => ('Sin enviar', Theme.of(context).colorScheme.outline),
      EstadoDocumento.pendiente => ('En revisión', Colors.orange.shade700),
      EstadoDocumento.aprobada => ('Aprobado', Colors.green.shade700),
      EstadoDocumento.rechazada => ('Rechazado: vuelve a enviarlo', Colors.red.shade700),
    };
    return Text(texto, style: TextStyle(color: color, fontWeight: FontWeight.w600));
  }
}