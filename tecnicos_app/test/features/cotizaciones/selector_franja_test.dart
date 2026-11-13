import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/rango_ocupado.dart';
import 'package:tecnicos_app/features/cotizaciones/presentation/widgets/selector_franja.dart';

void main() {
  testWidgets('bloquea las franjas ocupadas y arma el texto de confirmación', (
    tester,
  ) async {
    final manana = DateUtils.dateOnly(
      DateTime.now().add(const Duration(days: 1)),
    );
    final ocupada = DateTime(manana.year, manana.month, manana.day, 10);
    DateTime? elegida;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                elegida = await elegirFranja(
                  context,
                  inicial: manana,
                  cargarOcupados: (_, _) async => [
                    RangoOcupado(
                      inicio: ocupada,
                      fin: ocupada.add(const Duration(hours: 1)),
                    ),
                  ],
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    // Sin elegir, el botón pide una franja y está desactivado.
    final boton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(boton.onPressed, isNull);
    expect(find.text('Elige una franja libre'), findsOneWidget);

    // La franja que choca con otra visita queda bloqueada.
    expect(
      find.bySemanticsLabel('10:00, ocupada por otra visita'),
      findsOneWidget,
    );
    await tester.tap(find.text('10:00'));
    await tester.pumpAndSettle();
    expect(find.text('Elige una franja libre'), findsOneWidget);

    // Una libre se elige y el botón dice qué se va a confirmar.
    await tester.ensureVisible(find.text('11:00'));
    await tester.tap(find.text('11:00'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Confirmar'), findsOneWidget);
    expect(find.textContaining('11:00 a 12:00'), findsOneWidget);

    await tester.tap(find.textContaining('Confirmar'));
    await tester.pumpAndSettle();
    expect(elegida, DateTime(manana.year, manana.month, manana.day, 11));
  });
}
