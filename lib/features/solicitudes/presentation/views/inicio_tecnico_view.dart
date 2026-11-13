// Pestaña "Inicio" del técnico: su portada con la línea del día, qué le
// falta para trabajar, las solicitudes cerca y sus pendientes. Cada sección
// carga por separado; si una falla, las demás se siguen viendo.
//
// Mismo armado que el inicio del cliente: tarjetas blancas (radio 18 y
// sombra suave) sobre el fondo claro. Desde 1280 px, la portada, "Para
// empezar" y el mapa van a la izquierda, y la publicidad y los pendientes
// en una columna de 340 px a la derecha. En la web la página va dentro del
// scroll único del shell (que pone el pie); en el teléfono, en la hoja
// clara con su propio scroll.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pie_pagina.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/hoja_clara.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../../core/widgets/tarjeta_portada.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../chat/domain/entities/conversacion_pendiente.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../perfil_puntos/presentation/providers/perfil_publico_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../../perfil_puntos/presentation/views/verificacion_view.dart';
import '../../../perfil_puntos/presentation/widgets/ajustes_tecnico.dart';
import '../../../perfil_puntos/presentation/widgets/disponibilidad_tecnico.dart';
import '../../../publicidad/domain/entities/anuncio.dart';
import '../../../publicidad/presentation/widgets/bloque_publicidad.dart';
import '../../domain/entities/resumen_tecnico.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/feed_provider.dart';
import '../providers/inicio_tecnico_provider.dart';
import '../providers/listas_provider.dart';
import '../providers/visitas_agenda_provider.dart';
import '../widgets/cerca_tecnico.dart';

class InicioTecnicoView extends ConsumerWidget {
  const InicioTecnicoView({super.key});

  /// Desde este ancho, la publicidad y los pendientes van a la derecha.
  static const double anchoDosColumnas = 1280;

  /// Bajo este ancho es el teléfono: hoja clara con scroll propio.
  static const double anchoMovil = 700;

  /// Recarga todo lo que muestra el inicio.
  static Future<void> _recargar(WidgetRef ref) {
    ref
      ..invalidate(perfilTecnicoProvider)
      ..invalidate(misTrabajosProvider)
      ..invalidate(misOfertasProvider)
      ..invalidate(chatsPendientesProvider)
      ..invalidate(visitasProximasProvider(false))
      ..invalidate(feedProvider);
    final id = ref.read(usuarioActualProvider)?.id;
    if (id != null) ref.invalidate(perfilPublicoProvider(id));
    return esperarSinError(ref.read(resumenTecnicoProvider.future));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ancho = MediaQuery.sizeOf(context).width;
    final movil = ancho < anchoMovil;
    const espacio = SizedBox(height: 18);

    const portada = _Portada();
    const paraEmpezar = _ParaEmpezar(separacion: 18);
    const cerca = CercaTecnico();
    const pendientes = _Pendientes();
    const publicidad = BloquePublicidad(
      ubicacion: UbicacionAnuncio.homeTecnico,
    );

    final Widget contenido = ancho >= anchoDosColumnas
        ? const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [portada, paraEmpezar, espacio, cerca],
                ),
              ),
              SizedBox(width: 24),
              SizedBox(
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    publicidad,
                    SizedBox(height: Espacios.l),
                    pendientes,
                  ],
                ),
              ),
            ],
          )
        : const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              portada,
              paraEmpezar,
              espacio,
              cerca,
              espacio,
              pendientes,
              espacio,
              publicidad,
            ],
          );

    // Dentro del scroll único de la web, la página ya tiene scroll y pie.
    if (ScrollDePagina.activo(context)) return contenido;

    final pagina = RefreshIndicator(
      onRefresh: () => _recargar(ref),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // En web, 12 px a los lados para que no se corten las sombras.
        padding: movil
            ? const EdgeInsets.all(Espacios.l)
            : const EdgeInsets.fromLTRB(12, 0, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            contenido,
            const SizedBox(height: Espacios.xxl),
            const PiePagina(),
          ],
        ),
      ),
    );
    return movil ? HojaClara(child: pagina) : pagina;
  }
}

// Portada

/// "Hola, {nombre}." sobre el degradado celeste, con la línea del día, la
/// calificación y los puntos en una píldora blanca y la ilustración del
/// técnico a la derecha. En el teléfono, sin barra superior, lleva también
/// la píldora "Disponible".
class _Portada extends ConsumerWidget {
  const _Portada();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final nombre =
        ref.watch(usuarioActualProvider)?.nombres.trim().split(' ').first ?? '';
    final perfil = ref.watch(perfilTecnicoProvider).value;
    final chats = ref.watch(chatsPendientesProvider).value?.length;
    final hoy = DateTime.now();
    final visitas = ref
        .watch(visitasProximasProvider(false))
        .value
        ?.where((v) => DateUtils.isSameDay(v.inicio, hoy))
        .length;
    final movil =
        MediaQuery.sizeOf(context).width < InicioTecnicoView.anchoMovil;

