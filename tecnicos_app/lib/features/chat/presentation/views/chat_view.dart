// Chat en tiempo real entre cliente y técnico.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
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
  static const double _anchoMaximo = 720;

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
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final miId = ref.watch(usuarioActualProvider)?.id;
    final mensajes = ref.watch(mensajesProvider(widget.conversacionId));
    final enviando = ref
        .watch(enviarMensajeProvider(widget.conversacionId))
        .isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: AnchoMaximo(
              ancho: _anchoMaximo,
              child: AsyncValueView<List<Mensaje>>(
                value: mensajes,
                onRetry: () =>
                    ref.invalidate(mensajesProvider(widget.conversacionId)),
                onData: (context, mensajes) => mensajes.isEmpty
                    ? const EstadoMensaje(
                        icono: Icons.chat_bubble_outline,
                        titulo: 'Inicia la conversación',
                        mensaje:
                            'Pregunta lo que necesites o coordina la '
                            'visita.',
                      )
                    : _Mensajes(mensajes: mensajes, miId: miId),
              ),
            ),
          ),
          _BarraEnvio(
            controller: _texto,
            enviando: enviando,
            onEnviar: _enviar,
            anchoMaximo: _anchoMaximo,
          ),
        ],
      ),
    );
  }
}

/// Lista de mensajes, el más nuevo abajo, con separadores por día.
class _Mensajes extends StatelessWidget {
  const _Mensajes({required this.mensajes, required this.miId});

  final List<Mensaje> mensajes;
  final String? miId;

  @override
  Widget build(BuildContext context) {
    // Se arma en orden cronológico y se muestra invertido (reverse: true)
    // para que el más nuevo quede junto al campo de texto.
    final elementos = <Widget>[];
    String? diaAnterior;
    for (final m in mensajes) {
      final dia = Formatos.dia(m.enviadoEn);
      if (dia != diaAnterior) {
        elementos.add(_SeparadorDia(dia));
        diaAnterior = dia;
      }
      elementos.add(_Burbuja(mensaje: m, esMio: m.autorId == miId));
    }
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(Espacios.m),
      itemCount: elementos.length,
      itemBuilder: (context, i) => elementos[elementos.length - 1 - i],
    );
  }
}

class _SeparadorDia extends StatelessWidget {
  const _SeparadorDia(this.dia);

  final String dia;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.m),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.m,
            vertical: Espacios.xs,
          ),
          decoration: BoxDecoration(
            color: Colores.superficieFuerte,
            borderRadius: BorderRadius.circular(Radios.pildora),
          ),
          child: Text(
            dia,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Colores.tinta),
          ),
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
    final textos = Theme.of(context).textTheme;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    const radio = Radius.circular(Radios.grande);
    const esquina = Radius.circular(Espacios.xs);
    // Mis mensajes en azul; los del otro en blanco. La esquina recortada
    // apunta hacia quien escribió.
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Espacios.xs - 1),
        padding: const EdgeInsets.fromLTRB(
          Espacios.m + 2,
          Espacios.s + 2,
          Espacios.m + 2,
          Espacios.s,
        ),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: esMio ? Colores.primario : Colores.tarjeta,
          boxShadow: esMio ? null : Sombras.suave,
          borderRadius: BorderRadius.only(
            topLeft: radio,
            topRight: radio,
            bottomLeft: esMio ? radio : esquina,
            bottomRight: esMio ? esquina : radio,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              mensaje.contenido,
              style: textos.bodyMedium?.copyWith(
                color: esMio ? blanco : Colores.tinta,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatos.hora(mensaje.enviadoEn),
              style: textos.labelSmall?.copyWith(
                color: esMio
                    ? blanco.withValues(alpha: 0.85)
                    : Colores.tintaSuave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra blanca inferior: campo redondeado y botón azul de enviar.
class _BarraEnvio extends StatelessWidget {
  const _BarraEnvio({
    required this.controller,
    required this.enviando,
    required this.onEnviar,
    required this.anchoMaximo,
  });

  final TextEditingController controller;
  final bool enviando;
  final VoidCallback onEnviar;
  final double anchoMaximo;

  @override
  Widget build(BuildContext context) {
    final redondeado = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radios.pildora),
      borderSide: BorderSide.none,
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colores.tarjeta,
        border: Border(top: BorderSide(color: Colores.linea)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Espacios.s + 2),
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: anchoMaximo),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onEnviar(),
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Espacios.l + 4,
                          vertical: Espacios.m,
                        ),
                        border: redondeado,
                        enabledBorder: redondeado,
                        focusedBorder: redondeado.copyWith(
                          borderSide: const BorderSide(
                            color: Colores.primario,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Espacios.s),
                  IconButton.filled(
                    tooltip: 'Enviar',
                    iconSize: 22,
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(48),
                    ),
                    onPressed: enviando ? null : onEnviar,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
