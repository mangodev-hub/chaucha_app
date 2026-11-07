// Ids de solicitudes que el técnico conectado ya cotizó.
import '../models/cotizacion.dart';

abstract interface class CotizacionService {
  Future<List<Cotizacion>> deSolicitud(String solicitudId);

  Future<void> enviar(NuevaCotizacion nueva);


  Future<Set<String>> solicitudesCotizadasPorMi();



  Future<void> aceptar(Cotizacion cotizacion);
}
