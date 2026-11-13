import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/chat/domain/usecases/obtener_contexto_chat.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';

import '../solicitudes/falsos.dart';
import 'falsos.dart';

void main() {
  test('junta la conversación, el estado de la solicitud y la oferta '
      'del técnico de esa conversación', () async {
    final cotizaciones = CotizacionesFalsas()
      ..deLaSolicitud = [
        cotizacionDePrueba(id: 'q9', tecnicoId: 't9'),
        cotizacionDePrueba(id: 'q1', tecnicoId: 't1'),
      ];
    final caso = ObtenerContextoChat(
      chat: ChatFalso(),
      solicitudes: SolicitudesFalsas(),
      cotizaciones: cotizaciones,
    );

    final contexto = await caso('k1');

    expect(contexto.conversacion.id, 'k1');
    expect(contexto.estadoSolicitud, EstadoSolicitud.abierta);
    expect(contexto.oferta?.id, 'q1');
  });

  test('sin oferta de ese técnico, la oferta es null', () async {
    final caso = ObtenerContextoChat(
      chat: ChatFalso(),
      solicitudes: SolicitudesFalsas(),
      cotizaciones: CotizacionesFalsas(),
    );

    expect((await caso('k1')).oferta, isNull);
  });
}
