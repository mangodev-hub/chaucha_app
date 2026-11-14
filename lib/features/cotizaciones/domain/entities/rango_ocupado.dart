class RangoOcupado {
  const RangoOcupado({required this.inicio, required this.fin});

  final DateTime inicio;
  final DateTime fin;

  bool seCruzaCon(DateTime desde, Duration duracion) =>
      desde.isBefore(fin) && inicio.isBefore(desde.add(duracion));
}
