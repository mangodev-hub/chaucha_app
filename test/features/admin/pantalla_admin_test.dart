import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/widgets/scroll_pagina.dart';
import 'package:tecnicos_app/features/admin/presentation/widgets/admin_widgets.dart';

Widget _pantalla() => PantallaAdmin(
  titulo: 'Usuarios',
  subtitulo: 'Clientes, técnicos y administradores.',
  onRecargar: () async {},
  children: [for (var i = 0; i < 30; i++) Text('fila $i')],
);

void main() {
  testWidgets('sola tiene su propio scroll', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: _pantalla())));

    expect(tester.takeException(), isNull);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('en la web clara va sin scroll propio', (tester) async {
    tester.view
      ..physicalSize = const Size(1920, 1080)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ScrollDePagina(child: _pantalla()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ListView), findsNothing);
    expect(find.text('fila 29'), findsOneWidget);
  });
}
