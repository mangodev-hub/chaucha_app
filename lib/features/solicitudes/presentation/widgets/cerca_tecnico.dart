// "Solicitudes cerca de ti" del técnico: las solicitudes abiertas de sus
// oficios dentro de su radio (`solicitudes_en_mapa`), en el mapa y en la
// lista. Al soltar el slider se guarda el radio (`actualizar_mi_radio`).
// Sin verificar, el mapa sale atenuado.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/mapa_radio.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/tarjeta_cerca.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../domain/entities/solicitud_en_mapa.dart';
import '../providers/mapa_tecnico_provider.dart';

class CercaTecnico extends ConsumerStatefulWidget {
  const CercaTecnico({super.key});

  @override
  ConsumerState<CercaTecnico> createState() => _CercaTecnicoState();
}

class _CercaTecnicoState extends ConsumerState<CercaTecnico> {
  double? _km;
  int? _oficio;
  String? _seleccionado;
  String? _resaltado;

  Future<void> _guardarRadio(double km) async {
    final metros = (km * 1000).round();
    final notifier = ref.read(actualizarRadioProvider.notifier);
    final ok = await notifier.guardar(metros);
    if (!mounted) return;
    if (ok) {
      setState(() => _km = null);
      context.mostrarMensaje(
        'Radio actualizado a ${km.round()} km',
        tipo: TipoMensaje.exito,
      );
    } else if (ref.read(actualizarRadioProvider) case AsyncError(
      :final error,
    )) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  void _abrir(SolicitudEnMapa s) => unawaited(
    context.push(AppRoutes.detalleSolicitud(s.id, esCliente: false)),
  );

  @override
  Widget build(BuildContext context) {
    // Mantiene vivo el notifier mientras se guarda el radio.
    final guardando = ref.watch(actualizarRadioProvider).isLoading;
    final perfil = ref.watch(perfilTecnicoProvider).value;
    final centro = perfil?.ubicacionActual;
    // Sin perfil o sin zona no hay mapa: lo explica "Para empezar".
    if (perfil == null || centro == null) return const SizedBox.shrink();

    final solicitudes = ref.watch(solicitudesEnMapaProvider);
    final nombres = <int, String>{
      for (final o in ref.watch(oficiosProvider).value ?? const <Oficio>[])
        o.id: o.nombre,
    };
    String nombre(int id) => nombres[id] ?? 'Oficio';
    final km = _km ?? perfil.rangoCoberturaM / 1000;

    final lista = [
      for (final s in solicitudes.value ?? const <SolicitudEnMapa>[])
        if (_oficio == null || s.oficioId == _oficio) s,
    ];
    SolicitudEnMapa? elegida;
    for (final s in lista) {
      if (s.id == _seleccionado) elegida = s;
    }

    return TarjetaCerca(
      titulo: 'Solicitudes cerca de ti',
      etiquetaRadio: 'Mi radio de cobertura',
      km: km,
      minKm: 1,
      maxKm: 30,
      onKm: (v) => setState(() => _km = v),
      onKmFin: (v) => unawaited(_guardarRadio(v)),
      cargando: solicitudes.isLoading || guardando,
      chips: perfil.oficioIds.length < 2
          ? null
          : ChipsOficio(
              opciones: [for (final id in perfil.oficioIds) (id, nombre(id))],
              seleccionado: _oficio,
              onCambio: (id) => setState(() {
                _oficio = id;
                _seleccionado = null;
              }),
            ),
      mapa: (alto) => MapaRadio(
        centro: centro,
        radioM: (km * 1000).round(),
        alto: alto,
        atenuado: perfil.verificado
            ? null
            : 'Verifica tu identidad para ver solicitudes',
        seleccionadoId: _seleccionado,
        resaltadoId: _resaltado,
        onTocar: (id) => setState(() => _seleccionado = id),
        puntos: [
          for (final s in lista)
            PuntoMapa(
              id: s.id,
              ubicacion: s.ubicacion,
              etiqueta: 'Solicitud de ${nombre(s.oficioId)}',
              pin: (resaltado, seleccionado) => PinCircular(
                resaltado: resaltado,
                seleccionado: seleccionado,
                color: Colores.primario,
                child: Icon(
                  iconoOficio(nombre(s.oficioId)),
                  size: 18,
                  color: Colores.sobreOscuro,
                ),
              ),
            ),
        ],
        tarjeta: elegida == null
            ? null
            : _MiniSolicitud(
                solicitud: elegida,
                oficio: nombre(elegida.oficioId),
                onVer: () => _abrir(elegida!),
                onCerrar: () => setState(() => _seleccionado = null),
              ),
      ),
      lista: (conScroll) {
        if (!perfil.verificado) {
          return const _Aviso(
            'Cuando verifiquemos tu identidad verás aquí las solicitudes de '
            'tu zona.',
          );
        }
        if (solicitudes.hasError && !solicitudes.hasValue) {
          return AsyncValueView<List<SolicitudEnMapa>>(
            value: solicitudes,
            onRetry: () => ref.invalidate(solicitudesEnMapaProvider),
            onData: (_, _) => const SizedBox.shrink(),
          );
        }
        if (!solicitudes.hasValue) {
          return const Center(child: CircularProgressIndicator());
        }
        if (lista.isEmpty) {
          return _Aviso(
            'No hay solicitudes en ${km.round()} km. Prueba ampliando el '
            'radio.',
          );
        }
        final filas = [
          for (final s in lista)
            _FilaSolicitud(
              solicitud: s,
              oficio: nombre(s.oficioId),
              seleccionada: s.id == _seleccionado,
              onTap: () => setState(() => _seleccionado = s.id),
              onResaltar: (si) => setState(() => _resaltado = si ? s.id : null),
            ),
        ];
        return conScroll ? ListView(children: filas) : Column(children: filas);
      },
    );
  }
}

String _detalle(SolicitudEnMapa s, String oficio) =>
    '$oficio · ${Formatos.kilometros(s.metros.toDouble())} · '
    '${Formatos.haceTiempo(s.creadoEn)}';

class _FilaSolicitud extends StatelessWidget {
  const _FilaSolicitud({
    required this.solicitud,
    required this.oficio,
    required this.seleccionada,
    required this.onTap,
    required this.onResaltar,
  });

