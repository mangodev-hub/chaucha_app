// Ticket de trabajo: el precio que el técnico y el cliente acordaron por chat.
// El técnico lo envía desde el chat ("Empezar trabajo") sobre su oferta; el
// cliente lo confirma (se contrata al técnico) o lo rechaza.
class Tarifa {
  const Tarifa({
    required this.precioAcordado,
    this.materiales = 0,
    this.fechaServicio,
  });

  /// Precio del trabajo acordado (puede ser distinto del precio base).
  final double precioAcordado;

  /// Costo de materiales; 0 si no hay.
  final double materiales;

  /// Día en que se hará el servicio, si lo acordaron.
  final DateTime? fechaServicio;

  double get total => precioAcordado + materiales;
}

/// Datos con los que el técnico envía el ticket.
class NuevaTarifa {
  const NuevaTarifa({
    required this.precioAcordado,
    this.materiales = 0,
    this.fechaServicio,
  });

  final double precioAcordado;
  final double materiales;
  final DateTime? fechaServicio;
}
