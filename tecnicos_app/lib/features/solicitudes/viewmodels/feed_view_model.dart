// Feed del técnico: solicitudes de sus oficios dentro de su radio.
import '../../../core/geo/geo_mapper.dart';
import '../../../core/state/base_store.dart';
import '../../cotizaciones/services/cotizacion_service.dart';
import '../../perfil_puntos/models/perfil_tecnico.dart';
import '../../perfil_puntos/services/perfil_service.dart';
import '../models/solicitud.dart';
import '../services/solicitud_service.dart';

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
  final List<ItemFeed> items;
}







class FeedViewModel extends BaseStore<DatosFeed> {
  FeedViewModel({
    required SolicitudService solicitudService,
    required CotizacionService cotizacionService,
    required PerfilService perfilService,
  })  : _solicitudes = solicitudService,
        _cotizaciones = cotizacionService,
        _perfil = perfilService;

  final SolicitudService _solicitudes;
  final CotizacionService _cotizaciones;
  final PerfilService _perfil;

  Future<void> cargar() {
    return execute(() async {
      final perfil = await _perfil.miPerfilTecnico();
      final centro = perfil.ubicacionActual;
      if (!perfil.estaCompleto || centro == null) {
        return DatosFeed(perfil: perfil, items: const []);
      }

      final solicitudes = await _solicitudes.abiertasDeOficios(perfil.oficioIds);
      final cotizadas = await _cotizaciones.solicitudesCotizadasPorMi();

      final items = <ItemFeed>[];
      for (final solicitud in solicitudes) {
        final punto = solicitud.ubicacion;
        if (punto == null) continue;
        final distancia = GeoMapper.metrosEntre(centro, punto);
        if (distancia > perfil.rangoCoberturaM) continue;
        items.add(ItemFeed(
          solicitud: solicitud,
          distanciaMetros: distancia,
          yaCotice: cotizadas.contains(solicitud.id),
        ));
      }
      items.sort((a, b) => a.distanciaMetros.compareTo(b.distanciaMetros));
      return DatosFeed(perfil: perfil, items: items);
    });
  }
}
