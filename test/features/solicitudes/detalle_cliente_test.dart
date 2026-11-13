import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tecnicos_app/core/providers/core_providers.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/cotizaciones/data/repositories/ofertas_en_vivo.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/tarifa.dart';
import 'package:tecnicos_app/features/reclamos/presentation/providers/reclamos_provider.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/detalle_solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/detalle_provider.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/views/solicitud_detalle_view.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/widgets/detalle_cliente_widgets.dart';

final _cliente = Usuario(
  id: 'cli',
  rol: Rol.cliente,
  nombres: 'Eduardo',
  apellidos: 'Simón',
  creadoEn: DateTime(2026),
  verificado: true,
  ciudad: 'Quito',
);

Solicitud _solicitud(EstadoSolicitud estado) => Solicitud(
  id: 's1',
  clienteId: 'cli',
  oficioId: 1,
  oficioNombre: 'Plomería',
  descripcion: 'Fuga bajo el lavaplatos',
  direccionReferencia: 'La Carolina, Torre B',
  ubicacion: const LatLng(-0.18, -78.48),
  estado: estado,
  creadoEn: DateTime(2026, 11, 10, 9, 30),
  completadaEn: estado == EstadoSolicitud.completada
      ? DateTime.now().subtract(const Duration(days: 3))
      : null,
);

Cotizacion _oferta(
  String id,
  String nombre,
  double precio, {
  double calificacion = 4.5,
  int resenas = 10,
  EstadoCotizacion estado = EstadoCotizacion.pendiente,
  LatLng? ubicacion,
}) => Cotizacion(
  id: id,
  solicitudId: 's1',
  tecnicoId: 't-$id',
  tecnicoNombre: nombre,
  tecnicoCalificacion: calificacion,
  tecnicoTotalResenas: resenas,
  tecnicoUbicacion: ubicacion,
  precioBase: precio,
  estado: estado,
  creadoEn: DateTime(2026, 11, 10, 10),
  solucion: 'Reviso la tubería y cambio el empaque si hace falta.',
  tarifa: estado == EstadoCotizacion.aceptada
      ? Tarifa(precioAcordado: precio, fechaServicio: DateTime(2026, 11, 20))
      : null,
);

final _tres = [
  _oferta(
    'a',
    'Marco Vinueza',
    25,
    calificacion: 4.9,
    ubicacion: const LatLng(-0.20, -78.50),
  ),
  _oferta(
    'b',
    'Ana Paredes',
    18,
    calificacion: 4.2,
    ubicacion: const LatLng(-0.181, -78.481),
  ),
  _oferta('c', 'Luis Cabrera', 30, resenas: 0, calificacion: 0),
];