    // Lo más urgente primero: visitas de hoy, luego chats por responder.
    final linea = switch ((visitas, chats)) {
      (final v?, _) when v > 0 =>
        v == 1 ? 'Hoy tienes 1 visita' : 'Hoy tienes $v visitas',
      (_, final c?) when c > 0 =>
        c == 1
            ? 'Tienes 1 chat por responder'
            : 'Tienes $c chats por responder',
      (_?, _?) => 'Estás al día',
      _ => null,
    };

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colores.cieloSuave, Colores.cieloNube, Colores.cieloBruma],
        ),
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      padding: const EdgeInsets.all(Espacios.xl),
      child: LayoutBuilder(
        builder: (context, restricciones) {
          final ancho = restricciones.maxWidth;
          final conIlustracion = ancho >= 340;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre.isEmpty ? 'Hola.' : 'Hola, $nombre.',
                      style: textos.headlineMedium?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colores.tinta,
                        height: 1.15,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: Espacios.s),
                    AnimatedSwitcher(
                      duration: Movimiento.de(context, Movimiento.normal),
                      child: Text(
                        linea ?? 'Revisando tu día…',
                        key: ValueKey(linea),
                        style: textos.titleMedium?.copyWith(
                          fontSize: 16,
                          color: Colores.cieloOscuro,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: Espacios.l),
                    Wrap(
                      spacing: Espacios.s,
                      runSpacing: Espacios.s,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (perfil != null)
                          _PildoraReputacion(
                            calificacion: perfil.totalResenas == 0
                                ? null
                                : perfil.calificacionPromedio,
                            puntos: perfil.puntos,
                          ),
                        if (movil) const PildoraDisponible(),
                      ],
                    ),
                  ],
                ),
              ),
              if (conIlustracion) ...[
                const SizedBox(width: Espacios.l),
                IlustracionPortada(
                  icono: Icons.engineering_rounded,
                  tamano: ancho >= 600 ? 130 : 96,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Píldora blanca: estrella, calificación (o "Nuevo") y puntos.
class _PildoraReputacion extends StatelessWidget {
  const _PildoraReputacion({required this.calificacion, required this.puntos});

  final double? calificacion;
  final int puntos;

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontSize: 13,
      color: Colores.tinta,
      fontWeight: FontWeight.w700,
    );
    final calificacion = this.calificacion;
    final nota = calificacion == null
        ? 'Nuevo'
        : calificacion.toStringAsFixed(1).replaceAll('.', ',');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.m + 2,
        vertical: Espacios.s,
      ),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Semantics(
        label: calificacion == null
            ? 'Técnico nuevo, $puntos puntos'
            : 'Calificación $nota, $puntos puntos',
        child: ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Colores.estrella),
              const SizedBox(width: Espacios.xs),
              Text(nota, style: estilo),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Espacios.s),
                child: Text(
                  '·',
                  style: estilo?.copyWith(color: Colores.tintaSuave),
                ),
              ),
              Text('$puntos pts', style: estilo),
            ],
          ),
        ),
      ),
    );
  }
}

// Para empezar a trabajar

/// Lo que le falta al perfil para recibir solicitudes, con el progreso y un
/// botón por paso que abre la acción. Desaparece cuando todo está listo.
class _ParaEmpezar extends ConsumerWidget {
  const _ParaEmpezar({required this.separacion});

