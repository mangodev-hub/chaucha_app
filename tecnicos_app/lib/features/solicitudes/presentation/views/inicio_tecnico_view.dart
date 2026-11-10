// Pestaña "Inicio" del técnico: qué le falta para trabajar, sus pendientes
// del día, solicitudes nuevas cerca, su actividad y su reputación. Cada
// sección carga por separado; si una falla, las demás se siguen viendo.
//
// En móvil: una columna. En escritorio: lo urgente a la izquierda y la
// actividad y reputación a la derecha.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_portada.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../chat/domain/entities/conversacion_pendiente.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../perfil_puntos/domain/entities/nivel.dart';
import '../../../perfil_puntos/domain/entities/perfil_tecnico.dart';
import '../../../perfil_puntos/presentation/providers/perfil_publico_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../../perfil_puntos/presentation/views/verificacion_view.dart';
import '../../../perfil_puntos/presentation/widgets/resena_widgets.dart';
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
    const progreso = [_Actividad(), _Reputacion()];
    const derecha = [_MapaZona(), ...progreso];

    return RefreshIndicator(
      onRefresh: () => _recargar(ref),
      child: ListView(
        padding: EdgeInsets.all(escritorio ? Espacios.xl : Espacios.l),
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
                      SizedBox(width: Espacios.xl),
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
    final nombre = ref.watch(usuarioActualProvider)?.nombres;
    final chats = ref.watch(chatsPendientesProvider).value?.length;
    final trabajos = ref
        .watch(resumenTecnicoProvider)
        .value
        ?.trabajosEnCurso
        .length;
    final pendientes = chats == null || trabajos == null
        ? null
        : chats + trabajos;

    return TarjetaPortada(
      titulo: nombre == null ? 'Hola.' : 'Hola, $nombre.',
      subtitulo: 'Este es tu resumen de hoy.',
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
    return Seccion(
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
        onTap: perfil.verificado
            ? null
            : () => unawaited(mostrarVerificacion(context)),
      ),
      (
        hecho: perfil.oficioIds.isNotEmpty,
        titulo: 'Elige tus oficios',
        detalle: 'En la pestaña "Mi perfil".',
        onTap: null,
      ),
      (
        hecho: perfil.ubicacionActual != null,
        titulo: 'Marca tu zona de trabajo',
        detalle: 'En la pestaña "Mi perfil".',
        onTap: null,
      ),
    ];
    final hechos = pasos.where((p) => p.hecho).length;
    if (hechos == pasos.length) return const SizedBox.shrink();

    final textos = Theme.of(context).textTheme;
    return Seccion(
      titulo: 'Para empezar a trabajar',
      child: TarjetaApp(
        colorBorde: Colores.primarioClaro,
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
                trailing: p.onTap == null
                    ? null
                    : const Icon(Icons.chevron_right, color: Colores.primario),
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

    return Seccion(
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

  static const int _cuantas = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    // Con el perfil incompleto no hay feed: lo explica "Para empezar".
    if (feed.value case DatosFeed(:final perfil) when !perfil.estaCompleto) {
      return const SizedBox.shrink();
    }
    return Seccion(
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
                  for (final item in recientes.take(_cuantas))
                    SolicitudCard(
                      solicitud: item.solicitud,
                      distancia: Formatos.distancia(item.distanciaMetros),
                      yaCotice: item.yaCotice,
                      onTap: () =>
                          _abrirSolicitud(context, ref, item.solicitud),
                    ),
                ],
              ),
              if (recientes.length > _cuantas)
                _Mas(
                  texto:
                      'Hay ${recientes.length - _cuantas} más en la pestaña '
                      '"Solicitudes cerca".',
                ),
            ],
          );
        },
      ),
    );
  }
}

// Tu actividad

