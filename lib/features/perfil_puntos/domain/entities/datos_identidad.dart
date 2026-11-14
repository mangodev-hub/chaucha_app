class DatosIdentidad {
  const DatosIdentidad({
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    this.codigoDactilar,
  });

  final String nombres;
  final String apellidos;
  final String cedula;
  final String? codigoDactilar;
}
