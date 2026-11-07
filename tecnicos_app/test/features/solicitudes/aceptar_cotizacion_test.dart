import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/usecases/aceptar_cotizacion.dart';

import 'falsos.dart';

void main() {
  late SolicitudesFalsas solicitudes;
  late CotizacionesFalsas cotizaciones;
  late AceptarCotizacion aceptar;

  setUp(() {
    solicitudes = SolicitudesFalsas();
    cotizaciones = CotizacionesFalsas();
    aceptar = AceptarCotizacion(
      cotizaciones: cotizaciones,
      solicitudes: solicitudes,
    );
  });

  test('acepta la cotización y deja la solicitud aceptada', () async {
    await aceptar(cotizacionDePrueba(id: 'q1', solicitudId: 's9'));

    expect(cotizaciones.aceptadas, ['q1']);
    expect(solicitudes.cambiosDeEstado, [('s9', EstadoSolicitud.aceptada)]);
  });

  test('si falla aceptar la cotización no toca la solicitud', () async {
    cotizaciones.fallaAlAceptar = const AppFailure('No tienes permiso.');

    await expectLater(
      aceptar(cotizacionDePrueba()),
      throwsA(isA<AppFailure>()),
    );
    expect(solicitudes.cambiosDeEstado, isEmpty);
  });
}
