import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/reclamos/data/models/reclamo_model.dart';
import 'package:tecnicos_app/features/reclamos/data/repositories/supabase_reclamo_repository.dart';
import 'package:tecnicos_app/features/reclamos/domain/entities/reclamo.dart';
import 'package:tecnicos_app/features/reclamos/domain/repositories/reclamo_repository.dart';
import 'package:tecnicos_app/features/reclamos/presentation/views/mis_reclamos_view.dart';
import 'package:tecnicos_app/features/reclamos/presentation/views/reclamo_detalle_view.dart';
import 'package:tecnicos_app/features/reclamos/presentation/widgets/formulario_reclamo.dart';
import 'package:tecnicos_app/features/reclamos/presentation/widgets/tarjeta_garantia.dart';

Reclamo _reclamo({
  EstadoReclamo estado = EstadoReclamo.recibido,
  String? resolucion,
}) => Reclamo(
  id: 'r1',
  numero: 7,
  solicitudId: 's1',
  autorId: 'cliente',
  clienteId: 'cliente',
  contraId: 'tecnico',
  categoria: CategoriaReclamo.fallaTrabajo,
  descripcion: 'La fuga volvió al día siguiente de la visita.',
  evidencias: const [],
  estado: estado,
  resolucion: resolucion,
  creadoEn: DateTime(2026, 11, 10),
  oficio: 'Plomería',
  servicio: 'Fuga bajo el lavaplatos',
  contraNombre: 'Marco Vinueza',
);

class _RepoFalso implements ReclamoRepository {
  _RepoFalso({this.abierto, this.reclamo, this.error});

  Reclamo? abierto;
  Reclamo? reclamo;
  AppFailure? error;
  final creados = <({CategoriaReclamo categoria, String descripcion})>[];
  final respuestas = <String>[];

  @override
  Future<Reclamo?> abiertoDeSolicitud(String solicitudId) async => abierto;

  @override
  Future<Reclamo> crear({
    required String solicitudId,
    required CategoriaReclamo categoria,
    required String descripcion,
    required List<String> evidencias,
  }) async {
    final e = error;
    if (e != null) throw e;
    creados.add((categoria: categoria, descripcion: descripcion));
    return _reclamo();
  }

  @override
  Future<Reclamo> obtener(String id) async => reclamo ?? _reclamo();

  @override
  Stream<List<MensajeReclamo>> mensajes(String reclamoId) async* {
    yield [
      MensajeReclamo(
        id: 'm1',
        texto: 'Recibimos tu reclamo REC-0007.',
        esAsesor: false,
        creadoEn: DateTime(2026, 11, 10),
      ),
      MensajeReclamo(
        id: 'm2',
        autorId: 'asesor',
        texto: '¿Puedes enviar una foto?',
        esAsesor: true,
        creadoEn: DateTime(2026, 11, 11),
      ),
    ];
  }

  @override
  Future<void> responder(String reclamoId, String texto) async {
    respuestas.add(texto);
  }

  @override
  Future<List<Reclamo>> misReclamos() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<void> _montar(WidgetTester tester, _RepoFalso repo, Widget hijo) async {
  tester.view
    ..physicalSize = const Size(400, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        reclamoRepositoryProvider.overrideWithValue(repo),
        usuarioActualProvider.overrideWithValue(null),
      ],
      child: MaterialApp(home: Scaffold(body: hijo)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Garantia', () {
    final completada = DateTime(2026, 11, 1, 10);
    final g = Garantia(completadaEn: completada);

    test('cuenta los días que quedan y vence a los 30 días', () {
      expect(g.diasRestantes(completada), 30);
      expect(g.diasRestantes(DateTime(2026, 11, 30, 11)), 1);
      expect(g.vigente(DateTime(2026, 12, 1, 10)), isFalse);
      expect(g.diasRestantes(DateTime(2026, 12, 5)), 0);
      expect(g.fraccionRestante(completada), 1);
    });
  });

