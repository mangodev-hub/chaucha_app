// Agenda: vistas Mes, Semana y Lista a 1440 y 390 px, como cliente y como
// técnico, con un mes con visitas (un día con 3 y una por confirmar) y un mes
// vacío. Sin desbordes y sin textos de relleno entre corchetes.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/solicitudes/data/models/visita_agenda_model.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/visita_agenda.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/visitas_agenda_provider.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/views/agenda_view.dart';

// Viernes 13 de noviembre de 2026, 9:00.
final _ahora = DateTime(2026, 11, 13, 9);

VisitaAgenda _visita(
  String id,
  DateTime inicio, {
  EstadoVisita estado = EstadoVisita.agendada,
  String oficio = 'Plomería',
  bool reagendaPorMi = false,
}) => VisitaAgenda(
  cotizacionId: id,
  solicitudId: 's$id',
  tecnicoId: 't1',
  inicio: inicio,
  fin: inicio.add(const Duration(hours: 1)),
  oficio: oficio,
  descripcion: 'Fuga bajo el lavaplatos de la cocina $id',
  precioVisita: 15,
  estado: estado,
  otraPersonaId: 'o1',
  otraPersonaNombre: 'Ana Paredes',
  reagendaInicio: estado == EstadoVisita.porConfirmar
      ? inicio.add(const Duration(days: 1))
      : null,
  reagendaPorMi: reagendaPorMi,
);

final _visitas = [
  _visita('1', DateTime(2026, 11, 13, 15)),
  // Sábado 14: tres visitas.
  _visita('2', DateTime(2026, 11, 14, 8), oficio: 'Electricidad'),
  _visita('3', DateTime(2026, 11, 14, 10)),
  _visita('4', DateTime(2026, 11, 14, 16), oficio: 'Cerrajería'),
  _visita('5', DateTime(2026, 11, 20, 11), estado: EstadoVisita.porConfirmar),
];

Future<void> _montar(
  WidgetTester tester,
  Size tamano, {
  required bool esCliente,
  VistaAgenda? vista,
  List<VisitaAgenda>? visitas,
}) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final lista = visitas ?? _visitas;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        visitasRangoProvider.overrideWith(
          (ref, r) async => [
            for (final v in lista)
              if (!v.inicio.isBefore(r.desde) && v.inicio.isBefore(r.hasta)) v,
          ],
        ),
        visitasProximasProvider.overrideWith((ref, esCliente) async => lista),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) {
              if (vista != null) {
                Future.microtask(
                  () => ref.read(vistaAgendaProvider.notifier).elegir(vista),
                );
              }
              return AgendaView(esCliente: esCliente, ahora: _ahora);
            },
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void _sinCorchetes() {
  expect(find.textContaining('['), findsNothing);
  expect(find.textContaining(']'), findsNothing);
}

