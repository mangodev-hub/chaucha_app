import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:tecnicos_app/core/widgets/animacion_lottie.dart';

const _ruta = 'assets/lottie/tecnico.json';

Widget _app({bool reducir = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reducir),
    child: const Center(
      child: AnimacionLottie(ruta: _ruta, alto: 100, proporcion: 0.7),
    ),
  ),
);

void main() {
  testWidgets('reserva su caja desde el primer cuadro', (tester) async {
    await tester.pumpWidget(_app());

    expect(tester.getSize(find.byType(AnimacionLottie)), const Size(70, 100));
  });

  testWidgets('se anima normalmente', (tester) async {
    await tester.pumpWidget(_app());

    final lottie = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
    expect(lottie.animate, isTrue);
  });

  testWidgets('queda quieta si el sistema pide reducir animaciones', (
    tester,
  ) async {
    await tester.pumpWidget(_app(reducir: true));

    final lottie = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
    expect(lottie.animate, isFalse);
  });

  testWidgets('el archivo real carga sin errores', (tester) async {
    await tester.pumpWidget(_app());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  // tecnico_login.json (30 fps, 300 cuadros): idle 0–120, email_in 120–150,
  // email 150–210, password_in 210–240, password 240–300. En progreso (0–1):
  // idle 0–0.4, email_in 0.4–0.5, email 0.5–0.7, password 0.8–1.
  group('por tramos', () {
    Widget appTramo(String tramo, {bool reducir = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reducir),
        child: Center(
          child: AnimacionLottie(
            ruta: 'assets/lottie/tecnico_login.json',
            alto: 100,
            proporcion: 800 / 594,
            tramo: tramo,
          ),
        ),
      ),
    );

    Future<AnimationController> cargar(
      WidgetTester tester,
      String tramo, {
      bool reducir = false,
    }) async {
      await tester.pumpWidget(appTramo(tramo, reducir: reducir));
      // Espera a que el archivo cargue de verdad (el widget interno recibe la
      // composición); onLoaded corre en el pump siguiente.
      for (var i = 0; i < 50; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        await tester.pump();
        if (tester.widget<Lottie>(find.byType(Lottie)).composition != null) {
          break;
        }
      }
      await tester.pump();
      expect(
        tester.widget<Lottie>(find.byType(Lottie)).composition,
        isNotNull,
        reason: 'el archivo no terminó de cargar',
      );
      final lottie = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
      return lottie.controller! as AnimationController;
    }

    testWidgets('idle se repite sin salir de su tramo', (tester) async {
      final controlador = await cargar(tester, 'idle');
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 900));
        expect(controlador.value, inInclusiveRange(0.0, 0.4));
      }
    });

    testWidgets('al pasar a email reproduce la entrada y luego repite email', (
      tester,
    ) async {
      final controlador = await cargar(tester, 'idle');

      await tester.pumpWidget(appTramo('email'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(controlador.value, inInclusiveRange(0.4, 0.5)); // email_in

      await tester.pump(const Duration(seconds: 1));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 700));
        expect(controlador.value, inInclusiveRange(0.5, 0.7)); // email
      }
    });

    testWidgets('un cambio a mitad de la entrada no deja el tramo anterior', (
      tester,
    ) async {
      final controlador = await cargar(tester, 'idle');

      await tester.pumpWidget(appTramo('email'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpWidget(appTramo('password'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 700));
        expect(controlador.value, inInclusiveRange(0.8, 1.0)); // password
      }
    });

    testWidgets('con reducir animaciones queda quieta en la pose del tramo', (
      tester,
    ) async {
      final controlador = await cargar(tester, 'password', reducir: true);
      expect(controlador.value, closeTo(0.8, 0.001));

      await tester.pump(const Duration(seconds: 1));
      expect(controlador.value, closeTo(0.8, 0.001));
    });
  });
}