  test('el modelo lee el reclamo con sus joins y el código', () {
    final r = ReclamoModel.desdeFila({
      'id': 'r1',
      'numero': 7,
      'solicitud_id': 's1',
      'autor_id': 'a',
      'categoria': 'no_se_presento',
      'descripcion': 'No llegó a la hora acordada ni avisó nada.',
      'evidencias': ['a/1.jpg'],
      'estado': 'necesita_info',
      'creado_en': '2026-11-10T10:00:00Z',
      'solicitud': {
        'descripcion': 'Fuga',
        'cliente_id': 'a',
        'oficios': {'nombre': 'Plomería'},
      },
      'contra': [
        {'nombres': 'Marco', 'apellidos': 'Vinueza'},
      ],
    });
    expect(r.codigo, 'REC-0007');
    expect(r.categoria, CategoriaReclamo.noSePresento);
    expect(r.estado, EstadoReclamo.necesitaInfo);
    expect(r.oficio, 'Plomería');
    expect(r.contraNombre, 'Marco Vinueza');
    expect(r.evidencias, ['a/1.jpg']);
  });

  test('el técnico no puede elegir "Falla en el trabajo"', () {
    expect(
      CategoriaReclamo.para(esCliente: false),
      isNot(contains(CategoriaReclamo.fallaTrabajo)),
    );
    expect(CategoriaReclamo.para(esCliente: true), hasLength(5));
  });

  group('TarjetaGarantia', () {
    final ahora = DateTime(2026, 11, 12);

    testWidgets('vigente: días que quedan y botón para reportar', (
      tester,
    ) async {
      await _montar(
        tester,
        _RepoFalso(),
        TarjetaGarantia(
          solicitudId: 's1',
          completadaEn: DateTime(2026, 11, 2),
          esCliente: true,
          ahora: ahora,
        ),
      );
      expect(find.text('Te quedan 20 días de garantía'), findsOneWidget);
      expect(find.text('Reportar un problema'), findsOneWidget);
    });

    testWidgets('con un reclamo abierto muestra el reclamo y no el botón', (
      tester,
    ) async {
      await _montar(
        tester,
        _RepoFalso(abierto: _reclamo(estado: EstadoReclamo.enRevision)),
        TarjetaGarantia(
          solicitudId: 's1',
          completadaEn: DateTime(2026, 11, 2),
          esCliente: true,
          ahora: ahora,
        ),
      );
      expect(find.text('Reclamo REC-0007'), findsOneWidget);
      expect(find.text('En revisión'), findsOneWidget);
      expect(find.text('Reportar un problema'), findsNothing);
    });

    testWidgets('vencida: dice cuándo terminó y no tiene botón', (
      tester,
    ) async {
      await _montar(
        tester,
        _RepoFalso(),
        TarjetaGarantia(
          solicitudId: 's1',
          completadaEn: DateTime(2026, 9, 1),
          esCliente: true,
          ahora: ahora,
        ),
      );
      expect(find.textContaining('La garantía terminó el'), findsOneWidget);
      expect(find.text('Reportar un problema'), findsNothing);
    });
  });

