// Mapa OpenStreetMap con un pin.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/tokens.dart';
import 'capa_circulos.dart';
import 'etiqueta_sector.dart';

class MapaUbicacion extends StatefulWidget {
  const MapaUbicacion({
    super.key,
    required this.punto,
    this.onCambio,
    this.radioMetros,
    this.otrosPuntos = const [],
    this.altura = 280,
    this.zoom = 15,
    this.mostrarSector = false,
    this.colorMarcador,
    this.colorRadio,
  });

  final LatLng punto;
  final ValueChanged<LatLng>? onCambio;
  final double? radioMetros;
  final List<LatLng> otrosPuntos;
  final double altura;
  final double zoom;

  /// Muestra sobre el mapa el sector (barrio) del punto.
  final bool mostrarSector;

  /// Color del pin; por defecto, el de error del tema.
  final Color? colorMarcador;

  /// Color del círculo del radio; por defecto, el primario del tema.
  final Color? colorRadio;

  @override
  State<MapaUbicacion> createState() => _MapaUbicacionState();
}

class _MapaUbicacionState extends State<MapaUbicacion> {
  final MapController _controller = MapController();

  @override
  void didUpdateWidget(covariant MapaUbicacion anterior) {
    super.didUpdateWidget(anterior);

    if (anterior.punto != widget.punto) {
      _controller.move(widget.punto, _controller.camera.zoom);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final radio = widget.radioMetros;
    return SizedBox(
      height: widget.altura,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radios.medio),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: widget.punto,
                initialZoom: widget.zoom,
                onTap: widget.onCambio == null
                    ? null
                    : (_, punto) => widget.onCambio!(punto),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.eagledev.tecnicos_app',
                ),
                if (radio != null)
                  CapaCirculos(
                    circulos: [
                      CircleMarker(
                        point: widget.punto,
                        radius: radio,
                        useRadiusInMeter: true,
                        color: (widget.colorRadio ?? colores.primary)
                            .withValues(alpha: 0.15),
                        borderColor: widget.colorRadio ?? colores.primary,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    for (final otro in widget.otrosPuntos)
                      Marker(
                        point: otro,
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.place,
                          color: colores.tertiary,
                          size: 32,
                        ),
                      ),
                    Marker(
                      point: widget.punto,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.location_pin,
                        color: widget.colorMarcador ?? colores.error,
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.mostrarSector)
              Positioned(
                top: 8,
                left: 8,
                child: EtiquetaSector(punto: widget.punto),
              ),
          ],
        ),
      ),
    );
  }
}
