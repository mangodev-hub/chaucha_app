import 'package:latlong2/latlong.dart';

import '../entities/tecnico_cercano.dart';

abstract interface class InicioRepository {
  Future<List<TecnicoCercano>> tecnicosCercanos({
    required LatLng punto,
    required int radioM,
    int? oficioId,
    int limite = 20,
  });
}
