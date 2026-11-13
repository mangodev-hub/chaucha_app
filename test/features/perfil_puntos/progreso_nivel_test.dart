import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/nivel.dart';

const _niveles = [
  Nivel(nombre: 'Oro', puntosMinimos: 1000),
  Nivel(nombre: 'Bronce', puntosMinimos: 0),
  Nivel(nombre: 'Plata', puntosMinimos: 300),
];

void main() {
  test('calcula lo que falta para el siguiente nivel (aunque vengan '
      'desordenados)', () {
    final p = ProgresoNivel.calcular(150, _niveles);

    expect(p.siguiente?.nombre, 'Plata');
    expect(p.puntosFaltantes, 150);
    expect(p.fraccion, 0.5);
    expect(p.esNivelMaximo, isFalse);
  });

  test('el avance se mide desde el nivel actual', () {
    final p = ProgresoNivel.calcular(650, _niveles);

    expect(p.siguiente?.nombre, 'Oro');
    expect(p.puntosFaltantes, 350);
    expect(p.fraccion, 0.5);
  });

  test('en el nivel más alto no hay siguiente', () {
    final p = ProgresoNivel.calcular(1500, _niveles);

    expect(p.esNivelMaximo, isTrue);
    expect(p.puntosFaltantes, 0);
    expect(p.fraccion, 1);
  });

  test('justo en el mínimo de un nivel empieza en 0', () {
    final p = ProgresoNivel.calcular(300, _niveles);

    expect(p.siguiente?.nombre, 'Oro');
    expect(p.fraccion, 0);
  });
}
