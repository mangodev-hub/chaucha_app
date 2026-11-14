enum TipoArchivo { problema, evidencia }

class FotoSolicitud {
  const FotoSolicitud({required this.tipo, required this.url});

  final TipoArchivo tipo;

  /// URL firmada (el bucket es privado).
  final String url;
}
