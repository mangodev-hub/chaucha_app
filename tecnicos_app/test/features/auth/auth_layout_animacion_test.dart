import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/widgets/animacion_lottie.dart';
import 'package:tecnicos_app/core/widgets/tarjeta_app.dart';
import 'package:tecnicos_app/features/auth/presentation/widgets/auth_layout.dart';

Future<void> _mostrar(WidgetTester tester, Size pantalla) async {
  tester.view
    ..physicalSize = pantalla
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const MaterialApp(
      home: AuthLayout(
        titulo: 'Iniciar sesión',
        tituloCentrado: true,
        panelDetallado: true,
        animacionEscritorio: 'assets/lottie/tecnico.json',
        animacionMovil: 'assets/lottie/tecnico_login.json',
        tramoAnimacion: 'idle',
        child: SizedBox(height: 300, child: Text('formulario')),
      ),
    ),
  );
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pump();
}

void main() {
  testWidgets('en escritorio la animación reemplaza al dibujo del panel', (
    tester,
  ) async {
    await _mostrar(tester, const Size(1280, 800));

    expect(tester.takeException(), isNull);
    expect(find.byType(AnimacionLottie), findsOneWidget);
    expect(find.byType(SvgPicture), findsNothing);
    // En escritorio va el técnico que saluda, repitiéndose entero.
    final lottie = tester.widget<AnimacionLottie>(find.byType(AnimacionLottie));
    expect(lottie.ruta, 'assets/lottie/tecnico.json');
    expect(lottie.tramo, isNull);
    // Queda en el panel azul (mitad izquierda), lejos del formulario.
    final animacion = tester.getCenter(find.byType(AnimacionLottie));
    final formulario = tester.getCenter(find.text('formulario'));
    expect(animacion.dx, lessThan(640));
    expect(formulario.dx, greaterThan(640));
  });

  testWidgets(
    'en móvil el personaje queda apoyado sobre el borde de la tarjeta',
    (tester) async {
      await _mostrar(tester, const Size(390, 844));

      expect(tester.takeException(), isNull);
      // En móvil va el técnico del login, controlado por tramos.
      final lottie = tester.widget<AnimacionLottie>(
        find.byType(AnimacionLottie),
      );
      expect(lottie.ruta, 'assets/lottie/tecnico_login.json');
      expect(lottie.tramo, 'idle');

      final marca = tester.getRect(find.text('ChauchaApp'));
      final personaje = tester.getRect(find.byType(AnimacionLottie));
      final tarjeta = tester.getRect(find.byType(TarjetaApp));
      final titulo = tester.getRect(find.text('Iniciar sesión'));
      final formulario = tester.getRect(find.text('formulario'));

      // Orden: logo, personaje, título y campos.
      expect(marca.bottom, lessThanOrEqualTo(personaje.top + 1));
      expect(titulo.top, greaterThanOrEqualTo(personaje.bottom));
      expect(formulario.top, greaterThan(titulo.bottom));
      // El borde superior de la tarjeta cae donde apoya los antebrazos.
      expect(tarjeta.top, closeTo(personaje.top + personaje.height * 0.96, 1));
      // Centrado sobre la tarjeta.
      expect(personaje.center.dx, closeTo(tarjeta.center.dx, 1));
    },
  );

  testWidgets('en una pantalla baja no desborda (se baja con scroll)', (
    tester,
  ) async {
    await _mostrar(tester, const Size(390, 500));

    expect(tester.takeException(), isNull);
    expect(find.byType(AnimacionLottie), findsOneWidget);
  });
}
