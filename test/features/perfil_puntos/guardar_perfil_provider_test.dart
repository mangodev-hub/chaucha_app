import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/data/repositories/supabase_perfil_repository.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/calificacion_pendiente.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/cambios_perfil.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/nivel.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/nueva_resena.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_publico.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_tecnico.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/repositories/perfil_repository.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';

class _PerfilFalso implements PerfilRepository {
  @override
  Future<PerfilPublico> perfilPublico(String tecnicoId) =>
      throw UnimplementedError();

  @override
  Future<List<Nivel>> niveles() async => const [];

  @override
  Future<List<CalificacionPendiente>> calificacionesPendientes() async =>
      const [];

  int cargas = 0;
  final guardados = <CambiosPerfil>[];
  AppFailure? fallaAlGuardar;

  @override
  Future<PerfilTecnico> miPerfilTecnico() async {
    cargas++;
    return const PerfilTecnico(
      usuarioId: 't1',
      tarifaBase: 10,
      rangoCoberturaM: 5000,
      puntos: 0,
      calificacionPromedio: 0,
      totalResenas: 0,
      verificado: false,
      nivelNombre: 'Bronce',
      comisionPorcentaje: 12,
      oficioIds: [1],
    );
  }

  @override
  Future<void> guardar(CambiosPerfil cambios) async {
    final falla = fallaAlGuardar;
    if (falla != null) throw falla;
    guardados.add(cambios);
  }

  @override
  Future<void> crearResena(NuevaResena resena) async {}
}

CambiosPerfil _cambios({Set<int> oficios = const {1, 2}}) => CambiosPerfil(
  tarifaBase: 20,
  rangoCoberturaM: 3000,
  ubicacion: const LatLng(-0.2, -78.5),
  oficioIds: oficios,
);

void main() {
  late _PerfilFalso perfil;
  late ProviderContainer container;

  setUp(() async {
    perfil = _PerfilFalso();
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        perfilRepositoryProvider.overrideWithValue(perfil),
        usuarioActualProvider.overrideWith((ref) => null),
      ],
    );
    container
      ..listen(perfilTecnicoProvider, (_, _) {})
      ..listen(guardarPerfilProvider, (_, _) {});
    await container.read(perfilTecnicoProvider.future);
  });

  GuardarPerfilNotifier notifier() =>
      container.read(guardarPerfilProvider.notifier);

  test('rechaza guardar sin oficios y no llama al repositorio', () async {
    expect(await notifier().guardar(_cambios(oficios: {})), isFalse);

    expect(perfil.guardados, isEmpty);
    final error = container.read(guardarPerfilProvider).error;
    expect((error! as AppFailure).message, 'Selecciona al menos un oficio.');
  });

  test('guarda y recarga el perfil', () async {
    expect(perfil.cargas, 1);

    expect(await notifier().guardar(_cambios()), isTrue);
    await container.read(perfilTecnicoProvider.future);

    expect(perfil.guardados.single.oficioIds, {1, 2});
    expect(perfil.cargas, 2);
  });

  test('si falla deja el error y no recarga el perfil', () async {
    perfil.fallaAlGuardar = const AppFailure('No tienes permiso.');

    expect(await notifier().guardar(_cambios()), isFalse);
    await container.read(perfilTecnicoProvider.future);

    final error = container.read(guardarPerfilProvider).error;
    expect((error! as AppFailure).message, 'No tienes permiso.');
    expect(perfil.cargas, 1);
  });
}
