// Junta la conversación, el estado de su solicitud y la oferta del técnico,
// para que el chat sepa qué se puede hacer con los tickets.
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/domain/repositories/cotizacion_repository.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/domain/repositories/solicitud_repository.dart';
import '../entities/contexto_chat.dart';
import '../repositories/chat_repository.dart';

class ObtenerContextoChat {
  const ObtenerContextoChat({
    required this._chat,
    required this._solicitudes,
    required this._cotizaciones,
  });

  final ChatRepository _chat;
  final SolicitudRepository _solicitudes;
  final CotizacionRepository _cotizaciones;

  Future<ContextoChat> call(String conversacionId) async {
    final conversacion = await _chat.conversacion(conversacionId);
    // Future.wait (no `.wait` de records) para conservar el AppFailure.
    final resultados = await Future.wait<Object>([
      _solicitudes.obtener(conversacion.solicitudId),
      _cotizaciones.deSolicitud(conversacion.solicitudId),
    ]);
    final ofertas = resultados[1] as List<Cotizacion>;
    return ContextoChat(
      conversacion: conversacion,
      estadoSolicitud: (resultados[0] as Solicitud).estado,
      oferta: ofertas
          .where((o) => o.tecnicoId == conversacion.tecnicoId)
          .firstOrNull,
    );
  }
}
