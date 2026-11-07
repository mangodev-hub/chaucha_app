import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import 'package:tecnicos_app/features/solicitudes/data/repositories/supabase_solicitud_repository.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/detalle_provider.dart';

import 'falsos.dart';

void main() {
  late SolicitudesFalsas solicitudes;
  late CotizacionesFalsas cotizaciones;
  late ProviderContainer container;

  setUp(() async {
    solicitudes = SolicitudesFalsas();
    cotizaciones = CotizacionesFalsas();
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        solicitudRepositoryProvider.overrideWithValue(solicitudes),
        cotizacionRepositoryProvider.overrideWithValue(cotizaciones),
        usuarioActualProvider.overrideWith(
          (ref) => usuarioDePrueba('c1', Rol.cliente),
        ),
      ],
    );
    container
      ..listen(detalleSolicitudProvider('s1'), (_, _) {})
      ..listen(accionesSolicitudProvider('s1'), (_, _) {});
    await container.read(detalleSolicitudProvider('s1').future);
  });

  AccionesSolicitudNotifier acciones() =>
      container.read(accionesSolicitudProvider('s1').notifier);

  test('cancelar cambia el estado y recarga el detalle', () async {
    expect(solicitudes.obtenidas, 1);

    expect(await acciones().cancelar(), isTrue);
    await container.read(detalleSolicitudProvider('s1').future);

    expect(solicitudes.cambiosDeEstado, [('s1', EstadoSolicitud.cancelada)]);
    expect(solicitudes.obtenidas, 2);
  });

  test('ignora una acción mientras otra sigue en curso', () async {
    solicitudes.cambioPendiente = Completer<void>();

    final primera = acciones().cancelar();
    expect(await acciones().confirmarTerminado(), isFalse);

    solicitudes.cambioPendiente!.complete();
    expect(await primera, isTrue);
    expect(solicitudes.cambiosDeEstado, [('s1', EstadoSolicitud.cancelada)]);
  });

  test('si falla deja el error y no recarga el detalle', () async {
    solicitudes.fallaAlCambiar = const AppFailure('No tienes permiso.');

    expect(await acciones().cancelar(), isFalse);
    await container.read(detalleSolicitudProvider('s1').future);

    final error = container.read(accionesSolicitudProvider('s1')).error;
    expect((error! as AppFailure).message, 'No tienes permiso.');
    expect(solicitudes.obtenidas, 1);
  });

  test('aceptar usa el caso de uso: cotización y estado de la solicitud', () async {
    expect(await acciones().aceptar(cotizacionDePrueba(id: 'q7')), isTrue);

    expect(cotizaciones.aceptadas, ['q7']);
    expect(solicitudes.cambiosDeEstado, [('s1', EstadoSolicitud.aceptada)]);
  });
}
