import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/widgets/resena_dialog.dart';

void main() {
  testWidgets('elegir estrellas muestra las etiquetas y devuelve la reseña', (
    tester,
  ) async {
    DatosResena? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                resultado = await mostrarDialogoResena(
                  context,
                  nombre: 'Ana',
                  paraTecnico: true,
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

    // Sin estrellas no hay etiquetas ni se puede calificar.
    expect(find.text('¿Cómo calificas al técnico?'), findsOneWidget);
    expect(find.text('¿Qué fue lo mejor?'), findsNothing);
    final boton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(boton.onPressed, isNull);

    await tester.tap(find.byTooltip('4 estrellas'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué fue lo mejor?'), findsOneWidget);
    expect(find.text('Puntual'), findsOneWidget);

    await tester.tap(find.text('Puntual'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calificar técnico'));
    await tester.pumpAndSettle();

    expect(resultado?.estrellas, 4);
    expect(resultado?.etiquetas, ['Puntual']);
    expect(resultado?.comentario, isNull);
  });

  test('las etiquetas cambian según la nota y a quién se califica', () {
    expect(
      EtiquetasResena.para(paraTecnico: true, estrellas: 5),
      contains('Trabajo limpio'),
    );
    expect(
      EtiquetasResena.para(paraTecnico: true, estrellas: 2),
      contains('Llegó tarde'),
    );
    expect(
      EtiquetasResena.para(paraTecnico: false, estrellas: 4),
      contains('Amable'),
    );
    expect(
      EtiquetasResena.para(paraTecnico: false, estrellas: 1),
      contains('Problema mal descrito'),
    );
  });
}
