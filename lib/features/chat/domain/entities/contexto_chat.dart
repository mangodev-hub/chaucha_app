import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import 'conversacion.dart';

class ContextoChat {
  const ContextoChat({
    required this.conversacion,
    required this.estadoSolicitud,
    this.oferta,
  });

  final Conversacion conversacion;
  final EstadoSolicitud estadoSolicitud;

  /// Oferta del técnico de esta conversación. Null si no se encontró.
  final Cotizacion? oferta;
}
