import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../auth/presentation/widgets/inicio_cliente_widgets.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../../chat/data/repositories/supabase_chat_repository.dart';
import '../../../chat/domain/entities/resumen_chat.dart';
import '../../../chat/presentation/providers/mis_chats_provider.dart';
import '../../../chat/presentation/views/chats_view.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';
import '../../domain/entities/feed.dart';
import '../../domain/entities/visita_agenda.dart';
import '../providers/feed_provider.dart';
import '../providers/inicio_tecnico_provider.dart';
import '../providers/visitas_agenda_provider.dart';

/// Tres tarjetas: lo ganado en el mes, los trabajos completados y las
/// propuestas que esperan respuesta.
class ResumenTecnicoTarjetas extends ConsumerWidget {
  const ResumenTecnicoTarjetas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(resumenTecnicoProvider).value;
    void ir(String pestana) =>
        ref.read(pestanaSolicitadaProvider.notifier).pedir(pestana);
    return FilaTarjetasInicio(
      tarjetas: [
        TarjetaConfianza(
          icono: Icons.payments_outlined,
          fondo: Colores.avisoSuave,
          color: Colores.aviso,
          titulo: r == null
              ? 'Ganado este mes'
              : '${Formatos.dinero(r.ganadoEsteMes)} este mes',
          texto: 'Por las visitas que cerraste. Sin comisiones.',
          onTap: () => ir('Mis trabajos'),
        ),
        TarjetaConfianza(
          icono: Icons.task_alt_rounded,
          fondo: Colores.primarioSuave,
          color: Colores.primarioVivo,
          titulo: switch (r?.completados) {
            null => 'Trabajos completados',
            1 => '1 trabajo completado',
            final n => '$n trabajos completados',
          },
          texto: 'Cada cierre con buena reseña suma puntos.',
          onTap: () => ir('Mis trabajos'),
        ),
        TarjetaConfianza(
          icono: Icons.send_outlined,
          fondo: Colores.cieloSuave,
          color: Colores.cieloOscuro,
          titulo: switch (r?.ofertasPendientes) {
            null => 'Propuestas en espera',
            0 => 'Sin propuestas en espera',
            1 => '1 propuesta en espera',
            final n => '$n propuestas en espera',
          },
          texto: 'Clientes que aún no responden.',
          onTap: () => ir('Mis trabajos'),
        ),
      ],
    );
  }
}

