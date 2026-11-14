import '../entities/oficio.dart';

abstract interface class OficioRepository {
  /// Lista los oficios ordenados por nombre. Lanza [AppFailure] si falla.
  Future<List<Oficio>> listar();
}
