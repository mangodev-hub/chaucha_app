class ResultadoRostro {
  const ResultadoRostro({
    required this.verificado,
    this.bloqueado = false,
    this.intentosRestantes = 0,
    this.motivo,
  });

  final bool verificado;

  /// Se agotaron los intentos de esta sesión: hay que volver a iniciarla.
  final bool bloqueado;
  final int intentosRestantes;

  /// Por qué no pasó (null si pasó).
  final String? motivo;
}
