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
