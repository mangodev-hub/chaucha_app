import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/app/inicio_shell.dart';
import 'package:tecnicos_app/core/providers/sincronizacion_provider.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/auth_repository.dart';
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

class _AuthSinSesion implements AuthRepository {
  @override
  String? get correoActual => null;

  @override
  bool get usaContrasena => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Future<void> _montarEnMovil(WidgetTester tester) async {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(null),
        authRepositoryProvider.overrideWithValue(_AuthSinSesion()),
        // El shell sincroniza datos y escucha notificaciones por Supabase;
        // en el test no hay cliente.
        sincronizacionProvider.overrideWith((ref) {}),
        notificacionesNoLeidasProvider.overrideWith(
          (ref) => Stream.value(const []),
        ),
      ],
      child: MaterialApp(
        home: InicioShell(destinos: _destinos, onCerrarSesion: () {}),
      ),
    ),
  );
}

void main() {
  testWidgets('en móvil muestra la barra flotante con las etiquetas cortas', (
    tester,
  ) async {
    await _montarEnMovil(tester);

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Cerca'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Inicio'), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
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

  testWidgets('las pestañas se anuncian como botones con estado de selección', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await _montarEnMovil(tester);

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
    semantica.dispose();
  });
}
