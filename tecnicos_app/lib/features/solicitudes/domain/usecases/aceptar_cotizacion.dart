// El cliente acepta una cotización: se acepta esa, se rechazan las demás
// pendientes y la solicitud pasa a "aceptada".
//
// OJO: no es atómico (dos repositorios, varias escrituras). Cuando backend
// cree la función RPC `aceptar_cotizacion` en Supabase, este caso de uso se
// reemplaza por esa única llamada.
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/domain/repositories/cotizacion_repository.dart';
import '../entities/solicitud.dart';
import '../repositories/solicitud_repository.dart';

class AceptarCotizacion {
  const AceptarCotizacion({
    required this._cotizaciones,
    required this._solicitudes,
  });

  final CotizacionRepository _cotizaciones;
  final SolicitudRepository _solicitudes;

  Future<void> call(Cotizacion cotizacion) async {
    await _cotizaciones.aceptar(cotizacion);
    await _solicitudes.cambiarEstado(
      cotizacion.solicitudId,
      EstadoSolicitud.aceptada,
    );
  }
}
