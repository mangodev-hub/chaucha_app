import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/admin/data/repositories/supabase_admin_repository.dart';
import 'package:tecnicos_app/features/admin/domain/entities/usuario_admin.dart';
import 'package:tecnicos_app/features/admin/presentation/providers/admin_providers.dart';
import 'package:tecnicos_app/features/admin/presentation/views/admin_verificaciones_view.dart';
import 'package:tecnicos_app/features/auth/domain/entities/registro_datos.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';

import 'falsos.dart';

final _admin = Usuario(
  id: 'a1',
  rol: Rol.admin,
  nombres: 'Admin',
  apellidos: '',
  creadoEn: DateTime(2026),
  perfilCompleto: false,
);

void main() {
  late AdminFalso repo;
  late ProviderContainer container;

  setUp(() async {
    repo = AdminFalso();
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        adminRepositoryProvider.overrideWithValue(repo),
        usuarioActualProvider.overrideWith((ref) => _admin),
      ],
    );
    container
      ..listen(usuariosAdminProvider, (_, _) {})
      ..listen(revisionesProvider, (_, _) {})
      ..listen(resumenAdminProvider, (_, _) {});
    await container.read(usuariosAdminProvider.future);
    await container.read(revisionesProvider.future);
    await container.read(resumenAdminProvider.future);
  });

  group('acciones sobre un usuario', () {
    AccionesUsuarioNotifier acciones() {
      container.listen(accionesUsuarioProvider('u1'), (_, _) {});
      return container.read(accionesUsuarioProvider('u1').notifier);
    }

    test(
      'suspender llama al repositorio y recarga la lista y el resumen',
      () async {
        expect(await acciones().suspender(suspendido: true), isTrue);
        expect(repo.suspensiones, [('u1', true)]);

        await container.read(usuariosAdminProvider.future);
        await container.read(resumenAdminProvider.future);
        expect(repo.consultasDeUsuarios, 2);
        expect(repo.consultasDeResumen, 2);
      },
    );

    test('editar envía los cambios', () async {
      const cambios = CambiosUsuario(
        nombres: 'Ana María',
        apellidos: 'Pérez',
        ciudad: 'Cuenca',
      );
      expect(await acciones().actualizar(cambios), isTrue);
      expect(repo.actualizados.single.$1, 'u1');
      expect(repo.actualizados.single.$2.ciudad, 'Cuenca');
    });

    test('si eliminar falla, deja el error y no recarga', () async {
      repo.falla = const AppFailure('Este usuario tiene solicitudes.');
      expect(await acciones().eliminar(), isFalse);
      expect(
        container.read(accionesUsuarioProvider('u1')).error,
        isA<AppFailure>(),
      );
      expect(repo.consultasDeUsuarios, 1);
    });
  });

  test('crear usuario recarga la lista', () async {
    container.listen(crearUsuarioProvider, (_, _) {});
    final ok = await container
        .read(crearUsuarioProvider.notifier)
        .crear(
          RegistroDatos(
            email: 'nuevo@correo.com',
            password: 'Clave1234',
            nombres: 'Nuevo',
            apellidos: 'Usuario',
            cedula: '1710034065',
            codigoDactilar: '',
            rol: Rol.tecnico,
          ),
        );
    expect(ok, isTrue);
    expect(repo.creados.single.email, 'nuevo@correo.com');
    await container.read(usuariosAdminProvider.future);
    expect(repo.consultasDeUsuarios, 2);
  });

  group('revisión de documentos', () {
    RevisionTecnicoNotifier revision() {
      container.listen(revisionTecnicoProvider('t1'), (_, _) {});
      return container.read(revisionTecnicoProvider('t1').notifier);
    }

    test('aprueba cada documento y recarga las revisiones', () async {
      expect(await revision().revisar(['d1', 'd3'], aprobado: true), isTrue);
      expect(repo.revisados, [('d1', true), ('d3', true)]);
      await container.read(revisionesProvider.future);
      expect(repo.consultasDeRevisiones, 2);
    });

    test('sin documentos no hace nada', () async {
      expect(await revision().revisar([], aprobado: true), isFalse);
      expect(repo.revisados, isEmpty);
    });
  });

  group('TarjetaRevision', () {
    Future<void> montar(WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: TarjetaRevision(revision: revisionDePrueba()),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('muestra el técnico, sus documentos y cuántos faltan', (
      tester,
    ) async {
      await montar(tester);
      expect(find.text('Luis Andrade'), findsOneWidget);
      expect(find.text('2 por revisar'), findsOneWidget);
      expect(find.text('Cédula (frente)'), findsOneWidget);
      expect(find.text('Selfie'), findsOneWidget);
      expect(find.text('Aprobado'), findsOneWidget);
    });

    testWidgets('"Aprobar" aprueba solo los pendientes', (tester) async {
      await montar(tester);
      await tester.tap(find.text('Aprobar'));
      await tester.pump();
      expect(repo.revisados, [('d1', true), ('d3', true)]);
    });
  });
}
