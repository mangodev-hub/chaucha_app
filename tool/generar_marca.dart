// Exporta el logo como imágenes para el ícono de la app, el splash y el
// favicon, pintándolo con el mismo `LogoChaucha` de la app (sin assets
// externos). Se ejecuta como un test, porque pintar a imagen necesita el
// motor de Flutter:
//
//   flutter test tool/generar_marca.dart
//
// Después, para regenerar los íconos nativos y el splash:
//
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/theme/tokens.dart';
import 'package:tecnicos_app/core/widgets/marca.dart';

/// Dibuja un cuadrado de [lado] px con [fondo] (o transparente) y el logo
/// centrado ocupando [proporcion] del lado. [agujero] es el color que se ve
/// por la tuerca; por defecto, el mismo [fondo].
Future<void> _exportar({
  required String ruta,
  required int lado,
  required double proporcion,
  Color? fondo,
  Color? agujero,
  bool sobreOscuro = false,
}) async {
  final grabador = ui.PictureRecorder();
  final canvas = Canvas(grabador);
  final cuadro = Rect.fromLTWH(0, 0, lado.toDouble(), lado.toDouble());
  if (fondo != null) {
    canvas.drawRect(cuadro, Paint()..color = fondo);
  }
  final tamano = lado * proporcion;
  final margen = (lado - tamano) / 2;
  canvas.translate(margen, margen);
  LogoChaucha.pintar(
    canvas,
    Size.square(tamano),
    sobreOscuro: sobreOscuro,
    fondo: agujero ?? fondo,
  );
  final imagen = await grabador.endRecording().toImage(lado, lado);
  final bytes = await imagen.toByteData(format: ui.ImageByteFormat.png);
  final archivo = File(ruta);
  await archivo.parent.create(recursive: true);
  await archivo.writeAsBytes(bytes!.buffer.asUint8List());
}

void main() {
  testWidgets('exporta el ícono, el splash y el favicon', (tester) async {
    await tester.runAsync(() async {
      // Ícono "legacy" y de web: fondo verde bosque, C blanca y tuerca
      // celeste clara. Las esquinas las redondea cada plataforma.
      await _exportar(
        ruta: 'assets/marca/icono_app.png',
        lado: 1024,
        proporcion: 0.72,
        fondo: Colores.primario,
        sobreOscuro: true,
      );
      // Ícono adaptativo de Android: el frente va centrado en la zona
      // segura (66 % del lienzo) sobre transparente; el fondo lo pone el
      // sistema con un color plano (verde bosque).
      await _exportar(
        ruta: 'assets/marca/icono_adaptativo_frente.png',
        lado: 1024,
        proporcion: 0.5,
        sobreOscuro: true,
        agujero: Colores.primario,
      );
      // Splash: el logo sobre el fondo verde suave de la app.
      await _exportar(
        ruta: 'assets/marca/splash.png',
        lado: 1024,
        proporcion: 0.34,
        fondo: Colores.fondo,
      );
      // Favicon de la web, pequeño y sobre blanco.
      await _exportar(
        ruta: 'web/favicon.png',
        lado: 64,
        proporcion: 0.9,
        fondo: Colores.tarjeta,
      );
    });
    expect(File('assets/marca/icono_app.png').existsSync(), isTrue);
  });
}
