// Perfil de un técnico visto por el cliente: cabecera con nivel y métricas,
// oficios, certificaciones y reseñas, y a un lado su verificación y lo que
// garantiza ChauchaApp. No muestra puntos, faltas, sanciones ni contacto.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/pie_pagina.dart';
import '../../../../core/config/info_app.dart';
import '../../../../core/presence/presencia_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cabecera_perfil.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pantalla_secundaria.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../auth/presentation/views/inicio_view.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../domain/entities/certificacion.dart';
import '../../domain/entities/perfil_publico.dart';
import '../providers/certificaciones_provider.dart';
import '../providers/perfil_publico_provider.dart';
import '../widgets/certificaciones_widgets.dart';
import '../widgets/resenas_perfil.dart';

/// (texto, fondo) de la píldora de cada nivel.
(Color, Color) _coloresNivel(String nivel) => switch (nivel.toLowerCase()) {
  'bronce' => (const Color(0xFFB87333), const Color(0xFFF6E7DA)),
  'plata' => (const Color(0xFF5F6F7A), const Color(0xFFE8ECEF)),
  'oro' => (const Color(0xFF9A6A00), const Color(0xFFFFF1CC)),
  _ => (Colores.cieloOscuro, Colores.cieloSuave),
};

class PerfilTecnicoPublico extends ConsumerWidget {
  const PerfilTecnicoPublico({super.key, required this.tecnicoId});

  final String tecnicoId;

  String get _enlace {
    final ruta = AppRoutes.perfilTecnico(tecnicoId);
    return kIsWeb ? '${Uri.base.origin}/#$ruta' : ruta;
  }

