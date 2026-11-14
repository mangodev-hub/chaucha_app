import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/app/inicio_shell.dart';
import 'package:tecnicos_app/core/presence/presencia_service.dart';
import 'package:tecnicos_app/core/providers/sincronizacion_provider.dart';
import 'package:tecnicos_app/core/widgets/etiqueta_sector.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/inicio_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/notificaciones/presentation/providers/notificaciones_provider.dart';

const _destinos = [
  Destino(
    'Inicio',
    Icons.home_outlined,
    Text('vista inicio'),
    iconoActivo: Icons.home_rounded,
  ),
  Destino(
    'Solicitudes cerca',
    Icons.travel_explore,
    Text('vista cerca'),
    corto: 'Cerca',
  ),
];

const _accion = AccionCentral(
  etiqueta: 'Pedir un técnico',
  corto: 'Pedir',
  icono: Icons.add_rounded,
  ruta: '/nueva',
);

class _AuthSinSesion implements AuthRepository {
  @override
  String? get correoActual => null;

  @override
  bool get usaContrasena => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Future<void> _montarEnMovil(
  WidgetTester tester, {
  AccionCentral? accion,
  Size tamano = const Size(390, 844),
  bool claro = false,
  bool conBuscador = true,
  Widget? barraExtra,
}) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => InicioShell(
          destinos: _destinos,
          accionCentral: accion,
          onCerrarSesion: () {},
          claro: claro,
          rutaAgenda: claro ? '/nueva' : null,
          notaMenu: claro ? 'Nota del menú' : null,
          onBuscar: claro && conBuscador ? (context, ref, texto) {} : null,
          barraExtra: barraExtra,
        ),
      ),
      GoRoute(
        path: '/nueva',
        builder: (context, state) => const Text('vista nueva'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(null),
        authRepositoryProvider.overrideWithValue(_AuthSinSesion()),
        sincronizacionProvider.overrideWith((ref) {}),
        presenciaProvider.overrideWith((ref) {}),
        ubicacionInicioProvider.overrideWith(
          (ref) async => const LatLng(-0.18, -78.48),
        ),
        sectorProvider.overrideWith((ref, clave) async => 'La Carolina'),
        notificacionesNoLeidasProvider.overrideWith(
          (ref) => Stream.value(const []),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
}

void main() {
  testWidgets('en móvil muestra la barra inferior con las etiquetas cortas', (
    tester,
  ) async {
    await _montarEnMovil(tester);

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Cerca'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Inicio'), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.text('Pedir'), findsNothing);
  });

  testWidgets('al tocar una pestaña cambia la vista y el título', (
    tester,
  ) async {
    await _montarEnMovil(tester);

    await tester.tap(find.text('Cerca'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Solicitudes cerca'), findsOneWidget);
    final pila = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(pila.index, 1);
    expect(find.byIcon(Icons.home_rounded), findsNothing);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
  });

  testWidgets('la acción central va al centro de la barra y abre su ruta', (
    tester,
  ) async {
    await _montarEnMovil(tester, accion: _accion);

    expect(find.text('Pedir'), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    await tester.tap(find.text('Pedir'));
    await tester.pumpAndSettle();

    expect(find.text('vista nueva'), findsOneWidget);
  });

  testWidgets('las pestañas se anuncian como botones con estado de selección', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await _montarEnMovil(tester, accion: _accion);

    expect(
      tester.getSemantics(find.text('Cerca')),
      matchesSemantics(
        label: 'Cerca',
        isButton: true,
        hasSelectedState: true,
        isSelected: false,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Pedir un técnico')),
      matchesSemantics(
        label: 'Pedir un técnico',
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantica.dispose();
  });

  for (final ancho in [900.0, 1440.0]) {
    testWidgets('modo claro a $ancho px: barra blanca y menú lateral', (
      tester,
    ) async {
      await _montarEnMovil(
        tester,
        accion: _accion,
        tamano: Size(ancho, 900),
        claro: true,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        find.text('Busca plomero, electricista, cerrajero…'),
        findsOneWidget,
      );
      expect(find.text('La Carolina'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Pedir un técnico'), findsOneWidget);
      expect(find.text('Nota del menú'), findsOneWidget);
      // En el modo claro no hay barra inferior.
      expect(find.text('Cerca'), findsNothing);
    });
  }

  testWidgets('modo claro del técnico: lo suyo en la barra, sin buscador', (
    tester,
  ) async {
    await _montarEnMovil(
      tester,
      tamano: const Size(1920, 1080),
      claro: true,
      conBuscador: false,
      barraExtra: const Text('píldora del técnico'),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('píldora del técnico'), findsOneWidget);
    expect(find.text('Busca plomero, electricista, cerrajero…'), findsNothing);
    // El sector del cliente no va: el técnico pone el suyo en su extra.
    expect(find.text('La Carolina'), findsNothing);
    expect(find.text('vista inicio'), findsOneWidget);
  });

  testWidgets('modo claro del admin: barra solo con marca, avisos y cuenta', (
    tester,
  ) async {
    await _montarEnMovil(
      tester,
      tamano: const Size(1920, 1080),
      claro: true,
      conBuscador: false,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Busca plomero, electricista, cerrajero…'), findsNothing);
    expect(find.text('La Carolina'), findsNothing);
    expect(find.text('Pedir un técnico'), findsNothing);
  });

  testWidgets(
    'agenda del cliente: se marca en el menú y otro clic no la vuelve a apilar',
    (tester) async {
      tester.view
        ..physicalSize = const Size(1440, 1000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      InicioShell shell({Widget? pagina}) => InicioShell(
        destinos: _destinos,
        onCerrarSesion: () {},
        claro: true,
        rutaAgenda: '/cliente/agenda',
        rutaInicio: '/cliente',
        pagina: pagina,
      );
      final router = GoRouter(
        initialLocation: '/cliente',
        routes: [
          GoRoute(
            path: '/cliente',
            builder: (context, state) => shell(),
            routes: [
              GoRoute(
                path: 'agenda',
                builder: (context, state) =>
                    shell(pagina: const Text('vista agenda')),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      final semantica = tester.ensureSemantics();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            usuarioActualProvider.overrideWithValue(null),
            authRepositoryProvider.overrideWithValue(_AuthSinSesion()),
            sincronizacionProvider.overrideWith((ref) {}),
            presenciaProvider.overrideWith((ref) {}),
            ubicacionInicioProvider.overrideWith(
              (ref) async => const LatLng(-0.18, -78.48),
            ),
            sectorProvider.overrideWith((ref, clave) async => 'La Carolina'),
            notificacionesNoLeidasProvider.overrideWith(
              (ref) => Stream.value(const []),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      bool seleccionado(String texto) =>
          tester
              .getSemantics(find.bySemanticsLabel(RegExp('^$texto')))
              .getSemanticsData()
              .flagsCollection
              .isSelected
              .toBoolOrNull() ??
          false;

      expect(seleccionado('Agenda'), isFalse);

      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();
      expect(find.text('vista agenda'), findsOneWidget);
      expect(router.state.matchedLocation, '/cliente/agenda');
      expect(seleccionado('Agenda'), isTrue);
      expect(seleccionado('Inicio'), isFalse);

      // Segundo clic: no apila otra agenda ni deja la pantalla en blanco.
      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('vista agenda'), findsOneWidget);
      expect(router.canPop(), isTrue);
      router.pop();
      await tester.pumpAndSettle();
      expect(router.state.matchedLocation, '/cliente');
      semantica.dispose();
    },
  );
}
