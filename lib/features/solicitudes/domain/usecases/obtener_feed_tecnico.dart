import '../../../../core/geo/geo_mapper.dart';
import '../../../cotizaciones/domain/repositories/cotizacion_repository.dart';
import '../../../perfil_puntos/domain/entities/perfil_tecnico.dart';
import '../entities/feed.dart';
import '../repositories/solicitud_repository.dart';

class ObtenerFeedTecnico {
  const ObtenerFeedTecnico({
    required this._solicitudes,
    required this._cotizaciones,
  });

  final SolicitudRepository _solicitudes;
  final CotizacionRepository _cotizaciones;

  Future<DatosFeed> call(PerfilTecnico perfil) async {
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
      if (distancia > perfil.rangoEfectivoM) continue;
      items.add(
        ItemFeed(
          solicitud: solicitud,
          distanciaMetros: distancia,
          yaCotice: cotizadas.contains(solicitud.id),
        ),
      );
    }
    items.sort((a, b) => a.distanciaMetros.compareTo(b.distanciaMetros));
    return DatosFeed(perfil: perfil, items: items);
  }
}
