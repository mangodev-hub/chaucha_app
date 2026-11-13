import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/publicidad/data/models/anuncio_model.dart';
import 'package:tecnicos_app/features/publicidad/domain/entities/anuncio.dart';

void main() {
  Anuncio leer(Map<String, dynamic> extra) => AnuncioModel.desdeFila({
    'id': 'a1',
    'titulo': 'Almuerzos caseros',
    'descripcion': 'Menú del día a domicilio.',
    ...extra,
  }, urlImagen: (ruta) => 'https://cdn/$ruta');

  test('lee anunciante, categoría e imagen', () {
    final a = leer({
      'anunciante': ' Doña Rosa ',
      'categoria': 'restaurante',
      'imagen_ruta': 'rosa.jpg',
    });
    expect(a.anunciante, 'Doña Rosa');
    expect(a.categoria, CategoriaAnuncio.restaurante);
    expect(a.imagenUrl, 'https://cdn/rosa.jpg');
    expect(a.urlDestino, isNull);
  });

  test('una categoría desconocida cae en "otro"', () {
    expect(leer({'categoria': 'zapateria'}).categoria, CategoriaAnuncio.otro);
  });

  test('los anuncios "general" salen en todas las pantallas', () {
    expect(UbicacionAnuncioDb.general, 'general');
  });
}
