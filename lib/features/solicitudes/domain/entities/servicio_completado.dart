class ServicioCompletado {
  const ServicioCompletado({
    required this.solicitudId,
    required this.descripcion,
    required this.oficioNombre,
    required this.completadaEn,
    required this.tecnicoId,
    required this.tecnicoNombre,
    this.precioVisita,
    this.tecnicoFotoRuta,
    this.tecnicoCalificacion = 0,
    this.tecnicoTotalResenas = 0,
    this.miCalificacion,
  });

  final String solicitudId;
  final String descripcion;
  final String oficioNombre;
  final DateTime completadaEn;
  final double? precioVisita;
  final String tecnicoId;
  final String tecnicoNombre;
  final String? tecnicoFotoRuta;
  final double tecnicoCalificacion;
  final int tecnicoTotalResenas;

  /// Estrellas que el cliente dio al técnico; null si aún no califica.
  final int? miCalificacion;
}
