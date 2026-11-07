// Chat en tiempo real entre cliente y técnico.
import 'package:flutter/material.dart';

import '../../../core/utils/formatos.dart';
import '../../../core/widgets/estado_vacio.dart';
import '../../../core/widgets/mensajes.dart';
import '../../../core/widgets/seccion.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../models/mensaje.dart';
import '../viewmodels/chat_view_model.dart';


class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.crearViewModel});

  final ChatViewModel Function() crearViewModel;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final ChatViewModel _vm = widget.crearViewModel();
  final _texto = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm.iniciar();
  }

  @override
  void dispose() {
    _vm.dispose(); 
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final texto = _texto.text;
    if (texto.trim().isEmpty) return;
    _texto.clear();
    final error = await _vm.enviar(texto);
    if (error != null && mounted) {
      _texto.text = texto; 
      context.mostrarMensaje(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: AnchoMaximo(
        ancho: 720,
        child: Column(
          children: [
            Expanded(
              child: ViewStateBuilder<List<Mensaje>>(
                listenable: _vm,
                onLoaded: (context, mensajes) => mensajes.isEmpty
                    ? const EstadoVacio(
                        icono: Icons.chat_bubble_outline,
                        mensaje: 'Escribe el primer mensaje.',
                      )
                    : ListView.builder(
                        reverse: true, 
                        padding: const EdgeInsets.all(12),
                        itemCount: mensajes.length,
                        itemBuilder: (context, i) {
                          final m = mensajes[mensajes.length - 1 - i];
                          return _Burbuja(mensaje: m, esMio: _vm.esMio(m));
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
                    ValueListenableBuilder<bool>(
                      valueListenable: _vm.procesando,
                      builder: (context, enviando, _) => IconButton.filled(
                        onPressed: enviando ? null : _enviar,
                        icon: const Icon(Icons.send),
                      ),
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
