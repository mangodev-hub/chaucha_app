import 'dart:typed_data';

import 'package:image/image.dart' as img;

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
