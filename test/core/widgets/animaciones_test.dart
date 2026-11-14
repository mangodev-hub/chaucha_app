import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/theme/tokens.dart';
import 'package:tecnicos_app/core/widgets/boton_carga.dart';
import 'package:tecnicos_app/core/widgets/campos.dart';
import 'package:tecnicos_app/core/widgets/check_animado.dart';
import 'package:tecnicos_app/core/widgets/estado_mensaje.dart';
import 'package:tecnicos_app/core/widgets/pildora.dart';
import 'package:tecnicos_app/core/widgets/presionable.dart';
import 'package:tecnicos_app/core/widgets/sacudir.dart';
import 'package:tecnicos_app/core/widgets/tarjeta_app.dart';

Widget _envolver(Widget child, {bool sinAnimaciones = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: sinAnimaciones),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('Movimiento.de', () {
    Future<Duration> duracionCon(
      WidgetTester tester, {
      required bool sinAnimaciones,
    }) async {
      late Duration duracion;
      await tester.pumpWidget(
        _envolver(
          Builder(
            builder: (context) {
              duracion = Movimiento.de(context, Movimiento.normal);
              return const SizedBox();
            },
          ),
          sinAnimaciones: sinAnimaciones,
        ),
      );
      return duracion;
    }

    testWidgets('devuelve la duración pedida', (tester) async {
      expect(
        await duracionCon(tester, sinAnimaciones: false),
        Movimiento.normal,
      );
    });

    testWidgets('devuelve cero si el sistema reduce animaciones', (
      tester,
    ) async {
      expect(await duracionCon(tester, sinAnimaciones: true), Duration.zero);
    });
  });

  group('BotonCarga', () {
    Widget boton({required bool cargando, VoidCallback? onPressed}) =>
        _envolver(
          BotonCarga(
            texto: 'Enviar',
            icono: Icons.send,
            cargando: cargando,
            onPressed: onPressed,
          ),
        );

    testWidgets('pasa del texto al indicador y vuelve', (tester) async {
      var toques = 0;
      await tester.pumpWidget(
        boton(cargando: false, onPressed: () => toques++),
      );
      expect(find.text('Enviar'), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);

      await tester.pumpWidget(boton(cargando: true, onPressed: () => toques++));
      // El indicador gira sin fin: no sirve pumpAndSettle.
      await tester.pump(Movimiento.normal);
      await tester.pump(Movimiento.normal);
      expect(find.text('Enviar'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      expect(toques, 0, reason: 'mientras carga el botón está desactivado');

      await tester.pumpWidget(
        boton(cargando: false, onPressed: () => toques++),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.tap(find.byType(FilledButton));
      expect(toques, 1);
    });
  });

  testWidgets('CampoContrasena alterna el ojo', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _envolver(
        SizedBox(width: 300, child: CampoContrasena(controller: controller)),
      ),
    );
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    await tester.tap(find.byTooltip('Mostrar contraseña'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);
  });

  testWidgets('Pildora anima el cambio de estado sin duplicar el texto', (
    tester,
  ) async {
    await tester.pumpWidget(
      _envolver(const Pildora(texto: 'Pendiente', color: Colores.aviso)),
    );
    await tester.pumpWidget(
      _envolver(const Pildora(texto: 'Aceptada', color: Colores.acento)),
    );
    await tester.pump(Movimiento.normal ~/ 2);
    // A mitad de la transición conviven los dos textos.
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.text('Aceptada'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Pendiente'), findsNothing);
    expect(find.text('Aceptada'), findsOneWidget);
  });

  group('CheckAnimado', () {
    testWidgets('termina su animación', (tester) async {
      await tester.pumpWidget(_envolver(const CheckAnimado()));
      await tester.pumpAndSettle();
      expect(find.byType(CheckAnimado), findsOneWidget);
    });

    testWidgets('sin animaciones queda listo en un solo cuadro', (
      tester,
    ) async {
      await tester.pumpWidget(
        _envolver(const CheckAnimado(), sinAnimaciones: true),
      );
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('con etiqueta se anuncia a los lectores de pantalla', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(
        _envolver(const CheckAnimado(etiqueta: 'Verificado')),
      );
      expect(find.bySemanticsLabel('Verificado'), findsOneWidget);
      semantica.dispose();
    });
  });

  group('EstadoMensaje', () {
    testWidgets('el tipo éxito muestra el check animado', (tester) async {
      await tester.pumpWidget(
        _envolver(
          const EstadoMensaje(
            icono: Icons.mark_email_read_outlined,
            tipo: TipoEstado.exito,
            mensaje: 'Listo',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CheckAnimado), findsOneWidget);
      expect(find.text('Listo'), findsOneWidget);
    });

    testWidgets('los demás tipos no lo muestran', (tester) async {
      await tester.pumpWidget(
        _envolver(
          const EstadoMensaje(icono: Icons.inbox_outlined, mensaje: 'Vacío'),
        ),
      );
      expect(find.byType(CheckAnimado), findsNothing);
    });
  });

  group('Sacudir', () {
    Widget sacudir(int senal, {bool sinAnimaciones = false}) => _envolver(
      Sacudir(senal: senal, child: const Text('Botón')),
      sinAnimaciones: sinAnimaciones,
    );

    double desplazamiento(WidgetTester tester) => tester
        .widget<Transform>(
          find.ancestor(
            of: find.text('Botón'),
            matching: find.byType(Transform),
          ),
        )
        .transform
        .getTranslation()
        .x;

    testWidgets('se mueve al cambiar la señal y vuelve a su lugar', (
      tester,
    ) async {
      await tester.pumpWidget(sacudir(0));
      expect(desplazamiento(tester), 0);

      await tester.pumpWidget(sacudir(1));
      await tester.pump(const Duration(milliseconds: 50));
      expect(desplazamiento(tester), isNot(0));

      await tester.pumpAndSettle();
      expect(desplazamiento(tester), 0);
    });

    testWidgets('no se mueve si el sistema reduce animaciones', (tester) async {
      await tester.pumpWidget(sacudir(0, sinAnimaciones: true));
      await tester.pumpWidget(sacudir(1, sinAnimaciones: true));
      await tester.pump();
      expect(desplazamiento(tester), 0);
    });
  });

  group('Presionable', () {
    double escala(WidgetTester tester) =>
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

    testWidgets('se encoge mientras se presiona y vuelve al soltar', (
      tester,
    ) async {
      await tester.pumpWidget(_envolver(const Presionable(child: _Caja())));
      final gesto = await tester.startGesture(
        tester.getCenter(find.byType(Presionable)),
      );
      await tester.pump();
      expect(escala(tester), 0.97);

      await gesto.up();
      await tester.pump();
      expect(escala(tester), 1);
    });

    testWidgets('se suelta si el dedo se arrastra (scroll)', (tester) async {
      await tester.pumpWidget(_envolver(const Presionable(child: _Caja())));
      final gesto = await tester.startGesture(
        tester.getCenter(find.byType(Presionable)),
      );
      await tester.pump();
      await gesto.moveBy(const Offset(0, 30));
      await tester.pump();
      expect(escala(tester), 1);
      await gesto.up();
    });

    testWidgets('desactivado no reacciona', (tester) async {
      await tester.pumpWidget(
        _envolver(const Presionable(activo: false, child: _Caja())),
      );
      final gesto = await tester.startGesture(
        tester.getCenter(find.byType(Presionable)),
      );
      await tester.pump();
      expect(escala(tester), 1);
      await gesto.up();
    });

    testWidgets('TarjetaApp solo es presionable si tiene onTap', (
      tester,
    ) async {
      await tester.pumpWidget(_envolver(const TarjetaApp(child: Text('A'))));
      expect(find.byType(Presionable), findsNothing);

      var toques = 0;
      await tester.pumpWidget(
        _envolver(TarjetaApp(onTap: () => toques++, child: const Text('A'))),
      );
      expect(find.byType(Presionable), findsOneWidget);
      await tester.tap(find.text('A'));
      expect(toques, 1, reason: 'la animación no bloquea el toque');
    });
  });
}

/// Caja que sí recibe toques (un SizedBox vacío no los recibe).
class _Caja extends StatelessWidget {
  const _Caja();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Colores.primario,
    child: SizedBox.square(dimension: 100),
  );
}
