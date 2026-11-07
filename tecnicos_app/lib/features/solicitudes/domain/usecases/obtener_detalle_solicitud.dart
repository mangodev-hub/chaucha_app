// Junta la solicitud, sus fotos y sus cotizaciones para la pantalla de detalle.
import '../../../auth/domain/entities/usuario.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/domain/repositories/cotizacion_repository.dart';
import '../entities/detalle_solicitud.dart';
import '../entities/foto_solicitud.dart';
import '../entities/solicitud.dart';
import '../repositories/solicitud_repository.dart';

class ObtenerDetalleSolicitud {
  const ObtenerDetalleSolicitud({
    required this._solicitudes,
    required this._cotizaciones,
  });

  final SolicitudRepository _solicitudes;
  final CotizacionRepository _cotizaciones;

  Future<DetalleSolicitud> call(String solicitudId, Usuario usuario) async {
    // Future.wait (no `.wait` de records) para que el AppFailure original
    // llegue intacto en vez de envuelto en un ParallelWaitError.
    final resultados = await Future.wait<Object>([
      _solicitudes.obtener(solicitudId),
      _solicitudes.fotos(solicitudId),
      _cotizaciones.deSolicitud(solicitudId),
    ]);
    return DetalleSolicitud(
      solicitud: resultados[0] as Solicitud,
      fotos: resultados[1] as List<FotoSolicitud>,
      cotizaciones: resultados[2] as List<Cotizacion>,
      usuario: usuario,
    );
  }
}
