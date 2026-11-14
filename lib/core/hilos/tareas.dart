// Tareas que corren fuera del hilo de la interfaz: isolates en Android/iOS y
// Web Workers en web (`dart run isolate_manager:generate` los compila a
// web/*.js). No pueden usar Flutter, solo Dart puro.
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:isolate_manager/isolate_manager.dart';

/// Ancho máximo de las fotos que se suben.
const int anchoMaximoFoto = 1280;

/// Varianza del Laplaciano: por debajo del umbral, la foto está borrosa.
@pragma('vm:entry-point')
@isolateManagerWorker
bool esNitida(Uint8List bytes) {
  final base = img.decodeImage(bytes);
  if (base == null) return false;
  final g = img.grayscale(img.copyResize(base, width: 400));
  double suma = 0, suma2 = 0;
  var n = 0;
  for (var y = 1; y < g.height - 1; y++) {
    for (var x = 1; x < g.width - 1; x++) {
      final l =
          g.getPixel(x, y - 1).r +
          g.getPixel(x, y + 1).r +
          g.getPixel(x - 1, y).r +
          g.getPixel(x + 1, y).r -
          4 * g.getPixel(x, y).r;
      suma += l;
      suma2 += l * l;
      n++;
    }
  }
  final media = suma / n;
  return (suma2 / n - media * media) > 100;
}

/// Endereza la foto según su EXIF, la reduce y la deja en JPEG. Si no se
/// puede leer, devuelve los mismos bytes.
@pragma('vm:entry-point')
@isolateManagerWorker
Uint8List prepararFoto(Uint8List bytes) {
  final base = img.decodeImage(bytes);
  if (base == null) return bytes;
  var foto = img.bakeOrientation(base);
  if (foto.width > anchoMaximoFoto) {
    foto = img.copyResize(foto, width: anchoMaximoFoto);
  }
  return img.encodeJpg(foto, quality: 82);
}
