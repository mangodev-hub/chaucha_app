// Chat en tiempo real entre cliente y técnico.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_vacio.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/mensaje.dart';
import '../providers/enviar_mensaje_provider.dart';
import '../providers/mensajes_provider.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key, required this.conversacionId});

  final String conversacionId;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final envio = enviarMensajeProvider(widget.conversacionId);
    final texto = _texto.text;
    if (texto.trim().isEmpty || ref.read(envio).isLoading) return;

    _texto.clear();
    final enviado = await ref.read(envio.notifier).enviar(texto);
    if (enviado || !mounted) return;

    _texto.text = texto; // Se devuelve el texto para no perderlo.
    if (ref.read(envio) case AsyncError(:final error)) {
      context.mostrarMensaje(AsyncValueView.mensajeDe(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final miId = ref.watch(usuarioActualProvider)?.id;
    final mensajes = ref.watch(mensajesProvider(widget.conversacionId));
    final enviando =
        ref.watch(enviarMensajeProvider(widget.conversacionId)).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: AnchoMaximo(
        ancho: 720,
        child: Column(
          children: [
            Expanded(
              child: AsyncValueView<List<Mensaje>>(
                value: mensajes,
                onRetry: () =>
                    ref.invalidate(mensajesProvider(widget.conversacionId)),
                onData: (context, mensajes) => mensajes.isEmpty
                    ? const EstadoVacio(
                        icono: Icons.chat_bubble_outline,
                        mensaje: 'Escribe el primer mensaje.',
                      )
                    : ListView.builder(
                        reverse: true, // El más nuevo abajo, junto al campo.
                        padding: const EdgeInsets.all(12),
                        itemCount: mensajes.length,
                        itemBuilder: (context, i) {
                          final m = mensajes[mensajes.length - 1 - i];
                          return _Burbuja(mensaje: m, esMio: m.autorId == miId);
                        },
                      ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _texto,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _enviar(),
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: enviando ? null : _enviar,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({required this.mensaje, required this.esMio});

  final Mensaje mensaje;
  final bool esMio;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: esMio ? colores.primaryContainer : colores.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(mensaje.contenido),
            const SizedBox(height: 2),
            Text(
              Formatos.hora(mensaje.enviadoEn),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
