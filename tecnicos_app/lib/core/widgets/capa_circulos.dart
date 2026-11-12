// Capa de círculos del mapa (radio de búsqueda, zona de trabajo), pintada
// por la app en lugar de con el `CircleLayer` de flutter_map.
//
// En Flutter web (desde 3.47), las capas de figuras de flutter_map 8.x
// fallan al repetir el dibujo en las copias del mundo: lanzan "Infinite loop
// going beyond 30 for world width ..." y el mapa deja de dibujarse
// (https://github.com/fleaflet/flutter_map/issues/2234, abierto). Aquí cada
// círculo se pinta una sola vez, en su posición, con la cámara del mapa: es
// lo único que necesitan estos mapas (zonas de unos pocos km en Quito).
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CapaCirculos extends StatelessWidget {
  const CapaCirculos({super.key, required this.circulos});

  final List<CircleMarker> circulos;

  @override
  Widget build(BuildContext context) {
    final camara = MapCamera.of(context);
    final tamano = camara.nonRotatedSize;
    // Antes de recibir sus medidas, la cámara usa un tamaño "imposible"
    // (−∞ × −∞): no hay nada que pintar todavía.
    final medida =
        tamano.width.isFinite &&
        tamano.height.isFinite &&
        tamano.width > 0 &&
        tamano.height > 0;
    if (!medida) return const SizedBox.shrink();
    return MobileLayerTransformer(
      child: IgnorePointer(
        child: CustomPaint(
          size: camara.size,
          painter: _PintorCirculos(circulos: circulos, camara: camara),
        ),
      ),
    );
  }
}

class _PintorCirculos extends CustomPainter {
  const _PintorCirculos({required this.circulos, required this.camara});

  final List<CircleMarker> circulos;
  final MapCamera camara;

  static const _distancia = Distance();

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in circulos) {
      final centro = camara.getOffsetFromOrigin(c.point);
      final radio = c.useRadiusInMeter
          ? (centro -
                    camara.getOffsetFromOrigin(
                      _distancia.offset(c.point, c.radius, 180),
                    ))
                .distance
          : c.radius;
      if (!centro.isFinite || !radio.isFinite || radio <= 0) continue;

      canvas.drawCircle(centro, radio, Paint()..color = c.color);
      if (c.borderStrokeWidth > 0) {
        canvas.drawCircle(
          centro,
          radio,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = c.borderStrokeWidth
            ..color = c.borderColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_PintorCirculos anterior) =>
      anterior.camara != camara || anterior.circulos != circulos;
}
