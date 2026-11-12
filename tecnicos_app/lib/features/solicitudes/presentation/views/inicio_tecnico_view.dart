// Pestaña "Inicio" del técnico: qué le falta para trabajar, sus pendientes
// del día, solicitudes nuevas cerca, su actividad y su reputación. Cada
// sección carga por separado; si una falla, las demás se siguen viendo.
//
// Cada sección es una tarjeta bento sobre el fondo oscuro. En móvil: una
// columna. En escritorio: lo urgente a la izquierda y la zona y las ofertas
// a la derecha.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/carrusel_aliados.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_onda.dart';
import '../../../../core/widgets/tarjeta_portada.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../chat/domain/entities/conversacion_pendiente.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../perfil_puntos/presentation/providers/perfil_publico_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../../perfil_puntos/presentation/views/verificacion_view.dart';
import '../../domain/entities/feed.dart';
import '../../domain/entities/resumen_tecnico.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/feed_provider.dart';
import '../providers/inicio_tecnico_provider.dart';
import '../providers/listas_provider.dart';
import '../widgets/mapa_zona_perfil.dart';
import '../widgets/solicitud_widgets.dart';

class InicioTecnicoView extends ConsumerWidget {
  const InicioTecnicoView({super.key});

  /// Recarga todo lo que muestra el inicio.
  static Future<void> _recargar(WidgetRef ref) {
    ref
      ..invalidate(perfilTecnicoProvider)
      ..invalidate(misTrabajosProvider)
      ..invalidate(misOfertasProvider)
      ..invalidate(chatsPendientesProvider)
      ..invalidate(feedProvider);
    final id = ref.read(usuarioActualProvider)?.id;
    if (id != null) ref.invalidate(perfilPublicoProvider(id));
    return esperarSinError(ref.read(resumenTecnicoProvider.future));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escritorio = ResponsiveLayout.isDesktop(context);

    const urgente = [_ParaEmpezar(), _Pendientes(), _NuevasCerca()];
    const progreso = [_Publicidad()];
    const derecha = [_MapaZona(), ...progreso];

    return RefreshIndicator(
      onRefresh: () => _recargar(ref),
      child: ListView(
        padding: escritorio
            ? const EdgeInsets.all(Espacios.xl)
            : const EdgeInsets.fromLTRB(
                Espacios.l,
                Espacios.xs,
                Espacios.l,
                Espacios.l,
              ),
        children: [
          AnchoMaximo(
            ancho: escritorio ? 1100 : 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Portada(),
                if (escritorio)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: urgente,
                        ),
                      ),
                      SizedBox(width: Espacios.bento),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: derecha,
                        ),
                      ),
                    ],
                  )
                else ...[
                  const _MapaZona(),
                  ...urgente,
                  ...progreso,
                ],
                const SizedBox(height: Espacios.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Portada

/// Saludo con el total de pendientes del día (chats por responder y trabajos
/// en curso) en la píldora, cuando ya cargaron.
class _Portada extends ConsumerWidget {
  const _Portada();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsPendientesProvider).value?.length;
    final trabajos = ref
        .watch(resumenTecnicoProvider)
        .value
        ?.trabajosEnCurso
        .length;
    final pendientes = chats == null || trabajos == null
        ? null
        : chats + trabajos;

    // Portada celeste: distingue el inicio del técnico del del cliente.
    return TarjetaPortada(
      celeste: true,
      titulo: 'Tu resumen de hoy.',
      subtitulo: 'Chats, trabajos y solicitudes cerca de ti.',
      icono: Icons.engineering_rounded,
      dato: switch (pendientes) {
        null => null,
        0 => 'Estás al día',
        1 => '1 pendiente hoy',
        final n => '$n pendientes hoy',
      },
      iconoDato: pendientes == 0
          ? Icons.task_alt_rounded
          : Icons.notifications_active_outlined,
    );
  }
}

class _MapaZona extends ConsumerWidget {
  const _MapaZona();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sin ubicación no hay mapa, y tampoco se muestra el título.
    final tieneUbicacion = ref.watch(
      perfilTecnicoProvider.select((p) => p.value?.ubicacionActual != null),
    );
    if (!tieneUbicacion) return const SizedBox.shrink();
    return _Bloque(
      titulo: 'Tu zona de trabajo',
      child: MapaZonaPerfil(
        onTapSolicitud: (s) => _abrirSolicitud(context, ref, s),
      ),
    );
  }
}

