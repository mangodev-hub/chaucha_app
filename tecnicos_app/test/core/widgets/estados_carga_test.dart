import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/widgets/async_value_view.dart';
import 'package:tecnicos_app/core/widgets/esqueleto_carga.dart';
import 'package:tecnicos_app/core/widgets/estado_mensaje.dart';

Widget _envolver(Widget child, {bool sinAnimaciones = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: sinAnimaciones),
    child: Scaffold(body: child),
  ),
);

void main() {
  group('EsqueletoCarga', () {
    testWidgets('late mientras está en pantalla', (tester) async {
      await tester.pumpWidget(
        _envolver(const EsqueletoCarga(child: BloqueEsqueleto(alto: 20))),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(BloqueEsqueleto), findsOneWidget);
      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('queda quieto si el sistema reduce animaciones', (
      tester,
    ) async {
      await tester.pumpWidget(
        _envolver(
          const EsqueletoCarga(child: BloqueEsqueleto(alto: 20)),
          sinAnimaciones: true,
        ),
      );
      await tester.pump();

      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('los lectores de pantalla anuncian la etiqueta', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(
        _envolver(
          const EsqueletoCarga(
            etiqueta: 'Cargando la solicitud',
            child: BloqueEsqueleto(alto: 20),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Cargando la solicitud'), findsOneWidget);
      semantica.dispose();
    });
  });

  group('AsyncValueView', () {
    testWidgets('mientras carga muestra el spinner por defecto', (
      tester,
    ) async {
      await tester.pumpWidget(
        _envolver(
          AsyncValueView<int>(
            value: const AsyncLoading(),
            onData: (_, _) => const SizedBox(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('o la carga propia si se la pasan', (tester) async {
      await tester.pumpWidget(
        _envolver(
          AsyncValueView<int>(
            value: const AsyncLoading(),
            cargando: (_) => const Text('esqueleto'),
            onData: (_, _) => const SizedBox(),
          ),
        ),
      );
      expect(find.text('esqueleto'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('EstadoMensaje', () {
    testWidgets('muestra la acción secundaria debajo de la principal', (
      tester,
    ) async {
      var principal = 0;
      var secundaria = 0;
      await tester.pumpWidget(
        _envolver(
          EstadoMensaje(
            icono: Icons.cloud_off_outlined,
            tipo: TipoEstado.error,
            mensaje: 'Falló',
            textoAccion: 'Reintentar',
            onAccion: () => principal++,
            textoAccionSecundaria: 'Regresar',
            onAccionSecundaria: () => secundaria++,
          ),
        ),
      );

      await tester.tap(find.text('Regresar'));
      await tester.tap(find.text('Reintentar'));
      expect((principal, secundaria), (1, 1));
      expect(
        tester.getTopLeft(find.text('Regresar')).dy,
        greaterThan(tester.getTopLeft(find.text('Reintentar')).dy),
      );
    });

    testWidgets('la versión compacta no muestra la secundaria', (tester) async {
      await tester.pumpWidget(
        _envolver(
          EstadoMensaje(
            icono: Icons.inbox_outlined,
            compacto: true,
            mensaje: 'Vacío',
            textoAccionSecundaria: 'Regresar',
            onAccionSecundaria: () {},
          ),
        ),
      );
      expect(find.text('Regresar'), findsNothing);
    });
  });
}
