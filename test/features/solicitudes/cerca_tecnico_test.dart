import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/catalogo/domain/entities/oficio.dart';
import 'package:tecnicos_app/features/catalogo/presentation/providers/oficios_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_tecnico.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import 'package:tecnicos_app/features/solicitudes/data/repositories/supabase_mapa_tecnico_repository.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud_en_mapa.dart';
import 'package:tecnicos_app/features/solicitudes/domain/repositories/mapa_tecnico_repository.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/widgets/cerca_tecnico.dart';

class _MapaFalso implements MapaTecnicoRepository {
  final radios = <int>[];
  List<SolicitudEnMapa> solicitudes = [
    SolicitudEnMapa(
      id: 's1',
      descripcion: 'Fuga bajo el lavaplatos',
      oficioId: 1,
      metros: 1200,
      ubicacion: const LatLng(-0.18, -78.48),
      creadoEn: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  Future<List<SolicitudEnMapa>> solicitudesEnMapa() async => solicitudes;

  @override
  Future<void> actualizarMiRadio(int metros) async => radios.add(metros);
}

PerfilTecnico _perfil({required bool verificado}) => PerfilTecnico(
  usuarioId: 't1',
  tarifaBase: 20,
  rangoCoberturaM: 8000,
  puntos: 10,
  calificacionPromedio: 4.8,
  totalResenas: 3,
  verificado: verificado,
  nivelNombre: 'Plata',
  comisionPorcentaje: 0,
  oficioIds: const [1, 2],
  ubicacionActual: const LatLng(-0.18, -78.48),
);

Future<void> _montar(
  WidgetTester tester,
  _MapaFalso repo, {
  required bool verificado,
}) async {
  tester.view
    ..physicalSize = const Size(1280, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        mapaTecnicoRepositoryProvider.overrideWithValue(repo),
        usuarioActualProvider.overrideWithValue(null),
        perfilTecnicoProvider.overrideWith(
          (ref) async => _perfil(verificado: verificado),
        ),
        oficiosProvider.overrideWith(
          (ref) async => const [
            Oficio(id: 1, nombre: 'Plomería'),
            Oficio(id: 2, nombre: 'Electricidad'),
          ],
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: CercaTecnico())),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('verificado: lista las solicitudes con su radio guardado', (
    tester,
  ) async {
    await _montar(tester, _MapaFalso(), verificado: true);
    expect(find.text('Solicitudes cerca de ti'), findsOneWidget);
    expect(find.text('8 km'), findsOneWidget);
    expect(find.text('Fuga bajo el lavaplatos'), findsOneWidget);
    expect(find.text('Plomería · 1,2 km · hace 2 h'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tocar una fila abre su mini tarjeta con "Ver solicitud"', (
    tester,
  ) async {
    await _montar(tester, _MapaFalso(), verificado: true);
    await tester.tap(find.text('Fuga bajo el lavaplatos'));
    await tester.pumpAndSettle();
    expect(find.text('Ver solicitud'), findsOneWidget);
  });

  testWidgets('al soltar el slider guarda el radio y avisa', (tester) async {
    final repo = _MapaFalso();
    await _montar(tester, repo, verificado: true);
    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChangeEnd!(12);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(repo.radios, [12000]);
    expect(find.text('Radio actualizado a 12 km'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('sin verificar: mapa atenuado y sin lista', (tester) async {
    await _montar(tester, _MapaFalso(), verificado: false);
    expect(
      find.text('Verifica tu identidad para ver solicitudes'),
      findsOneWidget,
    );
    expect(find.text('Fuga bajo el lavaplatos'), findsNothing);
  });
}
