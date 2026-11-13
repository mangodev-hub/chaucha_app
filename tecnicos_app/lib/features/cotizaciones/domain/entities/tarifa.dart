class Tarifa {
  const Tarifa({required this.precioAcordado, this.fechaServicio});

  final double precioAcordado;

  final DateTime? fechaServicio;

  double get total => precioAcordado;
}

class NuevaTarifa {
  const NuevaTarifa({required this.precioAcordado, this.fechaServicio});

  final double precioAcordado;
  final DateTime? fechaServicio;
}
