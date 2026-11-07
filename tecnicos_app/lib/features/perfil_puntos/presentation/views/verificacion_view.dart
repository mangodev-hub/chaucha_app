// Pantalla "Verificar identidad": el técnico sube su cédula y una selfie.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/seccion.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';
import '../providers/verificacion_provider.dart';

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

class VerificacionView extends ConsumerStatefulWidget {
  const VerificacionView({super.key});

  @override
  ConsumerState<VerificacionView> createState() => _VerificacionViewState();
}

class _VerificacionViewState extends ConsumerState<VerificacionView> {
  Future<void> _subir(TipoDocumento tipo) async {
    final camara = kIsWeb ? false : await _elegirOrigen();
    if (camara == null) return;
    final Uint8List? bytes = await SelectorFotos.una(camara: camara);
    if (bytes == null || !mounted) return;
    final subido =
        await ref.read(subirDocumentoProvider.notifier).subir(tipo, bytes);
    if (!mounted) return;
    if (subido) {
      context.mostrarMensaje('${tipo.titulo}: enviado para revisión.');
    } else if (ref.read(subirDocumentoProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(AsyncValueView.mensajeDe(error));
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
    final subiendo = ref.watch(subirDocumentoProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Verificar identidad')),
      body: AsyncValueView<Verificacion>(
        value: ref.watch(verificacionProvider),
        onRetry: () => ref.invalidate(verificacionProvider),
        onData: (context, verificacion) => ListView(
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
                  if (subiendo)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: LinearProgressIndicator(),
                    )
                  else
                    const SizedBox(height: 12),
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
      EstadoDocumento.pendiente => ('En revisión', Colores.aviso),
      EstadoDocumento.aprobada => ('Aprobado', Colores.acento),
      EstadoDocumento.rechazada => ('Rechazado: vuelve a enviarlo', Colores.error),
    };
    return Text(texto, style: TextStyle(color: color, fontWeight: FontWeight.w600));
  }
}