  group('Reportar un problema', () {
    Future<void> abrir(WidgetTester tester, _RepoFalso repo, bool esCliente) =>
        _montar(
          tester,
          repo,
          Builder(
            builder: (context) => TextButton(
              onPressed: () => reportarProblema(
                context,
                solicitudId: 's1',
                esCliente: esCliente,
              ),
              child: const Text('abrir'),
            ),
          ),
        ).then((_) async {
          await tester.tap(find.text('abrir'));
          await tester.pumpAndSettle();
        });

    testWidgets('el envío se habilita con categoría y 20 caracteres, y '
        'muestra la confirmación con el código', (tester) async {
      final repo = _RepoFalso();
      await abrir(tester, repo, true);

      FilledButton boton() =>
          tester.widget<FilledButton>(find.byType(FilledButton).last);
      expect(boton().onPressed, isNull);

      await tester.tap(find.text('Falla en el trabajo'));
      await tester.enterText(find.byType(TextField), 'Muy corto');
      await tester.pump();
      expect(boton().onPressed, isNull);

      await tester.enterText(
        find.byType(TextField),
        'La fuga volvió al día siguiente.',
      );
      await tester.pump();
      expect(boton().onPressed, isNotNull);

      await tester.tap(find.text('Enviar reclamo'));
      await tester.pumpAndSettle();
      expect(repo.creados.single.categoria, CategoriaReclamo.fallaTrabajo);
      expect(find.text('Recibimos tu reclamo REC-0007'), findsOneWidget);
      expect(find.text('Ver mi reclamo'), findsOneWidget);
      expect(find.text('Volver al inicio'), findsOneWidget);
    });

    testWidgets('el técnico no ve "Falla en el trabajo"', (tester) async {
      await abrir(tester, _RepoFalso(), false);
      expect(find.text('Falla en el trabajo'), findsNothing);
      expect(find.text('No se presentó'), findsOneWidget);
    });

    testWidgets('si el RPC falla, muestra su mensaje', (tester) async {
      final repo = _RepoFalso(
        error: const AppFailure(
          'Ya tienes un reclamo abierto para este servicio.',
        ),
      );
      await abrir(tester, repo, true);
      await tester.tap(find.text('Mal trato'));
      await tester.enterText(
        find.byType(TextField),
        'Me habló de mala manera durante la visita.',
      );
      await tester.pump();
      await tester.tap(find.text('Enviar reclamo'));
      // Sin pumpAndSettle: avanzaría la barra de 5 s del aviso y lo cerraría.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.text('Ya tienes un reclamo abierto para este servicio.'),
        findsOneWidget,
      );
      expect(find.text('Enviar reclamo'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
    });
  });

  group('Detalle del reclamo', () {
    testWidgets('necesita información: aviso y caja para responder', (
      tester,
    ) async {
      final repo = _RepoFalso(
        reclamo: _reclamo(estado: EstadoReclamo.necesitaInfo),
      );
      await _montar(tester, repo, const ReclamoDetalleView(reclamoId: 'r1'));

      expect(find.text('El asesor necesita más información'), findsOneWidget);
      expect(find.text('Asesor ChauchaApp'), findsOneWidget);
      expect(find.text('Recibimos tu reclamo REC-0007.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Adjunto más detalles.');
      await tester.tap(find.byTooltip('Enviar'));
      await tester.pumpAndSettle();
      expect(repo.respuestas, ['Adjunto más detalles.']);
    });

    testWidgets('cerrado: muestra la resolución y no deja escribir', (
      tester,
    ) async {
      await _montar(
        tester,
        _RepoFalso(
          reclamo: _reclamo(
            estado: EstadoReclamo.resuelto,
            resolucion: 'El técnico regresará sin costo.',
          ),
        ),
        const ReclamoDetalleView(reclamoId: 'r1'),
      );
      await tester.scrollUntilVisible(
        find.text('El técnico regresará sin costo.'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Resolución'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('el asesor ve sus acciones', (tester) async {
      await _montar(
        tester,
        _RepoFalso(),
        const ReclamoDetalleView(reclamoId: 'r1', esAdmin: true),
      );
      expect(find.text('Tomar caso'), findsOneWidget);
      expect(find.text('Pedir información'), findsOneWidget);
      expect(find.text('Resolver'), findsOneWidget);
      expect(find.text('Rechazar'), findsOneWidget);
      expect(find.text('Suspender usuario'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  });

  testWidgets('Mis reclamos vacío explica la garantía', (tester) async {
    await _montar(tester, _RepoFalso(), const MisReclamosView(esCliente: true));
    expect(
      find.text(
        'No tienes reclamos. Si algo falla en un servicio, tienes 30 días '
        'para reportarlo.',
      ),
      findsOneWidget,
    );
  });
}
