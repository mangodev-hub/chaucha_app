/// Anuncio de un negocio externo. La app nunca se anuncia a sí misma en el
/// espacio publicitario.
class Anuncio {
  const Anuncio({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.anunciante,
    this.categoria = CategoriaAnuncio.otro,
    this.imagenUrl,
    this.urlDestino,
  });

  final String id;
  final String titulo;
  final String descripcion;

  /// Nombre del negocio que anuncia.
  final String? anunciante;
  final CategoriaAnuncio categoria;
  final String? imagenUrl;
  final String? urlDestino;
}

enum CategoriaAnuncio {
  ferreteria,
  restaurante,
  cafeteria,
  pinturas,
  lavanderia,
  materiales,
  otro,
}

/// Dónde se muestra un anuncio. Los anuncios "general" salen en todas.
enum UbicacionAnuncio { homeCliente, homeTecnico }
