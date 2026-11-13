// "En línea" / "Activo hace X" según la presencia (Edge Function + Redis).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/presence/indicador_presencia.dart';
import 'package:tecnicos_app/core/presence/presencia_service.dart';

Future<void> _montar(WidgetTester tester, EstadoPresencia estado) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        estadoPresenciaProvider.overrideWith((ref, id) async => estado),
      ],
      child: const MaterialApp(
        home: Scaffold(body: IndicadorPresencia(usuarioId: 'u1')),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('en línea', (tester) async {
    await _montar(tester, const EstadoPresencia(enLinea: true));
    expect(find.text('En línea'), findsOneWidget);
  });

  testWidgets('desconectado hace poco: "Activo hace X"', (tester) async {
    await _montar(
      tester,
      EstadoPresencia(
        enLinea: false,
        visto: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    );
    expect(find.text('Activo hace 5 min'), findsOneWidget);
  });

  testWidgets('sin datos no muestra nada', (tester) async {
    await _montar(tester, EstadoPresencia.desconocido);
    expect(find.byType(Text), findsNothing);
  });
}