class _Actividad extends ConsumerWidget {
  const _Actividad();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Seccion(
      titulo: 'Tu actividad',
      child: _AsyncCompacto<ResumenTecnico>(
        valor: ref.watch(resumenTecnicoProvider),
        onReintentar: () => ref.invalidate(resumenTecnicoProvider),
        contenido: (r) => CuadriculaAdaptable(
          anchoMinimo: 0,
          children: [
            _Dato(
              icono: Icons.local_offer_outlined,
              color: Colores.info,
              valor: '${r.ofertasPendientes}',
              etiqueta: 'Ofertas pendientes',
            ),
            _Dato(
              icono: Icons.receipt_long_outlined,
              color: Colores.aviso,
              valor: '${r.ticketsPorConfirmar}',
              etiqueta: 'Tickets por confirmar',
            ),
            _Dato(
              icono: Icons.task_alt,
              color: Colores.acento,
              valor: '${r.completados}',
              etiqueta: 'Trabajos completados',
            ),
            _Dato(
              icono: Icons.payments_outlined,
              color: Colores.primario,
              valor: Formatos.dinero(r.ganadoEsteMes),
              etiqueta: 'Ganado este mes',
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({
    required this.icono,
    required this.color,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final Color color;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: color),
          const SizedBox(height: Espacios.s),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(valor, style: textos.headlineSmall),
          ),
          Text(
            etiqueta,
            maxLines: 2,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}

// Tu reputación

class _Reputacion extends ConsumerWidget {
  const _Reputacion();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final miId = ref.watch(usuarioActualProvider)?.id;
    return Seccion(
      titulo: 'Tu reputación',
      child: _AsyncCompacto<PerfilTecnico>(
        valor: ref.watch(perfilTecnicoProvider),
        onReintentar: () => ref.invalidate(perfilTecnicoProvider),
        contenido: (perfil) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TarjetaNivel(
              perfil: perfil,
              // Si no cargan los niveles, solo no se muestra el progreso.
              niveles: ref.watch(nivelesProvider).value,
            ),
            if (miId != null) _UltimasResenas(tecnicoId: miId),
          ],
        ),
      ),
    );
  }
}

class _TarjetaNivel extends StatelessWidget {
  const _TarjetaNivel({required this.perfil, required this.niveles});

  final PerfilTecnico perfil;
  final List<Nivel>? niveles;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final niveles = this.niveles;
    final progreso = niveles == null || niveles.isEmpty
        ? null
        : ProgresoNivel.calcular(perfil.puntos, niveles);
    final esNuevo = perfil.totalResenas == 0;
    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colores.estrella, size: 32),
              const SizedBox(width: Espacios.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      esNuevo
                          ? 'Técnico nuevo'
                          : perfil.calificacionPromedio.toStringAsFixed(1),
                      style: textos.titleLarge,
                    ),
                    Text(
                      esNuevo
                          ? 'Aún sin reseñas'
                          : '${perfil.totalResenas} '
                                '${perfil.totalResenas == 1 ? 'reseña' : 'reseñas'}',
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Espacios.s),
              Flexible(
                child: Pildora(
                  texto: 'Nivel ${perfil.nivelNombre}',
                  icono: Icons.workspace_premium_outlined,
                  color: Colores.primario,
                ),
              ),
            ],
          ),
          if (progreso != null) ...[
            const SizedBox(height: Espacios.l),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${perfil.puntos} pts',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.labelLarge,
                  ),
                ),
                if (!progreso.esNivelMaximo)
                  Flexible(
                    child: Text(
                      '${progreso.siguiente!.puntosMinimos} pts',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: textos.labelMedium?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Espacios.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(Radios.pildora),
              child: LinearProgressIndicator(
                value: progreso.fraccion,
                minHeight: 8,
                semanticsLabel: 'Progreso al siguiente nivel',
              ),
            ),
            const SizedBox(height: Espacios.s),
            Text(
              progreso.esNivelMaximo
                  ? 'Estás en el nivel más alto. ¡Buen trabajo!'
                  : 'Te faltan ${progreso.puntosFaltantes} puntos para el '
                        'nivel ${progreso.siguiente!.nombre}.',
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
          ],
        ],
      ),
    );
  }
}

/// Las dos reseñas más recientes que recibió.
class _UltimasResenas extends ConsumerWidget {
  const _UltimasResenas({required this.tecnicoId});

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resenas = ref.watch(perfilPublicoProvider(tecnicoId)).value?.resenas;
    // Las reseñas complementan la tarjeta: si no cargan, no se muestran (ni
    // tampoco el título de la sección).
    if (resenas == null || resenas.isEmpty) return const SizedBox.shrink();
    return Seccion(
      titulo: 'Reseñas',
      child: Column(
        children: [for (final r in resenas.take(2)) TarjetaResena(resena: r)],
      ),
    );
  }
}
// Piezas comunes

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
