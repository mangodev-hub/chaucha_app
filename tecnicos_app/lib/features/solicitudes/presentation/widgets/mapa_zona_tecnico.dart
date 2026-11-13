import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/capa_circulos.dart';
import '../../../../core/widgets/etiqueta_sector.dart';
import '../../../../core/widgets/presionable.dart';
import '../../domain/entities/solicitud.dart';
import 'control_radio.dart';

class MapaZonaTecnico extends StatefulWidget {
  const MapaZonaTecnico({
    super.key,
    required this.centro,
    required this.radioM,
    required this.solicitudes,
    this.onCambiarRadio,
    this.onTapSolicitud,
    this.alto = 380,
  });

  final LatLng centro;
  final int radioM;
  final List<Solicitud> solicitudes;
  final double alto;
  final ValueChanged<int>? onCambiarRadio;

  /// Al tocar el pin de una solicitud (por ejemplo, para abrir su detalle).
  /// Si es null, los pines solo informan.
  final ValueChanged<Solicitud>? onTapSolicitud;

  @override
  State<MapaZonaTecnico> createState() => _MapaZonaTecnicoState();
}

class _MapaZonaTecnicoState extends State<MapaZonaTecnico> {
  final MapController _controller = MapController();
  late double _radioKm = widget.radioM / 1000;

  @override
  void didUpdateWidget(MapaZonaTecnico anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.radioM != widget.radioM) _radioKm = widget.radioM / 1000;
  }

  double get _zoomInicial =>
      (12.5 - math.log(widget.radioM / 5000) / math.ln2).clamp(9.0, 15.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final km = _radioKm.toStringAsFixed(_radioKm % 1 == 0 ? 0 : 1);
    final cerca = [
      for (final s in widget.solicitudes)
        if (s.ubicacion != null) s,
    ];

    return Container(
      height: widget.alto,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colores.superficie,
        borderRadius: BorderRadius.circular(Radios.muyGrande),
        border: Border.all(color: Colores.linea),
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: widget.centro,
              initialZoom: _zoomInicial,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.eagledev.tecnicos_app',
              ),
              CapaCirculos(
                circulos: [
                  CircleMarker(
                    point: widget.centro,
                    radius: _radioKm * 1000,
                    useRadiusInMeter: true,
                    color: Colores.primario.withValues(alpha: 0.08),
                    borderColor: Colores.primario,
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  for (final s in cerca)
                    Marker(
                      point: s.ubicacion!,
                      width: 130,
                      height: 80,
                      alignment: Alignment.topCenter,
                      child: _PinSolicitud(
                        oficio: s.oficioNombre,
                        onTap: widget.onTapSolicitud == null
                            ? null
                            : () => widget.onTapSolicitud!(s),
                      ),
                    ),
                  Marker(
                    point: widget.centro,
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colores.primario,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colores.tarjeta, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: Espacios.l,
            left: Espacios.l,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Espacios.m,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colores.tarjeta,
                    borderRadius: BorderRadius.circular(Radios.pildora),
                    border: Border.all(color: Colores.linea),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colores.primario,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Cobertura: $km km · ${cerca.length} '
                        '${cerca.length == 1 ? 'solicitud' : 'solicitudes'}',
                        style: textos.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Espacios.s),
                EtiquetaSector(punto: widget.centro),
              ],
            ),
          ),
          Positioned(
            left: Espacios.l,
            right: Espacios.l,
            bottom: Espacios.l,
            child: ControlRadio(
              km: _radioKm,
              onCambio: (v) => setState(() => _radioKm = v),
              onFin: widget.onCambiarRadio == null
                  ? null
                  : (v) => widget.onCambiarRadio!((v * 1000).round()),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinSolicitud extends StatelessWidget {
  const _PinSolicitud({required this.oficio, this.onTap});

  final String oficio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pin = _contenido(context);
    final onTap = this.onTap;
    if (onTap == null) return pin;
    return Semantics(
      button: true,
      label: 'Ver solicitud de $oficio',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Presionable(escala: 0.92, child: ExcludeSemantics(child: pin)),
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colores.tarjeta,
            borderRadius: BorderRadius.circular(Radios.pildora),
            border: Border.all(color: Colores.linea),
          ),
          child: Text(
            oficio,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.labelSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colores.primarioSuave,
            shape: BoxShape.circle,
            border: Border.all(color: Colores.primario, width: 2),
          ),
          child: const Icon(
            Icons.build_rounded,
            size: 18,
            color: Colores.primarioOscuro,
          ),
        ),
      ],
    );
  }
}
