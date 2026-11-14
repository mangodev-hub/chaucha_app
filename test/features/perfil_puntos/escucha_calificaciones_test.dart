import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/notificaciones/domain/entities/notificacion.dart';
import 'package:tecnicos_app/features/notificaciones/presentation/providers/notificaciones_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/data/repositories/supabase_perfil_repository.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/calificacion_pendiente.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/nueva_resena.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/repositories/perfil_repository.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/widgets/escucha_calificaciones.dart';

class _Repo implements PerfilRepository {
  _Repo(this.pendientes);

  final List<CalificacionPendiente> pendientes;
  final resenas = <NuevaResena>[];

  @override
  Future<List<CalificacionPendiente>> calificacionesPendientes() async =>
      pendientes;

  @override
  Future<void> crearResena(NuevaResena resena) async => resenas.add(resena);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Usuario _usuario(Rol rol) => Usuario(
  id: 'u1',
  rol: rol,
  nombres: 'Ana',
  apellidos: 'Pérez',
  creadoEn: DateTime(2026),
  verificado: true,
);

final _pendiente = CalificacionPendiente(
  solicitudId: 's1',
  destinatarioId: 't1',
  nombre: 'Luis Mora',
  paraTecnico: true,
  completadaEn: DateTime(2026, 11, 13),
  oficio: 'Plomería',
);

Future<_Repo> _montar(
  WidgetTester tester, {
  required Rol rol,
  List<CalificacionPendiente>? pendientes,
}) async {
  final repo = _Repo(pendientes ?? [_pendiente]);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(_usuario(rol)),
        perfilRepositoryProvider.overrideWithValue(repo),
        notificacionesNoLeidasProvider.overrideWith(
          (ref) => Stream.value(const <Notificacion>[]),
        ),
      ],
      child: const MaterialApp(
        home: EscuchaCalificaciones(child: Scaffold(body: Text('Inicio'))),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('con un servicio sin calificar, la hoja aparece sola', (
    tester,
  ) async {
    final repo = await _montar(tester, rol: Rol.cliente);

    expect(find.text('¿Cómo calificas al técnico?'), findsOneWidget);
    expect(find.text('Luis Mora'), findsOneWidget);
    expect(find.text('Servicio de Plomería terminado'), findsOneWidget);

    await tester.tap(find.byTooltip('5 estrellas'));
    await tester.pumpAndSettle();
    final enviar = find.widgetWithText(FilledButton, 'Calificar técnico');
    await tester.ensureVisible(enviar);
    await tester.tap(enviar);
    await tester.pumpAndSettle();

    expect(repo.resenas.single.solicitudId, 's1');
    expect(repo.resenas.single.destinatarioId, 't1');
    expect(repo.resenas.single.calificacion, 5);
  });

  testWidgets('sin pendientes no aparece nada', (tester) async {
    await _montar(tester, rol: Rol.tecnico, pendientes: const []);
    expect(find.textContaining('¿Cómo calificas'), findsNothing);
  });

  testWidgets('el admin no califica', (tester) async {
    await _montar(tester, rol: Rol.admin);
    expect(find.textContaining('¿Cómo calificas'), findsNothing);
  });
}
