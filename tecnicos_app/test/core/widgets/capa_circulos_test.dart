// CapaCirculos espera a que la cámara del mapa tenga tamaño real y después
// dibuja el círculo como un CircleLayer normal.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/core/widgets/capa_circulos.dart';

void main() {
  testWidgets('con el mapa medido dibuja el círculo sin errores', (
    tester,
  ) async {
    const centro = LatLng(-0.18, -78.48);
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 400,
          height: 300,
          child: FlutterMap(
            options: MapOptions(initialCenter: centro, initialZoom: 12.5),
            children: [
              CapaCirculos(
                circulos: [
                  CircleMarker(
                    point: centro,
                    radius: 5000,
                    useRadiusInMeter: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(CircleLayer), findsOneWidget);
  });
}
