import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tecnicos_app/app/pie_pagina.dart';
import 'package:tecnicos_app/core/config/info_app.dart';
import 'package:tecnicos_app/core/router/app_routes.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/legal/presentation/views/pagina_legal_view.dart';

Future<void> _montar(WidgetTester tester, Size tamano) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: SingleChildScrollView(child: PiePagina(mostrar: true)),
        ),
      ),
      GoRoute(
        path: AppRoutes.terminos,
        builder: (context, state) => const TerminosView(),
      ),
      GoRoute(
        path: AppRoutes.privacidad,
        builder: (context, state) =>
            PrivacidadView(seccion: state.uri.queryParameters['seccion']),
      ),
      GoRoute(
        path: '/cliente/reclamos',
        builder: (context, state) => const Text('mis reclamos'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(
          Usuario(
            id: 'u',
            rol: Rol.cliente,
            nombres: 'Carlos',
            apellidos: 'Puente',
            creadoEn: DateTime(2026),
          ),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final ancho in [390.0, 900.0, 1920.0]) {
    testWidgets('el pie se arma sin desbordes a $ancho px', (tester) async {
      await _montar(tester, Size(ancho, 1200));
      expect(find.text('Cómo funciona'), findsOneWidget);
      expect(find.text('Reportar un problema'), findsOneWidget);
      expect(find.text('Uso de datos de verificación'), findsOneWidget);
      expect(
        find.text(
          '© ${DateTime.now().year} ChauchaApp. Todos los derechos reservados.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Hecho en Quito, Ecuador · v${InfoApp.version}'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Términos abre su página con secciones en borrador', (
    tester,
  ) async {
    await _montar(tester, const Size(1280, 1200));
    await tester.tap(find.text('Términos y condiciones'));
    await tester.pumpAndSettle();
    // Primero la modal con el resumen; desde ahí, la página completa.
    expect(find.textContaining('se financia con publicidad'), findsOneWidget);
    await tester.tap(find.text('Ver página completa'));
    await tester.pumpAndSettle();
    expect(find.text('1. Qué es ChauchaApp'), findsOneWidget);
    expect(find.text('[BORRADOR – pendiente de revisión]'), findsWidgets);
  });

  testWidgets('"Uso de datos de verificación" baja a su sección', (
    tester,
  ) async {
    await _montar(tester, const Size(1280, 800));
    await tester.tap(find.text('Uso de datos de verificación'));
    await tester.pumpAndSettle();
    expect(find.textContaining('almacenamiento privado'), findsOneWidget);
    await tester.tap(find.text('Ver página completa'));
    await tester.pumpAndSettle();
    final seccion = find.text(
      '2. Uso de datos de verificación (cédula y selfie)',
    );
    expect(seccion, findsOneWidget);
    expect(tester.getTopLeft(seccion).dy, lessThan(800));
  });

  testWidgets('"Reportar un problema" lleva a Mis reclamos', (tester) async {
    await _montar(tester, const Size(1280, 1200));
    await tester.tap(find.text('Reportar un problema'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tienes 30 días'), findsOneWidget);
    await tester.tap(find.text('Ver mis reclamos'));
    await tester.pumpAndSettle();
    expect(find.text('mis reclamos'), findsOneWidget);
  });

  for (final (enlace, contenido) in [
    ('Cómo funciona', 'Publicas lo que necesitas arreglar.'),
    ('Garantía de 30 días', 'Cada servicio completado tiene 30 días'),
    ('Únete como técnico', 'elige el rol "Técnico"'),
    ('Centro de ayuda', 'entra a Mi perfil'),
    ('Contacto', 'Escríbenos a'),
    ('Política de privacidad', 'Recogemos tus datos de cuenta'),
  ]) {
    testWidgets('"$enlace" abre una modal con su contenido', (tester) async {
      await _montar(tester, const Size(1280, 1200));
      await tester.tap(find.text(enlace));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining(contenido), findsOneWidget);
    });
  }
}
