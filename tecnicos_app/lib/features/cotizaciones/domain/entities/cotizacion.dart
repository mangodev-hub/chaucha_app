// Oferta de un técnico para una solicitud: su precio base y cómo resolvería
// el problema, con su nombre y calificación. El precio final se acuerda
// después por chat y queda en el ticket de trabajo ([tarifa]).
import 'tarifa.dart';

enum EstadoCotizacion { pendiente, aceptada, rechazada }

class Cotizacion {
  const Cotizacion({
    required this.id,
    required this.solicitudId,
    required this.tecnicoId,
    required this.tecnicoNombre,
    required this.tecnicoCalificacion,
    required this.precioBase,
    required this.estado,
    required this.creadoEn,
    this.solucion,
    this.tarifa,
  });

  final String id;
  final String solicitudId;
  final String tecnicoId;
  final String tecnicoNombre;
  final double tecnicoCalificacion;

  /// Precio desde el que parte el técnico. No cambia con el ticket.
  final double precioBase;

  /// Cómo resolvería el problema. Las ofertas antiguas pueden no tenerla.
  final String? solucion;
  final EstadoCotizacion estado;
  final DateTime creadoEn;

  /// Ticket de trabajo enviado por el técnico. Null si aún no lo envía (o si
  /// el cliente lo rechazó).
  final Tarifa? tarifa;

  /// El técnico envió el ticket y el cliente todavía no responde.
  bool get tarifaPendiente =>
      tarifa != null && estado == EstadoCotizacion.pendiente;
}
