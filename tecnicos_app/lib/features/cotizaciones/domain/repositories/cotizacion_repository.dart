// Contrato de las ofertas de los técnicos (tabla `cotizaciones`). Los métodos
// lanzan [AppFailure] si fallan.
import '../entities/cotizacion.dart';
import '../entities/nueva_cotizacion.dart';
import '../entities/tarifa.dart';

abstract interface class CotizacionRepository {
  /// Ofertas de una solicitud, de la más antigua a la más nueva.
  Future<List<Cotizacion>> deSolicitud(String solicitudId);

  /// Envía la oferta (precio de la visita y solución) a nombre del técnico conectado.
  Future<void> enviar(NuevaCotizacion nueva);

  /// Ofertas del técnico conectado, de la más nueva a la más antigua.
  Future<List<Cotizacion>> misOfertas();

  /// Ids de las solicitudes en las que el técnico conectado ya ofertó.
  Future<Set<String>> solicitudesCotizadasPorMi();

  /// Acepta [cotizacion], rechaza las demás pendientes de la misma solicitud
  /// y marca la solicitud como aceptada, en una sola transacción. Es lo que
  /// hace el cliente al confirmar el ticket de trabajo.
  Future<void> aceptar(Cotizacion cotizacion);

  /// El técnico conectado envía el ticket de trabajo sobre su oferta
  /// pendiente. El precio de la visita no cambia.
  Future<void> enviarTarifa(String cotizacionId, NuevaTarifa tarifa);

  /// El cliente rechaza el ticket; el técnico puede enviar otro.
  Future<void> rechazarTarifa(String cotizacionId);

  Future<List<Cotizacion>> deSolicitudes(List<String> solicitudIds);

  /// Propone otra fecha para la visita; la otra persona debe aceptarla.
  Future<void> proponerReagendado(String cotizacionId, DateTime nuevaFecha);

  /// La otra persona acepta o rechaza la propuesta.
  Future<void> responderReagendado(String cotizacionId, {required bool acepta});

  /// El técnico cancela la visita; la solicitud vuelve a cotizada.
  Future<void> cancelarVisita(String cotizacionId);
}
