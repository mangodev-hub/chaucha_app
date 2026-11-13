import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/theme/tokens.dart';
import 'package:tecnicos_app/core/widgets/cabecera_cielo.dart';
import 'package:tecnicos_app/core/widgets/fila_dato.dart';
import 'package:tecnicos_app/core/widgets/pildora.dart';

Widget _envolver(Widget hijo) => MaterialApp(
  home: Scaffold(body: Center(child: hijo)),
);

void main() {
  testWidgets('FilaDato muestra etiqueta, valor, detalle y trailing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _envolver(
        const Column(
          children: [
            FilaDato(etiqueta: 'Precio de la visita', valor: r'$15,00'),
            FilaDato(
              icono: Icons.receipt_long_outlined,
              etiqueta: r'Ticket: $15,00',
              detalle: 'Visita: mar 24/11/2026 · 10:00',
              trailing: Pildora(texto: 'Confirmado', color: Colores.acento),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Precio de la visita'), findsOneWidget);
    expect(find.text(r'$15,00'), findsOneWidget);
    expect(find.text('Visita: mar 24/11/2026 · 10:00'), findsOneWidget);
    expect(find.text('Confirmado'), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);

    // El valor va en celeste oscuro: es información, no acción.
    final valor = tester.widget<Text>(find.text(r'$15,00'));
    expect(valor.style?.color, Colores.cieloOscuro);
  });

  testWidgets('CabeceraCielo muestra título, subtítulo, píldora y contenido', (
    tester,
  ) async {
    await tester.pumpWidget(
      _envolver(
        const CabeceraCielo(
          titulo: 'Plomería',
          subtitulo: 'Publicada el 12/11/2026',
          pildora: Pildora(texto: 'Aceptada', color: Colores.acento),
          child: Text('Fuga bajo el lavaplatos'),
        ),
      ),
    );

    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('Publicada el 12/11/2026'), findsOneWidget);
    expect(find.text('Aceptada'), findsOneWidget);
    expect(find.text('Fuga bajo el lavaplatos'), findsOneWidget);

    final titulo = tester.widget<Text>(find.text('Plomería'));
    expect(titulo.style?.color, Colores.tinta);
  });
}