// Para empezar a trabajar
/// Lo que le falta al perfil para recibir solicitudes. Desaparece cuando
/// todo está listo.
class _ParaEmpezar extends ConsumerWidget {
  const _ParaEmpezar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilTecnicoProvider).value;
    if (perfil == null) return const SizedBox.shrink();
    final pasos = [
      (
        hecho: perfil.verificado,
        titulo: 'Verifica tu identidad',
        detalle: 'Sube tu cédula y una selfie.',
        accion: 'Verificar',
        onTap: perfil.verificado
            ? null
            : () => unawaited(mostrarVerificacion(context)),
      ),
      (
        hecho: perfil.oficioIds.isNotEmpty,
        titulo: 'Elige tus oficios',
        detalle: 'En la pestaña "Mi perfil".',
        accion: 'Elegir',
        onTap: () {
          ref.read(seccionPerfilProvider.notifier).pedir('oficios');
          ref.read(pestanaSolicitadaProvider.notifier).pedir('Mi perfil');
        },
      ),
      (
        hecho: perfil.ubicacionActual != null,
        titulo: 'Marca tu zona de trabajo',
        detalle: 'En la pestaña "Mi perfil".',
        accion: 'Marcar',
        onTap: () {
          ref.read(seccionPerfilProvider.notifier).pedir('zona');
          ref.read(pestanaSolicitadaProvider.notifier).pedir('Mi perfil');
        },
      ),
    ];
    final hechos = pasos.where((p) => p.hecho).length;
    if (hechos == pasos.length) return const SizedBox.shrink();

    final textos = Theme.of(context).textTheme;
    // Tarjeta verde con los pasos en una sub-tarjeta blanca.
    return _Bloque(
      titulo: 'Para empezar a trabajar',
      verde: true,
      child: TarjetaApp(
        conBorde: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$hechos de ${pasos.length} listos. Completa tu perfil para '
              'ver solicitudes cerca de ti.',
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
            const SizedBox(height: Espacios.s),
            for (final p in pasos)
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: p.onTap,
                leading: Icon(
                  p.hecho ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: p.hecho ? Colores.acento : Colores.aviso,
                ),
                title: Text(
                  p.titulo,
                  style: textos.titleSmall?.copyWith(
                    color: p.hecho ? Colores.tintaSuave : Colores.tinta,
                    decoration: p.hecho ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: p.hecho ? null : Text(p.detalle),
                trailing: p.hecho
                    ? null
                    : FilledButton.tonal(
                        onPressed: p.onTap,
                        child: Text(p.accion),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

// Pendientes de hoy
/// Chats donde el cliente espera respuesta y trabajos en curso.
class _Pendientes extends ConsumerWidget {
  const _Pendientes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsPendientesProvider);
    final resumen = ref.watch(resumenTecnicoProvider);

    final sinPendientes =
        (chats.value?.isEmpty ?? false) &&
        (resumen.value?.trabajosEnCurso.isEmpty ?? false);

    return _Bloque(
      titulo: 'Pendientes de hoy',
      child: sinPendientes
          ? const EstadoMensaje(
              compacto: true,
              tipo: TipoEstado.exito,
              icono: Icons.task_alt,
              titulo: 'Estás al día',
              mensaje: 'No tienes chats por responder ni trabajos en curso.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AsyncCompacto<List<ConversacionPendiente>>(
                  valor: chats,
                  onReintentar: () => ref.invalidate(chatsPorResponderProvider),
                  contenido: (lista) => Column(
                    children: [
                      for (final c in lista.take(3)) _ChatPendiente(chat: c),
                      if (lista.length > 3)
                        _Mas(texto: 'y ${lista.length - 3} chats más'),
                    ],
                  ),
                ),
                _AsyncCompacto<ResumenTecnico>(
                  valor: resumen,
                  onReintentar: () => ref.invalidate(resumenTecnicoProvider),
                  contenido: (r) => Column(
                    children: [
                      for (final t in r.trabajosEnCurso.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: Espacios.m),
                          child: SolicitudCard(
                            solicitud: t,
                            onTap: () => _abrirSolicitud(context, ref, t),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _Publicidad extends StatelessWidget {
  const _Publicidad();

  @override
  Widget build(BuildContext context) =>
      // El carrusel ya es una tarjeta: va solo, con el respiro bento.
      const Padding(
        padding: EdgeInsets.only(top: Espacios.bento),
        child: CarruselAliados(),
      );
}

Future<void> _abrirSolicitud(
  BuildContext context,
  WidgetRef ref,
  Solicitud solicitud,
) async {
  await context.push(
    AppRoutes.detalleSolicitud(solicitud.id, esCliente: false),
  );
  if (!context.mounted) return;
  ref
    ..invalidate(misTrabajosProvider)
    ..invalidate(misOfertasProvider)
    ..invalidate(feedProvider);
}

class _ChatPendiente extends ConsumerWidget {
  const _ChatPendiente({required this.chat});

  final ConversacionPendiente chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final dia = Formatos.dia(chat.enviadoEn);
    final cuando = dia == 'Hoy' ? Formatos.hora(chat.enviadoEn) : dia;
    return TarjetaApp(
      margin: const EdgeInsets.only(bottom: Espacios.m),
      onTap: () async {
        await abrirChat(context, chat.conversacionId, esCliente: false);
        if (context.mounted) ref.invalidate(chatsPorResponderProvider);
      },
      child: Row(
        children: [
          const IconoRecuadro(icono: Icons.mark_chat_unread_outlined),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.oficio == null
                      ? 'Un cliente te escribió'
                      : '${chat.oficio} · te escribió',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.titleSmall,
                ),
                Text(
                  chat.ultimoMensaje,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
          const SizedBox(width: Espacios.s),
          Text(
            cuando,
            style: textos.labelSmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}

// Solicitudes nuevas cerca
/// Las tres solicitudes más recientes de sus oficios en su zona.
class _NuevasCerca extends ConsumerWidget {
  const _NuevasCerca();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    // Con el perfil incompleto no hay feed: lo explica "Para empezar".
    if (feed.value case DatosFeed(:final perfil) when !perfil.estaCompleto) {
      return const SizedBox.shrink();
    }
    return _Bloque(
      titulo: 'Solicitudes nuevas cerca',
      child: _AsyncCompacto<DatosFeed>(
        valor: feed,
        onReintentar: () => ref.invalidate(feedProvider),
        contenido: (datos) {
          final recientes = [...datos.items]
            ..sort(
              (a, b) => b.solicitud.creadoEn.compareTo(a.solicitud.creadoEn),
            );
          if (recientes.isEmpty) {
            return const EstadoMensaje(
              compacto: true,
              icono: Icons.search_off,
              mensaje:
                  'Por ahora no hay solicitudes de tus oficios en tu zona.',
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CuadriculaAdaptable(
                children: [
                  for (final item in recientes)
                    SolicitudCard(
                      solicitud: item.solicitud,
                      distancia: Formatos.distancia(item.distanciaMetros),
                      yaCotice: item.yaCotice,
                      mostrarCliente: true,
                      onTap: () =>
                          _abrirSolicitud(context, ref, item.solicitud),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Una sección que carga sola: un indicador pequeño mientras carga, un aviso
/// compacto con "Reintentar" si falla, y el contenido cuando llegan los
/// datos (se mantiene visible durante una recarga).
class _AsyncCompacto<T> extends StatelessWidget {
  const _AsyncCompacto({
    required this.valor,
    required this.contenido,
    required this.onReintentar,
  });

  final AsyncValue<T> valor;
  final Widget Function(T datos) contenido;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return valor.when(
      skipLoadingOnRefresh: !valor.hasError,
      data: contenido,
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Espacios.l),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.only(bottom: Espacios.m),
        child: EstadoMensaje(
          compacto: true,
          tipo: TipoEstado.error,
          icono: Icons.cloud_off_outlined,
          mensaje: AsyncValueView.mensajeDe(error),
          textoAccion: 'Reintentar',
          onAccion: onReintentar,
        ),
      ),
    );
  }
}

class _Mas extends StatelessWidget {
  const _Mas({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Espacios.xs, bottom: Espacios.s),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Colores.tintaSuave),
      ),
    );
  }
}

/// Sección del inicio como tarjeta bento: título y contenido sobre la
/// superficie clara con una onda celeste, o sobre verde claro con onda
/// celeste si [verde] (lo que pide acción).
class _Bloque extends StatelessWidget {
  const _Bloque({
    required this.titulo,
    required this.child,
    this.verde = false,
  });

  final String titulo;
  final Widget child;
  final bool verde;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Espacios.bento),
      child: verde
          ? TarjetaOnda.verde(titulo: titulo, child: child)
          : TarjetaOnda.clara(titulo: titulo, child: child),
    );
  }
}
