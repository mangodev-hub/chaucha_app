import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/widgets/resena_dialog.dart';

void main() {
  testWidgets('elegir estrellas actualiza la etiqueta y devuelve la reseña', (
    tester,
  ) async {
    DatosResena? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                resultado = await mostrarDialogoResena(context, nombre: 'Ana');
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Toca una estrella'), findsOneWidget);

    await tester.tap(find.byTooltip('4 de 5'));
    await tester.pumpAndSettle();
    expect(find.text('Muy bueno'), findsOneWidget);
    expect(find.text('Toca una estrella'), findsNothing);
    expect(
      find.byIcon(Icons.star_rounded),
      findsNWidgets(5),
    ); // 4 + ícono del título
    expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);

    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    expect(resultado?.estrellas, 4);
    expect(resultado?.comentario, isNull);
  });
}
