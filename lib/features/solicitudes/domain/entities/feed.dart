// Feed del técnico: solicitudes de sus oficios dentro de su radio.
import '../../../perfil_puntos/domain/entities/perfil_tecnico.dart';
import 'solicitud.dart';

class ItemFeed {
  const ItemFeed({
    required this.solicitud,
    required this.distanciaMetros,
    required this.yaCotice,
  });

  final Solicitud solicitud;
  final double distanciaMetros;
  final bool yaCotice;
}

class DatosFeed {
  const DatosFeed({required this.perfil, required this.items});

  final PerfilTecnico perfil;

  /// Ordenados del más cercano al más lejano.
  final List<ItemFeed> items;
}
