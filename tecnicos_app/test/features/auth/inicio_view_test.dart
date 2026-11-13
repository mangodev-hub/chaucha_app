import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/core/presence/presencia_service.dart';
import 'package:tecnicos_app/features/auth/domain/entities/tecnico_cercano.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/inicio_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/views/inicio_view.dart';
import 'package:tecnicos_app/features/catalogo/domain/entities/oficio.dart';
import 'package:tecnicos_app/features/catalogo/presentation/providers/oficios_provider.dart';
import 'package:tecnicos_app/features/chat/domain/entities/resumen_chat.dart';
import 'package:tecnicos_app/features/chat/presentation/providers/mis_chats_provider.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/notificaciones/presentation/providers/notificaciones_provider.dart';
import 'package:tecnicos_app/features/publicidad/domain/entities/anuncio.dart';
import 'package:tecnicos_app/features/publicidad/presentation/providers/anuncios_provider.dart';
import 'package:tecnicos_app/features/publicidad/presentation/widgets/bloque_publicidad.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/agenda_provider.dart';

final _tecnicos = [
  for (var i = 0; i < 8; i++)
    TecnicoCercano(
      id: 't$i',
      nombres: 'Marco Antonio',
      apellidos: 'Vinueza Paredes',
      oficios: const ['Plomería', 'Electricidad'],
      calificacion: 4.9,
      totalResenas: 12,
      metros: 2000 - i * 100,
      ubicacion: const LatLng(-0.18, -78.48),
      tarifaBase: 20,
      nivel: 'Plata',
    ),
];

const _oficios = [
  Oficio(id: 1, nombre: 'Plomería'),
  Oficio(id: 2, nombre: 'Electricidad'),
  Oficio(id: 3, nombre: 'Cerrajería'),
  Oficio(id: 4, nombre: 'Pintura'),
  Oficio(id: 5, nombre: 'Carpintería'),
];

final _solicitud = Solicitud(
  id: 's1',
  clienteId: 'c1',
  oficioId: 1,
  oficioNombre: 'Plomería',
  descripcion: 'Fuga bajo el lavaplatos de la cocina',
  direccionReferencia: 'La Carolina, Torre B',
  estado: EstadoSolicitud.cotizada,
  creadoEn: DateTime.now().subtract(const Duration(days: 1)),
);

final _inicioVisita = DateTime.now().add(const Duration(days: 2));

final _visita = ItemAgenda(
  Cotizacion(
    id: 'c1',
    solicitudId: 's1',
    tecnicoId: 't1',
    tecnicoNombre: 'Ana Paredes',
    tecnicoCalificacion: 4.8,
    precioBase: 35,
    estado: EstadoCotizacion.aceptada,
    creadoEn: DateTime(2026, 11),
    inicioVisita: _inicioVisita,
    finVisita: _inicioVisita.add(const Duration(hours: 1)),
  ),
  _solicitud,
);

const _chats = [
  ResumenChat(
    conversacionId: 'k1',
    otroNombre: 'Marco Vinueza',
    esMio: false,
    ultimoMensaje: '¿El edificio tiene parqueadero?',
  ),
];

