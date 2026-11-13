import '../../domain/entities/anuncio.dart';

extension UbicacionAnuncioDb on UbicacionAnuncio {
  String get db => switch (this) {
    UbicacionAnuncio.homeCliente => 'home_cliente',
    UbicacionAnuncio.homeTecnico => 'home_tecnico',
  };

  /// Ubicación que sale en todas las pantallas.
  static const String general = 'general';
}

abstract final class AnuncioModel {
  static const String columnas =
      'id, titulo, descripcion, anunciante, categoria, imagen_ruta, '
      'url_destino, fecha_inicio, fecha_fin';

  /// La RLS ya filtra lo vigente; se revisa otra vez por si el reloj del
  /// servidor y el del teléfono no coinciden con una fecha en el borde.
  static bool vigente(Map<String, dynamic> fila, DateTime ahora) {
    final inicio = DateTime.tryParse(fila['fecha_inicio'] as String? ?? '');
    final fin = DateTime.tryParse(fila['fecha_fin'] as String? ?? '');
    return (inicio == null || !inicio.isAfter(ahora)) &&
        (fin == null || !fin.isBefore(ahora));
  }

  static Anuncio desdeFila(
    Map<String, dynamic> fila, {
    required String Function(String ruta) urlImagen,
  }) {
    final ruta = fila['imagen_ruta'] as String?;
    return Anuncio(
      id: fila['id'] as String,
      titulo: fila['titulo'] as String,
      descripcion: fila['descripcion'] as String? ?? '',
      anunciante: (fila['anunciante'] as String?)?.trim(),
      categoria: CategoriaAnuncio.values.firstWhere(
        (c) => c.name == fila['categoria'],
        orElse: () => CategoriaAnuncio.otro,
      ),
      imagenUrl: ruta == null || ruta.isEmpty ? null : urlImagen(ruta),
      urlDestino: fila['url_destino'] as String?,
    );
  }
}
