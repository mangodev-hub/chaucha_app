import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/avatar_usuario.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/insignia_verificado.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';
import '../../domain/entities/resumen_chat.dart';
import '../providers/mis_chats_provider.dart';
import '../widgets/chat_flotante.dart';

/// Tipos de notificación que cuentan como mensajes sin leer de un chat.
const tiposDeChat = ['mensaje', 'chat'];

class ChatsView extends ConsumerStatefulWidget {
  const ChatsView({super.key, required this.esCliente});

  final bool esCliente;

  @override
  ConsumerState<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends ConsumerState<ChatsView> {
  static const double _anchoMaximo = 720;

  final _busqueda = TextEditingController();
  bool _soloSinLeer = false;

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  Future<void> _abrir(String conversacionId) async {
    await abrirChat(context, conversacionId, esCliente: widget.esCliente);
    if (!mounted) return;
    ref.invalidate(misChatsProvider);
  }

  void _verPerfil(String id) {
    unawaited(
      context.push(
        widget.esCliente
            ? AppRoutes.perfilTecnico(id)
            : AppRoutes.perfilCliente(id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final noLeidas =
        ref.watch(notificacionesNoLeidasProvider).value ?? const [];
    int sinLeerDe(String conversacionId) => noLeidas
        .where(
          (n) =>
              tiposDeChat.contains(n.tipo) && n.referenciaId == conversacionId,
        )
        .length;
    final totalSinLeer = noLeidas
        .where((n) => tiposDeChat.contains(n.tipo))
        .length;

    return ListaDePagina(
      onRefresh: () => esperarSinError(ref.refresh(misChatsProvider.future)),
      padding: const EdgeInsets.fromLTRB(
        Espacios.l,
        Espacios.l,
        Espacios.l,
        Espacios.xxl,
      ),
      children: [
        AnchoMaximo(
          ancho: _anchoMaximo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Chats', style: textos.titleLarge),
                  if (totalSinLeer > 0) ...[
                    const SizedBox(width: Espacios.s),
                    Pildora(
                      texto: '$totalSinLeer sin leer',
                      color: Colores.primario,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: Espacios.m),
              TextField(
                controller: _busqueda,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: widget.esCliente
                      ? 'Buscar técnico u oficio'
                      : 'Buscar cliente u oficio',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _busqueda.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Borrar búsqueda',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => setState(_busqueda.clear),
                        ),
                ),
              ),
              const SizedBox(height: Espacios.m),
              Wrap(
                spacing: Espacios.s,
                children: [
                  ChoiceChip(
                    label: const Text('Todos'),
                    selected: !_soloSinLeer,
                    onSelected: (_) => setState(() => _soloSinLeer = false),
                  ),
                  ChoiceChip(
                    label: const Text('Sin leer'),
                    selected: _soloSinLeer,
                    onSelected: (_) => setState(() => _soloSinLeer = true),
                  ),
                ],
              ),
              const SizedBox(height: Espacios.m),
              AsyncValueView<List<ResumenChat>>(
                value: ref.watch(misChatsProvider),
                onRetry: () => ref.invalidate(misChatsProvider),
                onData: (context, chats) => _lista(chats, sinLeerDe),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lista(List<ResumenChat> chats, int Function(String) sinLeerDe) {
    if (chats.isEmpty) {
      return EstadoMensaje(
        icono: Icons.chat_bubble_outline_rounded,
        titulo: 'Sin conversaciones',
        mensaje: widget.esCliente
            ? 'Cada chat nace de una solicitud. Pide un técnico y escríbele '
                  'desde su oferta.'
            : 'Cuando un cliente te escriba, su chat aparecerá aquí.',
      );
    }

    final consulta = _busqueda.text.trim().toLowerCase();
    bool coincide(ResumenChat c) =>
        consulta.isEmpty ||
        c.otroNombre.toLowerCase().contains(consulta) ||
        (c.oficio?.toLowerCase().contains(consulta) ?? false);
    final visibles = [
      for (final c in chats)
        if (coincide(c) && (!_soloSinLeer || sinLeerDe(c.conversacionId) > 0))
          c,
    ];

    if (visibles.isEmpty) {
      return EstadoMensaje(
        icono: _soloSinLeer
            ? Icons.mark_chat_read_outlined
            : Icons.search_off_rounded,
        compacto: true,
        mensaje: _soloSinLeer
            ? 'No tienes mensajes sin leer.'
            : 'Ningún chat coincide con "${_busqueda.text.trim()}".',
      );
    }

    return TarjetaApp(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radios.grande),
        child: Column(
          children: [
            for (var i = 0; i < visibles.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              _FilaChat(
                chat: visibles[i],
                sinLeer: sinLeerDe(visibles[i].conversacionId),
                onTap: () => _abrir(visibles[i].conversacionId),
                onVerPerfil: visibles[i].otroId.isEmpty
                    ? null
                    : () => _verPerfil(visibles[i].otroId),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilaChat extends StatelessWidget {
  const _FilaChat({
    required this.chat,
    required this.sinLeer,
    required this.onTap,
    this.onVerPerfil,
  });

  final ResumenChat chat;
  final int sinLeer;
  final VoidCallback onTap;
  final VoidCallback? onVerPerfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final fecha = chat.enviadoEn;
    final oficio = chat.oficio;
    final ultimo = chat.ultimoMensaje;
    final conNuevos = sinLeer > 0;
    final vista = ultimo == null
        ? 'Sin mensajes todavía'
        : '${chat.esMio ? 'Tú: ' : ''}$ultimo';
    final cuando = fecha == null
        ? null
        : Formatos.dia(fecha) == 'Hoy'
        ? Formatos.hora(fecha)
        : Formatos.dia(fecha);

    return Semantics(
      button: true,
      label: conNuevos
          ? '${chat.otroNombre}, $sinLeer sin leer'
          : chat.otroNombre,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.l,
            vertical: Espacios.m,
          ),
          child: Row(
            children: [
              Tooltip(
                message: onVerPerfil == null ? '' : 'Ver perfil',
                child: InkResponse(
                  onTap: onVerPerfil,
                  radius: 28,
                  child: ConIconoVerificado(
                    verificado: chat.otroVerificado,
                    tamano: 16,
                    hijo: AvatarUsuario(nombre: chat.otroNombre, radio: 25),
                  ),
                ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            chat.otroNombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textos.titleMedium?.copyWith(
                              fontWeight: conNuevos
                                  ? FontWeight.w800
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (cuando != null) ...[
                          const SizedBox(width: Espacios.s),
                          Text(
                            cuando,
                            style: textos.labelSmall?.copyWith(
                              color: conNuevos
                                  ? Colores.primario
                                  : Colores.tintaSuave,
                              fontWeight: conNuevos
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vista,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: conNuevos ? Colores.tinta : Colores.tintaSuave,
                      ),
                    ),
                    if (oficio != null) ...[
                      const SizedBox(height: Espacios.xs + 2),
                      Pildora(texto: oficio, color: Colores.info),
                    ],
                  ],
                ),
              ),
              if (conNuevos) ...[
                const SizedBox(width: Espacios.m),
                _Insignia(cantidad: sinLeer),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Cantidad de mensajes sin leer, en un círculo verde.
class _Insignia extends StatelessWidget {
  const _Insignia({required this.cantidad});

  final int cantidad;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: Espacios.s - 2),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colores.primario,
        borderRadius: BorderRadius.all(Radius.circular(Radios.pildora)),
      ),
      child: Text(
        cantidad > 99 ? '99+' : '$cantidad',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
