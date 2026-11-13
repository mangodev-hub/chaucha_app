import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/reglas_tarifa.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/tarifa.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';

import '../solicitudes/falsos.dart';

const _tarifa = Tarifa(precioAcordado: 40);

void main() {
  group('ReglasTarifa.motivoParaNoEnviar', () {
    String? motivo({
      bool soyCliente = false,
      Cotizacion? oferta,
      bool sinOferta = false,
      EstadoSolicitud estadoSolicitud = EstadoSolicitud.cotizada,
    }) => ReglasTarifa.motivoParaNoEnviar(
      soyCliente: soyCliente,
      oferta: sinOferta ? null : oferta ?? cotizacionDePrueba(),
      estadoSolicitud: estadoSolicitud,
    );

    test('el técnico con su oferta pendiente puede enviar', () {
      expect(motivo(), isNull);
    });

    test('el cliente no envía tickets', () {
      expect(motivo(soyCliente: true), isNotNull);
    });

    test('sin oferta no puede enviar', () {
      expect(motivo(sinOferta: true), contains('oferta'));
    });

    test('con un ticket esperando respuesta no envía otro', () {
      expect(
        motivo(oferta: cotizacionDePrueba(tarifa: _tarifa)),
        contains('Espera'),
      );
    });

    test('con la oferta no pendiente o la solicitud cerrada no puede', () {
      expect(
        motivo(oferta: cotizacionDePrueba(estado: EstadoCotizacion.rechazada)),
        isNotNull,
      );
      expect(motivo(estadoSolicitud: EstadoSolicitud.aceptada), isNotNull);
    });
  });

  group('ReglasTarifa.puedeResponder', () {
    bool responder({
      bool soyCliente = true,
      Cotizacion? oferta,
      EstadoSolicitud estadoSolicitud = EstadoSolicitud.cotizada,
    }) => ReglasTarifa.puedeResponder(
      soyCliente: soyCliente,
      oferta: oferta,
      estadoSolicitud: estadoSolicitud,
    );

    test('el cliente responde un ticket pendiente', () {
      expect(responder(oferta: cotizacionDePrueba(tarifa: _tarifa)), isTrue);
    });

    test('el técnico no responde su propio ticket', () {
      expect(
        responder(
          soyCliente: false,
          oferta: cotizacionDePrueba(tarifa: _tarifa),
        ),
        isFalse,
      );
    });

    test('sin ticket, ya aceptado o con la solicitud cerrada no responde', () {
      expect(responder(oferta: cotizacionDePrueba()), isFalse);
      expect(
        responder(
          oferta: cotizacionDePrueba(
            tarifa: _tarifa,
            estado: EstadoCotizacion.aceptada,
          ),
        ),
        isFalse,
      );
      expect(
        responder(
          oferta: cotizacionDePrueba(tarifa: _tarifa),
          estadoSolicitud: EstadoSolicitud.cancelada,
        ),
        isFalse,
      );
    });
  });

  test('el total del ticket es el precio acordado', () {
    expect(const Tarifa(precioAcordado: 40).total, 40);
  });
}
