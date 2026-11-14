import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/tokens.dart';
import 'capa_circulos.dart';

/// Un punto del mapa. [pin] recibe si está resaltado (mouse sobre su fila)
/// o seleccionado (tocado).
class PuntoMapa {
  const PuntoMapa({
    required this.id,
    required this.ubicacion,
    required this.pin,
    required this.etiqueta,
  });

  final String id;
  final LatLng ubicacion;
  final String etiqueta;
  final Widget Function(bool resaltado, bool seleccionado) pin;
}

class MapaRadio extends StatefulWidget {
  const MapaRadio({
    super.key,
    required this.centro,
    required this.radioM,
    required this.puntos,
    required this.onTocar,
    this.seleccionadoId,
    this.resaltadoId,
    this.tarjeta,
    this.alto = 400,
    this.atenuado,
    this.iconoAtenuado = Icons.verified_user_outlined,
    this.accionAtenuado,
  });

  final LatLng centro;
  final int radioM;
  final List<PuntoMapa> puntos;

  /// Al tocar un punto (su id) o el mapa vacío (null).
  final ValueChanged<String?> onTocar;
  final String? seleccionadoId;
  final String? resaltadoId;

  /// Mini tarjeta flotante del punto seleccionado.
  final Widget? tarjeta;
  final double alto;

  /// Si no es null, el mapa se ve atenuado con este mensaje encima.
  final String? atenuado;

  /// Ícono sobre el mensaje de [atenuado].
  final IconData iconoAtenuado;

  /// Botón bajo el mensaje de [atenuado] ("Marcar mi zona").
  final ({String texto, VoidCallback onTap})? accionAtenuado;

  /// Tamaño del pin de cada punto.
  static const double tamanoPin = 44;

  @override
  State<MapaRadio> createState() => _MapaRadioState();
}

class _MapaRadioState extends State<MapaRadio> {
  final MapController _controller = MapController();
  bool _listo = false;

  @override
  void didUpdateWidget(MapaRadio anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.radioM != widget.radioM || anterior.centro != widget.centro) {
      _ajustar();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Encuadra el círculo del radio con un margen.
  void _ajustar() {
    if (!_listo || widget.radioM <= 0) return;
    final c = widget.centro;
    final dLat = widget.radioM / 111320;
    final dLng =
        widget.radioM / (111320 * math.cos(c.latitude * math.pi / 180));
    _controller.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(c.latitude - dLat, c.longitude - dLng),
          LatLng(c.latitude + dLat, c.longitude + dLng),
        ),
        padding: const EdgeInsets.all(Espacios.l),
      ),
    );
  }

  void _zoom(double delta) {
    final camara = _controller.camera;
    _controller.move(camara.center, (camara.zoom + delta).clamp(3, 18));
  }

  @override
  Widget build(BuildContext context) {
    final tarjeta = widget.tarjeta;
    final atenuado = widget.atenuado;
    return Container(
      height: widget.alto,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colores.superficie,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: widget.centro,
              initialZoom: 12,
              onMapReady: () {
                _listo = true;
                _ajustar();
              },
              onTap: (_, _) => widget.onTocar(null),
              interactionOptions: InteractionOptions(
                flags: atenuado != null
                    ? InteractiveFlag.none
                    : InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.eagledev.tecnicos_app',
              ),
              if (widget.radioM > 0)
                CapaCirculos(
                  circulos: [
                    CircleMarker(
                      point: widget.centro,
                      radius: widget.radioM.toDouble(),
                      useRadiusInMeter: true,
                      color: Colores.cielo.withValues(alpha: 0.15),
                      borderColor: Colores.cielo,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  // Radio 0: aún no hay punto propio (zona sin marcar).
                  if (widget.radioM > 0)
                    Marker(
                      point: widget.centro,
                      width: 48,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: const _MarcadorTu(),
                    ),
                  for (final p in widget.puntos)
                    Marker(
                      point: p.ubicacion,
                      width: MapaRadio.tamanoPin,
                      height: MapaRadio.tamanoPin,
                      child: Semantics(
                        button: true,
                        label: p.etiqueta,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => widget.onTocar(p.id),
                            child: p.pin(
                              p.id == widget.resaltadoId,
                              p.id == widget.seleccionadoId,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (atenuado == null)
            Positioned(
              top: Espacios.m,
              right: Espacios.m,
              child: _Controles(
                onMas: () => _zoom(1),
                onMenos: () => _zoom(-1),
                onCentrar: _ajustar,
              ),
            ),
          if (tarjeta != null && atenuado == null)
            Positioned(
              left: Espacios.m,
              right: Espacios.m,
              bottom: Espacios.m,
              child: tarjeta,
            ),
          if (atenuado != null)
            Positioned.fill(
              child: ColoredBox(
                color: Colores.tarjeta.withValues(alpha: 0.75),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Espacios.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.iconoAtenuado,
                          size: 36,
                          color: Colores.primario,
                        ),
                        const SizedBox(height: Espacios.s),
                        Text(
                          atenuado,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (widget.accionAtenuado case final accion?) ...[
                          const SizedBox(height: Espacios.m),
                          FilledButton(
                            onPressed: accion.onTap,
                            child: Text(accion.texto),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MarcadorTu extends StatelessWidget {
  const _MarcadorTu();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colores.primario,
            borderRadius: BorderRadius.circular(Radios.pildora),
          ),
          child: Text(
            'Tú',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colores.sobreOscuro,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colores.primario,
            shape: BoxShape.circle,
            border: Border.all(color: Colores.tarjeta, width: 3),
          ),
        ),
      ],
    );
  }
}

class _Controles extends StatelessWidget {
  const _Controles({
    required this.onMas,
    required this.onMenos,
    required this.onCentrar,
  });

  final VoidCallback onMas;
  final VoidCallback onMenos;
  final VoidCallback onCentrar;

  @override
  Widget build(BuildContext context) {
    Widget boton(IconData icono, String ayuda, VoidCallback onTap) =>
        IconButton(
          tooltip: ayuda,
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          padding: EdgeInsets.zero,
          icon: Icon(icono, size: 18, color: Colores.tinta),
          onPressed: onTap,
        );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.pequeno),
        boxShadow: Sombras.tarjeta,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          boton(Icons.add, 'Acercar mapa', onMas),
          boton(Icons.remove, 'Alejar mapa', onMenos),
          boton(Icons.my_location, 'Ver todo el radio', onCentrar),
        ],
      ),
    );
  }
}

/// Pin circular con borde blanco de 3 px. Crece al resaltarse o
/// seleccionarse.
class PinCircular extends StatelessWidget {
  const PinCircular({
    super.key,
    required this.child,
    required this.resaltado,
    required this.seleccionado,
    this.color = Colores.primarioSuave,
  });

  final Widget child;
  final bool resaltado;
  final bool seleccionado;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final activo = resaltado || seleccionado;
    return Center(
      child: AnimatedContainer(
        duration: Movimiento.de(context, Movimiento.rapido),
        width: activo ? 44 : 38,
        height: activo ? 44 : 38,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: seleccionado ? Colores.cielo : Colores.tarjeta,
            width: 3,
          ),
          boxShadow: Sombras.tarjeta,
        ),
        child: child,
      ),
    );
  }
}
