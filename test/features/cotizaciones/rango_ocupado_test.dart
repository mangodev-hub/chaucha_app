import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/rango_ocupado.dart';

void main() {
  final rango = RangoOcupado(
    inicio: DateTime(2026, 11, 24, 11),
    fin: DateTime(2026, 11, 24, 12),
  );
  const hora = Duration(hours: 1);

  test('la misma hora se cruza', () {
    expect(rango.seCruzaCon(DateTime(2026, 11, 24, 11), hora), isTrue);
  });

  test('una franja que empieza a mitad de la visita se cruza', () {
    expect(rango.seCruzaCon(DateTime(2026, 11, 24, 11, 30), hora), isTrue);
  });

  test('una franja que termina justo cuando empieza la visita no se cruza', () {
    expect(rango.seCruzaCon(DateTime(2026, 11, 24, 10), hora), isFalse);
  });

  test('una franja que empieza justo cuando termina la visita no se cruza', () {
    expect(rango.seCruzaCon(DateTime(2026, 11, 24, 12), hora), isFalse);
  });
}