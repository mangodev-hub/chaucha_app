import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/tokens.dart';
import '../../../auth/presentation/widgets/mapa_tecnicos.dart';
import '../../domain/entities/solicitud.dart';

class MapaZonaTecnico extends StatefulWidget {
  const MapaZonaTecnico({
    super.key,
    required this.centro,
    required this.radioM,
    required this.solicitudes,
    this.onCambiarRadio,
    this.alto = 380,
  });

  final LatLng centro;
  final int radioM;
  final List<Solicitud> solicitudes;
  final double alto;
  final ValueChanged<int>? onCambiarRadio;

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
        boxShadow: Sombras.suave,
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: widget.centro,
              initialZoom: _zoomInicial,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all &
                    ~InteractiveFlag.rotate &
                    ~InteractiveFlag.scrollWheelZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.eagledev.tecnicos_app',
              ),
              CircleLayer(
                circles: [
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
                      child: _PinSolicitud(oficio: s.oficioNombre),
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
                        boxShadow: Sombras.suave,
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
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Espacios.m,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colores.tarjeta,
                borderRadius: BorderRadius.circular(Radios.pildora),
                boxShadow: Sombras.suave,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 8, color: Colores.primario),
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
  const _PinSolicitud({required this.oficio});

  final String oficio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colores.tarjeta,
            borderRadius: BorderRadius.circular(Radios.pildora),
            boxShadow: Sombras.suave,
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
            boxShadow: Sombras.suave,
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