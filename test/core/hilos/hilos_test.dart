// Los Web Workers necesitan web/*.js servido: en web se prueban con la app.
@TestOn('vm')
library;

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:tecnicos_app/core/hilos/hilos.dart';
import 'package:tecnicos_app/core/hilos/tareas.dart';

Uint8List _foto({int ancho = 2000, int alto = 1000, bool ruido = true}) {
  final azar = Random(1);
  final imagen = img.Image(width: ancho, height: alto);
  for (final p in imagen) {
    final v = ruido ? azar.nextInt(256) : 128;
    p
      ..r = v
      ..g = v
      ..b = v;
  }
  return img.encodePng(imagen);
}

void main() {
  test('prepararFoto reduce el ancho y deja JPEG', () async {
    final salida = await Hilos.prepararFoto(_foto());
    final leida = img.decodeImage(salida)!;
    expect(leida.width, anchoMaximoFoto);
    expect(salida.sublist(0, 2), [0xff, 0xd8]);
  });

  test('una foto pequeña no se agranda', () async {
    final salida = await Hilos.prepararFoto(_foto(ancho: 600, alto: 400));
    expect(img.decodeImage(salida)!.width, 600);
  });

  test('varias fotos se preparan en paralelo', () async {
    final fotos = List.generate(4, (_) => _foto(ancho: 1600, alto: 800));
    final salidas = await Hilos.prepararFotos(fotos);
    expect(salidas, hasLength(4));
    for (final s in salidas) {
      expect(img.decodeImage(s)!.width, anchoMaximoFoto);
    }
  });

  test('nitidez: ruido es nítido, un color plano no', () async {
    expect(await Hilos.esNitida(_foto(ancho: 800, alto: 600)), isTrue);
    expect(
      await Hilos.esNitida(_foto(ancho: 800, alto: 600, ruido: false)),
      isFalse,
    );
  });

  test('bytes que no son imagen vuelven igual', () async {
    final basura = Uint8List.fromList([1, 2, 3]);
    expect(await Hilos.prepararFoto(basura), basura);
  });
}