Future<void> _montar(
  WidgetTester tester, {
  required EstadoSolicitud estado,
  required List<Cotizacion> ofertas,
  Size tamano = const Size(1440, 1400),
}) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final detalle = DetalleSolicitud(
    solicitud: _solicitud(estado),
    fotos: const [],
    cotizaciones: ofertas,
    usuario: _cliente,
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(_cliente),
        supabaseClientProvider.overrideWithValue(
          SupabaseClient(
            'http://localhost',
            'anon',
            authOptions: const AuthClientOptions(autoRefreshToken: false),
          ),
        ),
        detalleSolicitudProvider.overrideWith((ref, id) async => detalle),
        ofertasEnVivoProvider.overrideWith(
          (ref, id) => Stream.value(const <String>[]),
        ),
        reclamoAbiertoProvider.overrideWith((ref, id) async => null),
      ],
      child: const MaterialApp(home: SolicitudDetalleView(solicitudId: 's1')),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  testWidgets('con 3 ofertas: cabecera, progreso y ofertas sin materiales', (
    tester,
  ) async {
    await _montar(tester, estado: EstadoSolicitud.cotizada, ofertas: _tres);

    expect(find.text('Fuga bajo el lavaplatos'), findsWidgets);
    expect(find.text('Con ofertas · 3'), findsOneWidget);
    expect(find.text('Publicada el 10/11/2026, 09:30'), findsOneWidget);
    expect(find.text('Recibiendo ofertas'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('Ofertas recibidas'), findsOneWidget);
    expect(find.text('Escribir al técnico'), findsNWidgets(3));
    expect(find.text('Menor precio'), findsWidgets);
    expect(find.text('Técnico nuevo'), findsOneWidget);
    expect(find.text('Sin fotos'), findsOneWidget);
    expect(find.text('Quito, Pichincha'), findsOneWidget);
    expect(find.textContaining('aterial'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ordena por menor precio y luego por mejor calificación', (
    tester,
  ) async {
    await _montar(tester, estado: EstadoSolicitud.cotizada, ofertas: _tres);
    double y(String texto) => tester.getTopLeft(find.text(texto)).dy;
    expect(y('Ana Paredes'), lessThan(y('Marco Vinueza')));

    await tester.tap(find.byType(DropdownButton<OrdenOfertas>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mejor calificación').last);
    await tester.pumpAndSettle();
    expect(y('Marco Vinueza'), lessThan(y('Ana Paredes')));
  });

  testWidgets('sin ofertas muestra el aviso de espera', (tester) async {
    await _montar(tester, estado: EstadoSolicitud.abierta, ofertas: const []);
    expect(
      find.text('Aún no hay ofertas. Te avisaremos cuando un técnico cotice.'),
      findsOneWidget,
    );
    expect(find.text('Esperando ofertas'), findsOneWidget);
  });

  testWidgets('con 1 oferta no marca "Menor precio"', (tester) async {
    await _montar(
      tester,
      estado: EstadoSolicitud.cotizada,
      ofertas: [_tres.first],
    );
    expect(find.text('Menor precio'), findsNothing);
    expect(find.text('Escribir al técnico'), findsOneWidget);
  });

  testWidgets('oferta aceptada: primera, "Ir al chat" y las otras sin botón', (
    tester,
  ) async {
    await _montar(
      tester,
      estado: EstadoSolicitud.aceptada,
      ofertas: [
        _tres[0],
        _oferta('b', 'Ana Paredes', 18, estado: EstadoCotizacion.aceptada),
        _tres[2],
      ],
    );
    expect(find.text('En curso'), findsWidgets);
    expect(find.text('Ir al chat'), findsOneWidget);
    expect(find.text('Escribir al técnico'), findsNothing);
    expect(find.text('Otras ofertas'), findsOneWidget);
    expect(find.text('Editar'), findsNothing);
    expect(
      tester.getTopLeft(find.text('Ana Paredes')).dy,
      lessThan(tester.getTopLeft(find.text('Marco Vinueza')).dy),
    );
  });

  testWidgets('por confirmar: pide confirmar el trabajo', (tester) async {
    await _montar(
      tester,
      estado: EstadoSolicitud.porConfirmar,
      ofertas: [
        _oferta('b', 'Ana Paredes', 18, estado: EstadoCotizacion.aceptada),
      ],
    );
    expect(find.text('Por confirmar'), findsWidgets);
    expect(find.text('Confirmar trabajo terminado'), findsOneWidget);
  });

  testWidgets('completada: muestra la garantía de 30 días', (tester) async {
    await _montar(
      tester,
      estado: EstadoSolicitud.completada,
      ofertas: [
        _oferta('b', 'Ana Paredes', 18, estado: EstadoCotizacion.aceptada),
      ],
    );
    expect(find.text('Completada'), findsWidgets);
    expect(find.text('Garantía ChauchaApp'), findsOneWidget);
    expect(find.text('Reportar un problema'), findsOneWidget);
  });

  testWidgets('cancelada: aviso en lugar del progreso y sin editar', (
    tester,
  ) async {
    await _montar(tester, estado: EstadoSolicitud.cancelada, ofertas: _tres);
    expect(find.text('Solicitud cancelada'), findsOneWidget);
    expect(find.text('Recibiendo ofertas'), findsNothing);
    expect(find.text('Editar'), findsNothing);
    expect(find.text('Escribir al técnico'), findsNothing);
  });

  testWidgets('a 390 px: una columna, detalles antes de las ofertas', (
    tester,
  ) async {
    await _montar(
      tester,
      estado: EstadoSolicitud.cotizada,
      ofertas: _tres,
      tamano: const Size(390, 2600),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('Detalles del problema')).dy,
      lessThan(tester.getTopLeft(find.text('Ofertas recibidas')).dy),
    );
  });
}