void main() {
  for (final tamano in const [Size(1440, 1300), Size(390, 2200)]) {
    final w = tamano.width.toInt();
    for (final esCliente in [true, false]) {
      final rol = esCliente ? 'cliente' : 'técnico';
      for (final vista in VistaAgenda.values) {
        testWidgets('$w px · $rol · ${vista.name}', (tester) async {
          await _montar(tester, tamano, esCliente: esCliente, vista: vista);
          expect(tester.takeException(), isNull);
          expect(find.text('Agenda'), findsOneWidget);
          expect(find.text('5 visitas próximas este mes'), findsOneWidget);
          expect(find.text('Hoy tienes 1 visita'), findsOneWidget);
          expect(
            find.text('La siguiente es a las 15:00 con Ana Paredes.'),
            findsOneWidget,
          );
          expect(find.text('Próximos trabajos'), findsOneWidget);
          // Próximos: 3 tarjetas; la por confirmar (5.ª) no entra.
          expect(find.text('Reagendar'), findsWidgets);
          _sinCorchetes();
        });
      }
    }
  }

  testWidgets('mes en web: píldoras, "+1 más" y hoy marcado', (tester) async {
    await _montar(
      tester,
      const Size(1440, 1300),
      esCliente: true,
      vista: VistaAgenda.mes,
    );
    expect(find.text('Noviembre 2026'), findsOneWidget);
    expect(find.text('+1 más'), findsOneWidget);
    expect(find.text('Hoy'), findsWidgets);
    expect(find.text('LUN'), findsWidgets);
  });

  testWidgets('lista: agrupada por día', (tester) async {
    await _montar(
      tester,
      const Size(1440, 1300),
      esCliente: false,
      vista: VistaAgenda.lista,
    );
    expect(find.text('Sábado 14 de noviembre'), findsOneWidget);
    expect(find.text('Viernes 20 de noviembre'), findsOneWidget);
  });

  testWidgets('por confirmar: "Confirmar" y "Otra hora" si me toca', (
    tester,
  ) async {
    await _montar(
      tester,
      const Size(1440, 1300),
      esCliente: true,
      vista: VistaAgenda.lista,
      visitas: [
        _visita(
          '9',
          DateTime(2026, 11, 20, 11),
          estado: EstadoVisita.porConfirmar,
        ),
      ],
    );
    expect(find.text('Confirmar'), findsWidgets);
    expect(find.text('Otra hora'), findsWidgets);
  });

  testWidgets('por confirmar propuesta por mí: sigue "Reagendar"', (
    tester,
  ) async {
    await _montar(
      tester,
      const Size(1440, 1300),
      esCliente: true,
      vista: VistaAgenda.lista,
      visitas: [
        _visita(
          '9',
          DateTime(2026, 11, 20, 11),
          estado: EstadoVisita.porConfirmar,
          reagendaPorMi: true,
        ),
      ],
    );
    expect(find.text('Confirmar'), findsNothing);
    expect(find.textContaining('Esperando respuesta'), findsWidgets);
  });

  for (final tamano in const [Size(1440, 1300), Size(390, 2200)]) {
    testWidgets('mes sin visitas a ${tamano.width.toInt()} px', (tester) async {
      await _montar(
        tester,
        tamano,
        esCliente: true,
        vista: VistaAgenda.lista,
        visitas: const [],
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Sin visitas próximas este mes'), findsOneWidget);
      expect(find.text('No tienes visitas en noviembre.'), findsOneWidget);
      expect(find.text('Hoy no tienes visitas'), findsOneWidget);
      expect(find.text('No tienes visitas próximas.'), findsOneWidget);
      expect(find.text('No tienes trabajos agendados.'), findsOneWidget);
      expect(find.text('Pedir un técnico'), findsOneWidget);
      _sinCorchetes();
    });
  }

  testWidgets('móvil · mes: tocar un día abre su lista', (tester) async {
    await _montar(
      tester,
      const Size(390, 2200),
      esCliente: true,
      vista: VistaAgenda.mes,
    );
    // Antes de tocar: solo en "Próximos trabajos".
    expect(find.text('08:00 a 09:00 · Electricidad'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(RegExp('^Sábado 14 de noviembre')));
    await tester.pump();
    expect(find.text('Sábado 14 de noviembre'), findsOneWidget);
    // Ahora también en la lista del día elegido, con las otras dos.
    expect(find.text('08:00 a 09:00 · Electricidad'), findsNWidgets(2));
    expect(find.text('16:00 a 17:00 · Cerrajería'), findsOneWidget);
  });

  group('estado de la visita desde la fila', () {
    Map<String, dynamic> fila({
      String estadoSolicitud = 'aceptada',
      String? reagenda,
      String? reagendaPor,
      String inicio = '2026-11-20T16:00:00Z',
    }) => {
      'id': 'c1',
      'tecnico_id': 't1',
      'precio_base': 15,
      'inicio_visita': inicio,
      'fin_visita': null,
      'reagenda_inicio': reagenda,
      'reagenda_por': reagendaPor,
      'solicitud': {
        'id': 's1',
        'descripcion': ' Fuga ',
        'estado': estadoSolicitud,
        'cliente_id': 'c9',
        'oficios': {'nombre': 'Plomería'},
        'cliente': {'nombres': 'Ana', 'apellidos': 'Paredes'},
      },
      'perfiles_tecnicos': {
        'usuarios': {'nombres': 'Marco', 'apellidos': 'Vinueza'},
      },
    };

    VisitaAgenda leer(Map<String, dynamic> f, {bool esCliente = true}) =>
        VisitaAgendaModel.desdeFila(
          f,
          esCliente: esCliente,
          miId: 'c9',
          ahora: DateTime.utc(2026, 11, 13),
        )!;

    test('futura: agendada, con la otra persona según el rol', () {
      final v = leer(fila());
      expect(v.estado, EstadoVisita.agendada);
      expect(v.otraPersonaNombre, 'Marco Vinueza');
      expect(v.descripcion, 'Fuga');
      expect(v.fin.difference(v.inicio), const Duration(hours: 1));
      expect(leer(fila(), esCliente: false).otraPersonaNombre, 'Ana Paredes');
    });

    test('trabajo terminado sin cerrar: en curso', () {
      expect(
        leer(fila(estadoSolicitud: 'por_confirmar')).estado,
        EstadoVisita.enCurso,
      );
    });

    test(
      'reagenda pendiente: por confirmar; me toca si la propuso el otro',
      () {
        final otro = leer(
          fila(reagenda: '2026-11-21T16:00:00Z', reagendaPor: 't1'),
        );
        expect(otro.estado, EstadoVisita.porConfirmar);
        expect(otro.meTocaConfirmar, isTrue);
        final mia = leer(
          fila(reagenda: '2026-11-21T16:00:00Z', reagendaPor: 'c9'),
        );
        expect(mia.meTocaConfirmar, isFalse);
      },
    );
  });
}
