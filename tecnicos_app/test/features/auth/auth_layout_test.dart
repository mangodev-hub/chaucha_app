import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/auth/presentation/widgets/auth_layout.dart';

void main() {
  testWidgets(
    'en escritorio el dibujo del panel no rompe el layout de la pantalla',
    (tester) async {
      tester.view
        ..physicalSize = const Size(1280, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: AuthLayout(
            titulo: 'Iniciar sesión',
            panelDetallado: true,
            child: Text('formulario'),
          ),
        ),
      );
      // Deja que el SVG termine de cargar: el error aparecía recién entonces.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(tester.takeException(), isNull);
      final dibujo = tester.getSize(find.byType(SvgPicture));
      expect(dibujo.width, greaterThan(0));
      expect(dibujo.height, closeTo(dibujo.width * 160 / 460, 0.5));
      expect(find.text('formulario'), findsOneWidget);
    },
  );
}