  /// Espacio arriba, solo si la tarjeta se muestra.
  final double separacion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilTecnicoProvider).value;
    if (perfil == null) return const SizedBox.shrink();
    final pasos = [
      (
        hecho: perfil.verificado,
        titulo: 'Verificar identidad',
        detalle: 'Sube tu cédula y una selfie.',
        accion: 'Verificar',
        onTap: () => unawaited(mostrarVerificacion(context)),
      ),
      (
        hecho: perfil.oficioIds.isNotEmpty,
        titulo: 'Elegir oficios',
        detalle: 'Verás solicitudes de los oficios que elijas.',
        accion: 'Elegir',
        onTap: () => unawaited(mostrarSelectorOficios(context)),
      ),
      (
        hecho: perfil.ubicacionActual != null,
        titulo: 'Marcar zona de trabajo',
        detalle: 'Desde dónde sales y hasta dónde atiendes.',
        accion: 'Marcar',
        onTap: () => unawaited(mostrarZonaTrabajo(context)),
      ),
    ];
    final hechos = pasos.where((p) => p.hecho).length;
    if (hechos == pasos.length) return const SizedBox.shrink();

    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(top: separacion),
      child: TarjetaInicio(
        padding: const EdgeInsets.all(Espacios.l + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Para empezar a trabajar',
                    style: textos.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '$hechos de ${pasos.length} listos',
                  style: textos.labelMedium?.copyWith(
                    color: Colores.tintaSuave,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacios.s),
            ClipRRect(
              borderRadius: BorderRadius.circular(Radios.pildora),
              child: LinearProgressIndicator(
                value: hechos / pasos.length,
                minHeight: 4,
                color: Colores.primarioVivo,
                backgroundColor: Colores.superficie,
                semanticsLabel: 'Progreso del perfil',
              ),
            ),
            const SizedBox(height: Espacios.s),
            for (final (i, p) in pasos.indexed) ...[
              if (i > 0) const Divider(height: 1, color: Colores.divisor),
              _PasoInicio(
                hecho: p.hecho,
                titulo: p.titulo,
                detalle: p.detalle,
                accion: p.accion,
                onTap: p.onTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PasoInicio extends StatelessWidget {
  const _PasoInicio({
    required this.hecho,
    required this.titulo,
    required this.detalle,
    required this.accion,
    required this.onTap,
  });

  final bool hecho;
  final String titulo;
  final String detalle;
  final String accion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.m),
      child: Row(
        children: [
          if (hecho)
            const Icon(
              Icons.check_circle_rounded,
              size: 24,
              color: Colores.primarioVivo,
              semanticLabel: 'Listo',
            )
          else
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colores.superficieFuerte, width: 2),
              ),
            ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: textos.titleSmall?.copyWith(
                    color: hecho ? Colores.tintaSuave : Colores.tinta,
                    decoration: hecho ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (!hecho)
                  Text(
                    detalle,
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
              ],
            ),
          ),
          if (!hecho) ...[
            const SizedBox(width: Espacios.s),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: Colores.primarioSuave,
                foregroundColor: Colores.primario,
                elevation: 0,
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: Espacios.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radios.pildora),
                ),
                textStyle: textos.labelLarge?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(accion),
            ),
          ],
        ],
      ),
    );
  }
}

// Pendientes de hoy

/// Chats donde el cliente espera respuesta y trabajos en curso. Si está al
/// día es una fila compacta.
class _Pendientes extends ConsumerWidget {
  const _Pendientes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final chats = ref.watch(chatsPendientesProvider);
    final resumen = ref.watch(resumenTecnicoProvider);

    final alDia =
        (chats.value?.isEmpty ?? false) &&
        (resumen.value?.trabajosEnCurso.isEmpty ?? false);

    if (alDia) {
      return TarjetaInicio(
        child: Row(
          children: [
            const IconoRecuadro(
              icono: Icons.task_alt_rounded,
              color: Colores.primario,
              fondo: Colores.primarioSuave,
            ),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pendientes de hoy', style: textos.titleSmall),
                  Text(
                    'Estás al día: sin chats ni trabajos en curso.',
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pendientes de hoy',
            style: textos.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Espacios.s),
          _AsyncCompacto<List<ConversacionPendiente>>(
            valor: chats,
            onReintentar: () => ref.invalidate(chatsPorResponderProvider),
            contenido: (lista) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final t in r.trabajosEnCurso.take(3))
                  _FilaPendiente(
                    icono: Icons.handyman_outlined,
                    titulo: '${t.oficioNombre} · en curso',
                    detalle: t.descripcion,
                    onTap: () => unawaited(_abrirSolicitud(context, ref, t)),
                  ),
                if (r.trabajosEnCurso.length > 3)
                  _Mas(texto: 'y ${r.trabajosEnCurso.length - 3} trabajos más'),
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
    final dia = Formatos.dia(chat.enviadoEn);
    return _FilaPendiente(
      icono: Icons.mark_chat_unread_outlined,
      titulo: chat.oficio == null
          ? 'Un cliente te escribió'
          : '${chat.oficio} · te escribió',
      detalle: chat.ultimoMensaje,
      cuando: dia == 'Hoy' ? Formatos.hora(chat.enviadoEn) : dia,
      onTap: () async {
        await abrirChat(context, chat.conversacionId, esCliente: false);
        if (context.mounted) ref.invalidate(chatsPorResponderProvider);
      },
    );
  }
}

/// Fila tocable de un pendiente: ícono, título, detalle y hora opcional.
class _FilaPendiente extends StatelessWidget {
  const _FilaPendiente({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.onTap,
    this.cuando,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final String? cuando;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final cuando = this.cuando;
    final borde = BorderRadius.circular(Radios.pequeno);
    return InkWell(
      onTap: onTap,
      borderRadius: borde,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Espacios.s),
        child: Row(
          children: [
            IconoRecuadro(icono: icono),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.titleSmall,
                  ),
                  Text(
                    detalle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
            ),
            if (cuando != null) ...[
              const SizedBox(width: Espacios.s),
              Text(
                cuando,
                style: textos.labelSmall?.copyWith(color: Colores.tintaSuave),
              ),
            ],
          ],
        ),
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
