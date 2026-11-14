import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/pie_pagina.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/hoja_clara.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../../core/widgets/tarjeta_portada.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../../chat/presentation/providers/mis_chats_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_publico_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../../perfil_puntos/presentation/views/verificacion_view.dart';
import '../../../perfil_puntos/presentation/widgets/ajustes_tecnico.dart';
import '../../../perfil_puntos/presentation/widgets/disponibilidad_tecnico.dart';
import '../../../publicidad/domain/entities/anuncio.dart';
import '../../../publicidad/presentation/widgets/bloque_publicidad.dart';
import '../providers/feed_provider.dart';
import '../providers/inicio_tecnico_provider.dart';
import '../providers/listas_provider.dart';
import '../providers/visitas_agenda_provider.dart';
import '../widgets/cerca_tecnico.dart';
import '../widgets/inicio_tecnico_bloques.dart';

class InicioTecnicoView extends ConsumerWidget {
  const InicioTecnicoView({super.key});

  /// Desde este ancho, chats, visita y publicidad van a la derecha.
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
      ..invalidate(misChatsProvider)
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
    const resumen = ResumenTecnicoTarjetas();
    const paraEmpezar = _ParaEmpezar(separacion: 18);
    const propuestas = BloquePropuestas();
    const cerca = CercaTecnico();
    const chats = BloqueChatsTecnico();
    const visita = BloqueVisitaTecnico();
    const publicidad = BloquePublicidad(
      ubicacion: UbicacionAnuncio.homeTecnico,
    );
    const espacioPanel = SizedBox(height: Espacios.l);

    final Widget contenido = ancho >= anchoDosColumnas
        ? const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    portada,
                    espacio,
                    resumen,
                    paraEmpezar,
                    espacio,
                    propuestas,
                    espacio,
                    cerca,
                  ],
                ),
              ),
              SizedBox(width: 24),
              SizedBox(
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    chats,
                    espacioPanel,
                    visita,
                    espacioPanel,
                    publicidad,
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              portada,
              espacio,
              resumen,
              paraEmpezar,
              espacio,
              // En el teléfono la próxima visita va antes que los chats.
              if (movil) ...[
                visita,
                espacio,
                chats,
              ] else ...[
                chats,
                espacio,
                visita,
              ],
              espacio,
              propuestas,
              espacio,
              cerca,
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

class _Portada extends ConsumerWidget {
  const _Portada();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final nombre =
        ref.watch(usuarioActualProvider)?.nombres.trim().split(' ').first ?? '';
    final perfil = ref.watch(perfilTecnicoProvider).value;
    final nombresOficio = {
      for (final o in ref.watch(oficiosProvider).value ?? const <Oficio>[])
        o.id: o.nombre,
    };
    final misOficios = [
      for (final id in perfil?.oficioIds ?? const <int>[]) ?nombresOficio[id],
    ];
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
                        // Sus oficios, como los del inicio del cliente.
                        for (final o in misOficios) _ChipOficio(o),
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

/// Oficio del técnico: chip blanco translúcido con borde suave.
class _ChipOficio extends StatelessWidget {
  const _ChipOficio(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.m,
        vertical: Espacios.s - 1,
      ),
      decoration: BoxDecoration(
        color: Colores.tarjeta.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(Radios.pildora),
        border: Border.all(color: Colores.tarjeta.withValues(alpha: 0.9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconoOficio(texto), size: 15, color: Colores.cieloOscuro),
          const SizedBox(width: Espacios.xs + 2),
          Text(
            texto,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 13,
              color: Colores.cieloOscuro,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