Future<void> _montar(
  WidgetTester tester,
  Size tamano, {
  bool conSolicitud = true,
  bool conVisita = true,
  List<Anuncio> anuncios = const [],
  List<TecnicoCercano>? tecnicos,
  int enLinea = 0,
}) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(null),
        tecnicosCercanosProvider.overrideWith(
          (ref) async => tecnicos ?? _tecnicos,
        ),
        oficiosProvider.overrideWith((ref) async => _oficios),
        solicitudActivaProvider.overrideWith(
          (ref) async =>
              conSolicitud ? (solicitud: _solicitud, ofertas: 3) : null,
        ),
        misChatsProvider.overrideWith((ref) async => _chats),
        notificacionesNoLeidasProvider.overrideWith(
          (ref) => Stream.value(const []),
        ),
        proximaVisitaProvider.overrideWith(
          (ref) async => conVisita ? _visita : null,
        ),
        anunciosProvider.overrideWith((ref, ubicacion) async => anuncios),
        ubicacionInicioProvider.overrideWith(
          (ref) async => const LatLng(-0.18, -78.48),
        ),
        tecnicosEnLineaProvider.overrideWith((ref, p) async => enLinea),
      ],
      child: const MaterialApp(
        home: Scaffold(body: InicioView(esCliente: true)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

final _lista = find.byType(Scrollable).first;

Future<void> _bajarHasta(WidgetTester tester, Finder objetivo) =>
    tester.scrollUntilVisible(objetivo, 200, scrollable: _lista);

void main() {
  for (final ancho in [
    360.0,
    412.0,
    768.0,
    1024.0,
    1100.0,
    1280.0,
    1440.0,
    1920.0,
  ]) {
    testWidgets('sin desbordes a $ancho px', (tester) async {
      await _montar(tester, Size(ancho, 900));
      await _bajarHasta(tester, find.byType(BloquePublicidad));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('muestra los bloques con los datos recibidos', (tester) async {
    final semantica = tester.ensureSemantics();
    await _montar(tester, const Size(1280, 900));

    expect(find.text('¿Qué arreglamos hoy?'), findsOneWidget);
    expect(
      find.text('8 técnicos verificados a menos de 5 km de tu casa.'),
      findsOneWidget,
    );
    expect(find.text('Todos los oficios'), findsOneWidget);
    expect(find.text('Con cotizaciones · 3'), findsOneWidget);
    expect(find.text('Comparar cotizaciones'), findsOneWidget);
    expect(
      find.textContaining('3 técnicos cotizaron · La Carolina, Torre B'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('Paso 2 de 4: Con cotizaciones')),
      findsOneWidget,
    );
    // Confianza, en ese orden.
    expect(find.text('Técnicos 100 % verificados'), findsOneWidget);
    expect(find.text('Garantía de 30 días'), findsOneWidget);
    expect(find.text('Pagas solo la visita'), findsOneWidget);
    // "Cerca de ti": slider con su valor, chips y la lista por distancia.
    expect(find.text('Cerca de ti'), findsOneWidget);
    expect(find.text('5 km'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Todos'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Cerrajería'), findsOneWidget);
    expect(find.text('Plomería · 1,3 km'), findsOneWidget);
    expect(find.text('¿El edificio tiene parqueadero?'), findsOneWidget);
    expect(find.textContaining('Ana Paredes'), findsOneWidget);
    expect(find.textContaining('\$35 la visita'), findsOneWidget);
    expect(find.text('Reagendar'), findsOneWidget);
    expect(find.text('Escribir'), findsOneWidget);
    semantica.dispose();
  });

  testWidgets('en el teléfono la visita va antes que los chats y la '
      'publicidad al final', (tester) async {
    await _montar(tester, const Size(390, 844));
    await _bajarHasta(tester, find.byType(BloquePublicidad));

    double y(Finder f) => tester.getTopLeft(f).dy;
    expect(y(find.text('Tu próxima visita')), lessThan(y(find.text('Chats'))));
    expect(y(find.text('Chats')), lessThan(y(find.byType(BloquePublicidad))));
  });

  testWidgets('la publicidad no se puede cerrar y tiene alto fijo', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await _montar(
      tester,
      const Size(390, 844),
      anuncios: const [
        Anuncio(
          id: 'a1',
          titulo: 'Ferretería El Constructor',
          descripcion: '10% en materiales',
          anunciante: 'Ferretería El Constructor S.A.',
          categoria: CategoriaAnuncio.ferreteria,
          urlDestino: 'https://example.com',
        ),
      ],
    );
    final espacio = find.byType(BloquePublicidad);
    await _bajarHasta(tester, espacio);

    expect(find.text('PUBLICIDAD'), findsOneWidget);
    expect(find.text('Ver más'), findsOneWidget);
    expect(find.text('Ferretería El Constructor S.A.'), findsOneWidget);
    expect(find.byIcon(Icons.hardware_outlined), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Publicidad: Ferretería El Constructor')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: espacio, matching: find.byIcon(Icons.close_rounded)),
      findsNothing,
    );
    semantica.dispose();
  });

  testWidgets('sin anunciantes muestra la pieza neutra, sin botón', (
    tester,
  ) async {
    await _montar(tester, const Size(1280, 900));
    expect(find.text('Espacio publicitario'), findsOneWidget);
    expect(find.text('Anuncia tu negocio aquí'), findsOneWidget);
    expect(find.text('Ver más'), findsNothing);
    // La app nunca se anuncia a sí misma.
    expect(find.textContaining('Únete a ChauchaApp'), findsNothing);
    expect(find.textContaining('Certifícate'), findsNothing);
  });

  testWidgets('el bloque tiene el mismo alto con 1 anuncio o con 2', (
    tester,
  ) async {
    await _montar(
      tester,
      const Size(1280, 1000),
      anuncios: const [Anuncio(id: 'a1', titulo: 'Uno', descripcion: '')],
    );
    final conUno = tester.getSize(find.byType(BloquePublicidad)).height;
    await _montar(tester, const Size(1280, 1000));
    final conDos = tester.getSize(find.byType(BloquePublicidad)).height;
    expect(conUno, conDos);
  });

  const dosAnuncios = [
    Anuncio(id: 'a1', titulo: 'Primero', descripcion: ''),
    Anuncio(id: 'a2', titulo: 'Segundo', descripcion: ''),
  ];

  testWidgets('el carrusel avanza cada 7 s', (tester) async {
    await _montar(tester, const Size(1280, 1000), anuncios: dosAnuncios);
    expect(find.text('Primero'), findsOneWidget);
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    expect(find.text('Segundo'), findsOneWidget);
    expect(find.text('Primero'), findsNothing);
  });

  testWidgets('el carrusel se pausa con el mouse encima', (tester) async {
    await _montar(tester, const Size(1280, 1000), anuncios: dosAnuncios);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(BloquePublicidad)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    expect(find.text('Primero'), findsOneWidget);

    // Al salir vuelve a avanzar.
    await mouse.moveTo(Offset.zero);
    await tester.pump();
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    expect(find.text('Segundo'), findsOneWidget);
  });

  testWidgets('los puntos del carrusel cambian de anuncio', (tester) async {
    await _montar(tester, const Size(1280, 1000), anuncios: dosAnuncios);
    await tester.tap(find.bySemanticsLabel('Anuncio 2 de 2'));
    await tester.pumpAndSettle();
    expect(find.text('Segundo'), findsOneWidget);
  });

  testWidgets('los chips de oficio filtran "Cerca de ti"', (tester) async {
    await _montar(tester, const Size(1280, 1000));
    final contenedor = ProviderScope.containerOf(
      tester.element(find.byType(InicioView)),
    );
    await tester.tap(find.widgetWithText(ChoiceChip, 'Pintura'));
    await tester.pump();
    expect(contenedor.read(oficioInicioProvider), 4);
  });

  testWidgets('sin técnicos en el radio sugiere ampliarlo', (tester) async {
    await _montar(tester, const Size(1280, 1000), tecnicos: const []);
    expect(
      find.text('No hay técnicos en 5 km. Prueba ampliando el radio.'),
      findsOneWidget,
    );
  });

  testWidgets('estados vacíos', (tester) async {
    await _montar(
      tester,
      const Size(1280, 900),
      conSolicitud: false,
      conVisita: false,
    );
    expect(find.text('No tienes solicitudes activas'), findsOneWidget);
    expect(find.text('Publicar solicitud'), findsOneWidget);
    expect(find.text('No tienes visitas agendadas'), findsOneWidget);
  });

  testWidgets('cuenta los técnicos en línea cerca (presencia)', (tester) async {
    await _montar(tester, const Size(1280, 900), enLinea: 3);
    expect(
      find.text(
        '8 técnicos verificados a menos de 5 km de tu casa. '
        '3 están en línea ahora.',
      ),
      findsOneWidget,
    );
  });
}
