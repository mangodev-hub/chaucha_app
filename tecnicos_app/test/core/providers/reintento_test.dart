import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/core/providers/reintento.dart';

void main() {
  group('Reintento.decidir', () {
    test('no reintenta un AppFailure', () {
      expect(Reintento.decidir(0, const AppFailure('Sin permiso')), isNull);
    });

    test('no reintenta un Error de programación', () {
      expect(Reintento.decidir(0, StateError('x')), isNull);
    });

    test('reintenta los demás errores con espera creciente', () {
      final error = Exception('red caída');
      expect(Reintento.decidir(0, error), Reintento.esperaInicial);
      expect(Reintento.decidir(1, error), Reintento.esperaInicial * 2);
      expect(Reintento.decidir(2, error), Reintento.esperaInicial * 4);
    });

    test('se rinde después del máximo', () {
      expect(Reintento.decidir(Reintento.maximo, Exception('red')), isNull);
    });
  });

  test('con la regla, un AppFailure se ve como error al instante', () async {
    final provider = FutureProvider.autoDispose<int>(
      (ref) async => throw const AppFailure('No tienes permiso.'),
    );
    final container = ProviderContainer.test(retry: Reintento.decidir);
    container.listen(provider, (_, _) {});

    await expectLater(
      container.read(provider.future),
      throwsA(isA<AppFailure>()),
    );
    final estado = container.read(provider);
    expect(estado.isLoading, isFalse);
    expect(estado.error, isA<AppFailure>());
  });
}
