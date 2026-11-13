import '../entities/solicitud_en_mapa.dart';

abstract interface class MapaTecnicoRepository {
  /// Solicitudes abiertas de mis oficios dentro de mi radio, la más cercana
  /// primero. Vacía si no estoy verificado.
  Future<List<SolicitudEnMapa>> solicitudesEnMapa();

  /// Guarda mi radio de cobertura (1 a 30 km).
  Future<void> actualizarMiRadio(int metros);
}
