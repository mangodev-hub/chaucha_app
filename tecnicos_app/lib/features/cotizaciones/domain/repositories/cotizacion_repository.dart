// Contrato de cotizaciones. Los métodos lanzan [AppFailure] si fallan.
import '../entities/cotizacion.dart';
import '../entities/nueva_cotizacion.dart';

abstract interface class CotizacionRepository {
  /// Cotizaciones de una solicitud, de la más antigua a la más nueva.
  Future<List<Cotizacion>> deSolicitud(String solicitudId);

  /// Envía la cotización a nombre del técnico conectado.
  Future<void> enviar(NuevaCotizacion nueva);

  /// Ids de las solicitudes que el técnico conectado ya cotizó.
  Future<Set<String>> solicitudesCotizadasPorMi();

  /// Acepta [cotizacion] y rechaza las demás pendientes de la misma
  /// solicitud. El estado de la solicitud lo cambia el caso de uso
  /// `AceptarCotizacion` (feature solicitudes).
  Future<void> aceptar(Cotizacion cotizacion);
}
