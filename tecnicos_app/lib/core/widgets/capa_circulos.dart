// Capa de círculos del mapa (radio de búsqueda, zona de trabajo) que no se
// dibuja hasta que la cámara tiene un tamaño real.
//
// Antes de recibir sus medidas, la cámara de flutter_map usa un tamaño
// "imposible" (−∞ × −∞). Si un `CircleLayer` con `useRadiusInMeter` se pinta
// en ese momento (pasa en web), el radio en píxeles sale NaN, el círculo
// parece visible en todas las copias del mundo y flutter_map corta con la
// aserción "Infinite loop going beyond 30 for world width ...". Esperar un
// cuadro a que llegue el tamaño lo evita sin que se note.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class CapaCirculos extends StatelessWidget {
  const CapaCirculos({super.key, required this.circulos});

  final List<CircleMarker> circulos;

  @override
  Widget build(BuildContext context) {
    final tamano = MapCamera.of(context).nonRotatedSize;
    final medida =
        tamano.width.isFinite &&
        tamano.height.isFinite &&
        tamano.width > 0 &&
        tamano.height > 0;
    if (!medida) return const SizedBox.shrink();
    return CircleLayer(circles: circulos);
  }
}
