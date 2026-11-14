import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/core/widgets/capa_circulos.dart';

void main() {
  testWidgets('dibuja el relleno y el borde del círculo sin errores', (
    tester,
  ) async {
    const centro = LatLng(-0.18, -78.48);
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
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
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(CircleLayer), findsNothing);
    final pintura = find.descendant(
      of: find.byType(CapaCirculos),
      matching: find.byType(CustomPaint),
    );
    expect(pintura, findsOneWidget);
    // Relleno y borde, centrados en el mapa (400 × 300).
    expect(
      tester.renderObject(pintura),
      paints
        ..circle(x: 200, y: 150)
        ..circle(x: 200, y: 150, style: PaintingStyle.stroke),
    );
  });
}
