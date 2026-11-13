import '../entities/anuncio.dart';

abstract interface class AnuncioRepository {
  /// Anuncios activos y vigentes de [ubicacion].
  Future<List<Anuncio>> vigentes(UbicacionAnuncio ubicacion);
}