/// "Tus propuestas": solicitudes donde ya postuló y que siguen abiertas.
class BloquePropuestas extends ConsumerWidget {
  const BloquePropuestas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TituloBloque(
          titulo: 'Tus propuestas',
          enlace: 'Ver mis trabajos',
          onEnlace: () => ref
              .read(pestanaSolicitadaProvider.notifier)
              .pedir('Mis trabajos'),
        ),
        const SizedBox(height: Espacios.s),
        AsyncValueView<DatosFeed>(
          value: feed,
          onRetry: () => ref.invalidate(feedProvider),
          cargando: (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: Espacios.l),
            child: Center(child: CircularProgressIndicator()),
          ),
          onData: (context, datos) {
            final mias = [
              for (final i in datos.items)
                if (i.yaCotice) i,
            ];
            if (mias.isEmpty) {
              return const TarjetaInicio(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: TextoVacio(
                  'No tienes propuestas en espera. Mira las solicitudes '
                  'cerca de ti y postula.',
                ),
              );
            }
            return Column(
              children: [
                for (final (i, item) in mias.take(3).indexed) ...[
                  if (i > 0) const SizedBox(height: Espacios.m),
                  _TarjetaPropuesta(item: item),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TarjetaPropuesta extends ConsumerWidget {
  const _TarjetaPropuesta({required this.item});

  final ItemFeed item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final s = item.solicitud;
    Future<void> abrir() async {
      await context.push(AppRoutes.detalleSolicitud(s.id, esCliente: false));
      if (!context.mounted) return;
      ref
        ..invalidate(feedProvider)
        ..invalidate(misOfertasProvider);
    }

    return TarjetaInicio(
      onTap: () => unawaited(abrir()),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colores.cieloSuave,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              iconoOficio(s.oficioNombre),
              color: Colores.cieloOscuro,
            ),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.oficioNombre} · ${s.descripcion}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.titleSmall?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${Formatos.kilometros(item.distanciaMetros)} · '
                  'publicada ${Formatos.haceTiempo(s.creadoEn)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodySmall?.copyWith(
                    fontSize: 13,
                    color: Colores.tintaSuave,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Espacios.s),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colores.cieloSuave,
              borderRadius: BorderRadius.circular(Radios.pildora),
            ),
            child: Text(
              'En espera',
              style: textos.labelMedium?.copyWith(
                color: Colores.cieloOscuro,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Los tres chats más recientes, como en el inicio del cliente.
class BloqueChatsTecnico extends ConsumerWidget {
  const BloqueChatsTecnico({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(misChatsProvider);
    final noLeidas =
        ref.watch(notificacionesNoLeidasProvider).value ?? const [];
    int sinLeerDe(String id) => noLeidas
        .where((n) => tiposDeChat.contains(n.tipo) && n.referenciaId == id)
        .length;

    return ResumenChats(
      onVerTodos: () =>
          ref.read(pestanaSolicitadaProvider.notifier).pedir('Chats'),
      contenido: AsyncValueView<List<ResumenChat>>(
        value: chats,
        onRetry: () => ref.invalidate(misChatsProvider),
        cargando: (_) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Espacios.m),
          child: Center(child: CircularProgressIndicator()),
        ),
        onData: (context, lista) {
          if (lista.isEmpty) {
            return const TextoVacio('Aún no tienes conversaciones.');
          }
          final recientes = [...lista]
            ..sort((a, b) {
              final fa = a.enviadoEn;
              final fb = b.enviadoEn;
              if (fa == null && fb == null) return 0;
              if (fa == null) return 1;
              if (fb == null) return -1;
              return fb.compareTo(fa);
            });
          return Column(
            children: [
              for (var i = 0; i < recientes.length && i < 3; i++)
                FilaChat(
                  chat: recientes[i],
                  sinLeer: sinLeerDe(recientes[i].conversacionId),
                  cielo: i.isOdd,
                  onTap: () async {
                    await abrirChat(
                      context,
                      recientes[i].conversacionId,
                      esCliente: false,
                    );
                    if (context.mounted) {
                      ref
                        ..invalidate(misChatsProvider)
                        ..invalidate(chatsPorResponderProvider);
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

/// La próxima visita agendada: día, hora, cliente y precio, con "Ver
/// detalle" y "Escribir".
class BloqueVisitaTecnico extends ConsumerWidget {
  const BloqueVisitaTecnico({super.key});

  Future<void> _escribir(
    BuildContext context,
    WidgetRef ref,
    VisitaAgenda v,
  ) async {
    final yo = ref.read(usuarioActualProvider)?.id;
    if (yo == null) return;
    try {
      final id = await ref
          .read(chatRepositoryProvider)
          .obtenerOCrearConversacion(solicitudId: v.solicitudId, tecnicoId: yo);
      if (!context.mounted) return;
      await abrirChat(context, id, esCliente: false);
    } on AppFailure catch (e) {
      if (context.mounted) {
        context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitas = ref.watch(visitasProximasProvider(false));
    return TarjetaProximaVisita(
      contenido: AsyncValueView<List<VisitaAgenda>>(
        value: visitas,
        onRetry: () => ref.invalidate(visitasProximasProvider(false)),
        cargando: (_) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Espacios.m),
          child: Center(child: CircularProgressIndicator()),
        ),
        onData: (context, lista) {
          final ahora = DateTime.now();
          final futuras = [
            for (final v in lista)
              if (v.fin.isAfter(ahora)) v,
          ]..sort((a, b) => a.inicio.compareTo(b.inicio));
          if (futuras.isEmpty) {
            return const TextoVacio('No tienes visitas agendadas');
          }
          final v = futuras.first;
          return DatosProximaVisita(
            inicio: v.inicio,
            fin: v.fin,
            tecnico: v.otraPersonaNombre,
            titulo: v.descripcion,
            precio: v.precioVisita,
            textoSecundario: 'Ver detalle',
            onReagendar: () => unawaited(
              context.push(
                AppRoutes.detalleSolicitud(v.solicitudId, esCliente: false),
              ),
            ),
            onEscribir: () => unawaited(_escribir(context, ref, v)),
          );
        },
      ),
    );
  }
}
