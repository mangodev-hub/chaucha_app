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
