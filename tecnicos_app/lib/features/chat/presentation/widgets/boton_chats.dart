import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../notificaciones/presentation/widgets/punto_no_leidas.dart';
import '../../domain/entities/resumen_chat.dart';
import '../providers/mis_chats_provider.dart';
import 'chat_flotante.dart';

class BotonChats extends StatelessWidget {
  const BotonChats({super.key, required this.esCliente});

  final bool esCliente;

  void _perfil(BuildContext context, String id) {
    unawaited(
      context.push(
        esCliente ? AppRoutes.perfilTecnico(id) : AppRoutes.perfilCliente(id),
      ),
    );
  }

  void _abrir(BuildContext context) {
    if (!ResponsiveLayout.isDesktop(context)) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheet) => _ListaChats(
          onAbrir: (id) {
            Navigator.pop(sheet);
            abrirChat(context, id, esCliente: esCliente);
          },
          onVerPerfil: (id) {
            Navigator.pop(sheet);
            _perfil(context, id);
          },
        ),
      );
      return;
    }

    late final OverlayEntry entrada;
    void cerrar() => entrada.remove();

    entrada = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: cerrar,
            ),
          ),
          Positioned(
            right: Espacios.l,
            bottom: 88,
            child: Material(
              elevation: 10,
              color: Colores.tarjeta,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(Radios.grande),
              child: SizedBox(
                width: 360,
                height: 480,
                child: _ListaChats(
                  onAbrir: (id) {
                    cerrar();
                    if (context.mounted) {
                      abrirChat(context, id, esCliente: esCliente);
                    }
                  },
                  onVerPerfil: (id) {
                    cerrar();
                    if (context.mounted) _perfil(context, id);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entrada);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Mensajes',
      onPressed: () => _abrir(context),
      child: const PuntoNoLeidas(
        tipos: ['mensaje', 'chat'],
        child: Icon(Icons.chat_bubble_rounded),
      ),
    );
  }
}

class _ListaChats extends ConsumerWidget {
  const _ListaChats({required this.onAbrir, required this.onVerPerfil});

  final ValueChanged<String> onAbrir;
  final ValueChanged<String> onVerPerfil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Espacios.l),
            child: Text('Mensajes', style: textos.titleLarge),
          ),
          Expanded(
            child: AsyncValueView<List<ResumenChat>>(
              value: ref.watch(misChatsProvider),
              onRetry: () => ref.invalidate(misChatsProvider),
              onData: (context, chats) => chats.isEmpty
                  ? const EstadoMensaje(
                      icono: Icons.chat_bubble_outline,
                      titulo: 'Sin conversaciones',
                      mensaje:
                          'Cuando escribas o te escriban, '
                          'los chats aparecerán aquí.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: Espacios.xl),
                      itemCount: chats.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) => _FilaChat(
                        chat: chats[i],
                        onTap: () => onAbrir(chats[i].conversacionId),
                        onVerPerfil: chats[i].otroId.isEmpty
                            ? null
                            : () => onVerPerfil(chats[i].otroId),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaChat extends StatelessWidget {
  const _FilaChat({
    required this.chat,
    required this.onTap,
    this.onVerPerfil,
  });

  final ResumenChat chat;
  final VoidCallback onTap;
  final VoidCallback? onVerPerfil;

  @override
  Widget build(BuildContext context) {
    final fecha = chat.enviadoEn;
    final oficio = chat.oficio;
    final ultimo = chat.ultimoMensaje;
    final vista = ultimo == null
        ? 'Sin mensajes todavía'
        : '${chat.esMio ? 'Tú: ' : ''}$ultimo';
    return ListTile(
      onTap: onTap,
      leading: Tooltip(
        message: 'Ver perfil',
        child: InkResponse(
          onTap: onVerPerfil,
          radius: 26,
          child: CircleAvatar(
            backgroundColor: Colores.primarioSuave,
            foregroundColor: Colores.primario,
            child: Text(chat.otroNombre.characters.first.toUpperCase()),
          ),
        ),
      ),
      title: Text(
        chat.otroNombre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        oficio == null ? vista : '$oficio · $vista',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: fecha == null
          ? null
          : Text(
              Formatos.dia(fecha) == 'Hoy'
                  ? Formatos.hora(fecha)
                  : Formatos.dia(fecha),
              style: Theme.of(context).textTheme.labelSmall,
            ),
    );
  }
}
