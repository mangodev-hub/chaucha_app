import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/core/geo/geo_mapper.dart';
import 'package:tecnicos_app/core/widgets/check_animado.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/solicitudes/data/repositories/supabase_solicitud_repository.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/crear_solicitud_provider.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/listas_provider.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/widgets/solicitud_publicada.dart';

import 'falsos.dart';

void main() {
  group('CrearSolicitudNotifier', () {
    late SolicitudesFalsas solicitudes;
    late ProviderContainer container;

    setUp(() async {
      solicitudes = SolicitudesFalsas();
      container = ProviderContainer.test(
        retry: (_, _) => null,
        overrides: [
          solicitudRepositoryProvider.overrideWithValue(solicitudes),
          usuarioActualProvider.overrideWith(
            (ref) => usuarioDePrueba('c1', Rol.cliente),
          ),
        ],
      );
      container
        ..listen(misSolicitudesProvider, (_, _) {})
        ..listen(crearSolicitudProvider, (_, _) {});
      await container.read(misSolicitudesProvider.future);
    });

    Future<String?> crear({int? oficioId = 1}) => container
        .read(crearSolicitudProvider.notifier)
        .crear(
          oficioId: oficioId,
          descripcion: 'Gotea la llave',
          direccion: '',
          ubicacion: GeoMapper.quito,
          fotos: const [],
        );

    test('al publicar devuelve el id y recarga "Mis solicitudes"', () async {
      expect(await crear(), 'nueva');
      await container.read(misSolicitudesProvider.future);
      expect(solicitudes.consultasDeMisSolicitudes, 2);
    });

    test('si falla no recarga la lista y deja el error', () async {
      expect(await crear(oficioId: null), isNull);
      expect(container.read(crearSolicitudProvider).error, isA<AppFailure>());
      expect(solicitudes.consultasDeMisSolicitudes, 1);
    });
  });

  group('SolicitudPublicada', () {
    Future<List<String>> montar(WidgetTester tester) async {
      final toques = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolicitudPublicada(
              onVerSolicitud: () => toques.add('ver'),
              onVolver: () => toques.add('volver'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return toques;
    }

    testWidgets('muestra el éxito con el check animado', (tester) async {
      await montar(tester);
      expect(find.text('¡Solicitud registrada con éxito!'), findsOneWidget);
      expect(find.byType(CheckAnimado), findsOneWidget);
    });

    testWidgets('cada botón llama a su acción', (tester) async {
      final toques = await montar(tester);
      await tester.tap(find.text('Ver mi solicitud'));
      await tester.tap(find.text('Volver al inicio'));
      expect(toques, ['ver', 'volver']);
    });
  });
}