  Future<void> _compartir(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _enlace));
    if (context.mounted) {
      context.mostrarMensaje('Enlace copiado', tipo: TipoMensaje.exito);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = perfilPublicoProvider(tecnicoId);
    final soyCliente = ref.watch(
      usuarioActualProvider.select((u) => u?.rol == Rol.cliente),
    );
    final enLinea =
        ref.watch(estadoPresenciaProvider(tecnicoId)).value?.enLinea ?? false;
    return PantallaSecundaria(
      titulo: 'Perfil del técnico',
      cuerpo: AsyncValueView<PerfilPublico>(
        value: ref.watch(perfil),
        onRetry: () => ref.invalidate(perfil),
        onData: (context, datos) {
          final certificados =
              ref.watch(certificacionesAprobadasProvider(tecnicoId)).value ??
              const <Certificacion>[];
          return RefreshIndicator(
            onRefresh: () => esperarSinError(ref.refresh(perfil.future)),
            child: ListaDePagina(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  // En la web la ruta de navegación ya va arriba, alineada
                  // con el borde de la cabecera.
                  padding: EstructuraWeb.de(context) != null
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(20),
                  child: AnchoMaximo(
                    ancho: 1180,
                    child: _Contenido(
                      perfil: datos,
                      certificados: certificados,
                      enLinea: enLinea,
                      onCompartir: () => unawaited(_compartir(context)),
                      onEscribir: soyCliente
                          ? () => unawaited(
                              contactarTecnico(
                                context,
                                ref,
                                tecnicoId: datos.tecnicoId,
                                nombreCorto: _nombreCorto(datos.nombre),
                                oficios: datos.oficios,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: Espacios.xl),
                const PiePagina(),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _nombreCorto(String nombre) {
  final partes = nombre.split(' ').where((p) => p.isNotEmpty).toList();
  if (partes.length < 3) return partes.join(' ');
  // "Marco Antonio Vinueza Paredes" → "Marco Vinueza".
  return '${partes.first} ${partes[partes.length - 2]}';
}

String _iniciales(String nombre) => nombre
    .split(' ')
    .where((p) => p.isNotEmpty)
    .take(2)
    .map((p) => p[0])
    .join()
    .toUpperCase();

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.perfil,
    required this.certificados,
    required this.onCompartir,
    this.enLinea = false,
    required this.onEscribir,
  });

  final PerfilPublico perfil;
  final List<Certificacion> certificados;
  final VoidCallback onCompartir;
  final VoidCallback? onEscribir;

  /// Tiene la app abierta ahora (presencia en Redis).
  final bool enLinea;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final p = perfil;
    final (colorNivel, fondoNivel) = _coloresNivel(p.nivelNombre);
    final primerNombre = p.nombre.split(' ').first;
    final ancho = MediaQuery.sizeOf(context).width >= 1000;

    Widget pildora(String texto, Color fondo, Color color, {IconData? icono}) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(Radios.pildora),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icono != null) ...[
                Icon(icono, size: 14, color: color),
                const SizedBox(width: 4),
              ],
              Text(
                texto,
                style: textos.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );

    final cabecera = CabeceraPerfil(
      nombre: p.nombre,
      iniciales: _iniciales(p.nombre),
      fotoRuta: p.fotoRuta,
      datos: Wrap(
        spacing: Espacios.s,
        runSpacing: Espacios.s,
        alignment: WrapAlignment.center,
        children: [
          if (p.verificado)
            pildora(
              'Verificado',
              Colores.primarioSuave,
              Colores.primario,
              icono: Icons.check_rounded,
            ),
          if (p.nivelNombre.isNotEmpty)
            pildora('Nivel ${p.nivelNombre}', fondoNivel, colorNivel),
          if (p.esNuevo)
            pildora('Técnico nuevo', Colores.cieloSuave, Colores.cieloOscuro),
          if (enLinea)
            pildora(
              'En línea',
              Colores.primarioSuave,
              Colores.primarioVivo,
              icono: Icons.circle,
            ),
        ],
      ),
      acciones: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 40,
            child: IconButton.outlined(
              tooltip: 'Copiar enlace del perfil',
              onPressed: onCompartir,
              style: IconButton.styleFrom(
                side: const BorderSide(color: Colores.linea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radios.pequeno),
                ),
              ),
              icon: const Icon(Icons.share_outlined, size: 18),
            ),
          ),
          if (onEscribir != null) ...[
            const SizedBox(width: Espacios.s),
            Flexible(
              child: FilledButton.icon(
                onPressed: onEscribir,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radios.pequeno),
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text(
                  'Escribir al técnico',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
      metricas: [
        MetricaPerfil(
          icono: Icons.star_rounded,
          colorIcono: Colores.estrella,
          valor: p.esNuevo
              ? 'Nuevo'
              : p.calificacionPromedio.toStringAsFixed(1).replaceAll('.', ','),
          etiqueta: 'Calificación',
        ),
        MetricaPerfil(
          icono: Icons.reviews_outlined,
          valor: '${p.totalResenas}',
          etiqueta: p.totalResenas == 1 ? 'Reseña' : 'Reseñas',
        ),
        MetricaPerfil(
          icono: Icons.handyman_outlined,
          valor: '${p.oficios.length}',
          etiqueta: p.oficios.length == 1 ? 'Oficio' : 'Oficios',
        ),
        MetricaPerfil(
          icono: Icons.calendar_month_outlined,
          valor: p.miembroDesde == null
              ? '—'
              : Formatos.mesAnio(p.miembroDesde!),
          etiqueta: 'Miembro desde',
        ),
      ],
    );

    final principal = <Widget>[
      _Oficios(oficios: p.oficios),
      if (certificados.isNotEmpty) ...[
        const SizedBox(height: Espacios.l),
        TarjetaInicio(
          padding: const EdgeInsets.all(Espacios.l + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Certificaciones',
                style: textos.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: Espacios.m),
              ListaCertificacionesPublica(certificaciones: certificados),
            ],
          ),
        ),
      ],
      const SizedBox(height: Espacios.l),
      ResenasPerfil(
        titulo: 'Reseñas',
        resenas: p.resenas,
        vacio: Container(
          padding: const EdgeInsets.all(Espacios.l),
          decoration: BoxDecoration(
            color: Colores.fondoChat,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colores.cieloOscuro,
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$primerNombre es nuevo en ChauchaApp',
                      style: textos.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      p.verificado
                          ? 'Aún no tiene reseñas. Su identidad ya está '
                                'verificada con cédula y selfie.'
                          : 'Aún no tiene reseñas.',
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    final lateral = <Widget>[
      _Verificacion(perfil: p),
      const SizedBox(height: Espacios.l),
      _Contratar(tecnicoId: p.tecnicoId),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        cabecera,
        const SizedBox(height: 20),
        if (ancho)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: principal,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: lateral,
                ),
              ),
            ],
          )
        else ...[
          ...principal,
          const SizedBox(height: Espacios.l),
          ...lateral,
        ],
      ],
    );
  }
}

class _Oficios extends StatelessWidget {
  const _Oficios({required this.oficios});

  final List<String> oficios;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Oficios',
            style: textos.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Espacios.m),
          if (oficios.isEmpty)
            Text(
              'Todavía no eligió sus oficios.',
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            )
          else
            LayoutBuilder(
              builder: (context, r) {
                final columnas = r.maxWidth >= 420 ? 2 : 1;
                final ancho =
                    (r.maxWidth - Espacios.m * (columnas - 1)) / columnas;
                return Wrap(
                  spacing: Espacios.m,
                  runSpacing: Espacios.m,
                  children: [
                    for (final o in oficios)
                      SizedBox(
                        width: ancho,
                        child: Container(
                          padding: const EdgeInsets.all(Espacios.m),
                          decoration: BoxDecoration(
                            color: Colores.fondoClaro,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colores.tarjeta,
                                  borderRadius: BorderRadius.circular(
                                    Radios.pequeno,
                                  ),
                                ),
                                child: Icon(
                                  iconoOficio(o),
                                  size: 20,
                                  color: Colores.primarioVivo,
                                ),
                              ),
                              const SizedBox(width: Espacios.m),
                              Expanded(
                                child: Text(
                                  o,
                                  style: textos.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _Verificacion extends StatelessWidget {
  const _Verificacion({required this.perfil});

  final PerfilPublico perfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    Widget fila(String texto, bool hecho) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            hecho ? Icons.check_circle_rounded : Icons.schedule_rounded,
            size: 20,
            color: hecho ? Colores.primarioVivo : Colores.tintaSuave,
          ),
          const SizedBox(width: Espacios.s),
          Expanded(
            child: Text(
              texto,
              style: textos.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (!hecho)
            Text(
              'En revisión',
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
        ],
      ),
    );
    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Verificación',
            style: textos.titleSmall?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Espacios.s),
          fila('Cédula verificada', perfil.verificado),
          fila('Selfie verificada', perfil.selfieValidada),
        ],
      ),
    );
  }
}

class _Contratar extends StatelessWidget {
  const _Contratar({required this.tecnicoId});

  final String tecnicoId;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    Widget fila(IconData icono, String texto) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icono, size: 20, color: Colores.primarioVivo),
          const SizedBox(width: Espacios.s),
          Expanded(child: Text(texto, style: textos.bodyMedium)),
        ],
      ),
    );
    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Contratar con ChauchaApp',
            style: textos.titleSmall?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Espacios.s),
          fila(
            Icons.verified_user_outlined,
            'Garantía de 30 días en cada servicio.',
          ),
          fila(Icons.credit_card_outlined, 'Pagas solo la visita acordada.'),
          const SizedBox(height: Espacios.s),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => unawaited(
                launchUrl(
                  Uri(
                    scheme: 'mailto',
                    path: InfoApp.correoSoporte,
                    query:
                        'subject=${Uri.encodeComponent('Reporte de perfil $tecnicoId')}',
                  ),
                ),
              ),
              child: Text(
                'Reportar este perfil',
                style: textos.bodySmall?.copyWith(
                  fontSize: 12,
                  color: Colores.tintaSuave,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