  final SolicitudEnMapa solicitud;
  final String oficio;
  final bool seleccionada;
  final VoidCallback onTap;
  final ValueChanged<bool> onResaltar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final borde = BorderRadius.circular(Radios.pequeno);
    return MouseRegion(
      onEnter: (_) => onResaltar(true),
      onExit: (_) => onResaltar(false),
      child: Material(
        color: seleccionada ? Colores.primarioSuave : Colors.transparent,
        borderRadius: borde,
        child: InkWell(
          onTap: onTap,
          borderRadius: borde,
          child: Padding(
            padding: const EdgeInsets.all(Espacios.s),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colores.primarioSuave,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconoOficio(oficio),
                    size: 20,
                    color: Colores.primario,
                  ),
                ),
                const SizedBox(width: Espacios.s + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        solicitud.descripcion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textos.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _detalle(solicitud, oficio),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

class _MiniSolicitud extends StatelessWidget {
  const _MiniSolicitud({
    required this.solicitud,
    required this.oficio,
    required this.onVer,
    required this.onCerrar,
  });

  final SolicitudEnMapa solicitud;
  final String oficio;
  final VoidCallback onVer;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Material(
      color: Colores.tarjeta,
      elevation: 4,
      shadowColor: Colores.tinta.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(Espacios.m),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solicitud.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textos.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _detalle(solicitud, oficio),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Espacios.s),
            FilledButton(
              onPressed: onVer,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radios.pequeno),
                ),
              ),
              child: const Text('Ver solicitud'),
            ),
            IconButton(
              tooltip: 'Cerrar',
              visualDensity: VisualDensity.compact,
              onPressed: onCerrar,
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Espacios.l),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Colores.tintaSuave),
      ),
    ),
  );
}
