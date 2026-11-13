import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_tecnico.dart';
import 'package:tecnicos_app/features/solicitudes/domain/usecases/obtener_feed_tecnico.dart';

import 'falsos.dart';

const _centro = LatLng(-0.18, -78.47);

PerfilTecnico _perfil({
  List<int> oficioIds = const [1],
  LatLng? ubicacion = _centro,
  int rango = 5000,
}) => PerfilTecnico(
  usuarioId: 't1',
  tarifaBase: 10,
  rangoCoberturaM: rango,
  puntos: 0,
  calificacionPromedio: 0,
  totalResenas: 0,
  verificado: false,
  nivelNombre: 'Bronce',
  comisionPorcentaje: 12,
  oficioIds: oficioIds,
  ubicacionActual: ubicacion,
);

/// Punto a [grados] de latitud al norte del centro (0,009° ≈ 1 km).
LatLng _alNorte(double grados) =>
    LatLng(_centro.latitude + grados, _centro.longitude);

void main() {
  late SolicitudesFalsas solicitudes;
  late CotizacionesFalsas cotizaciones;
  late ObtenerFeedTecnico obtenerFeed;

  setUp(() {
    solicitudes = SolicitudesFalsas();
    cotizaciones = CotizacionesFalsas();
    obtenerFeed = ObtenerFeedTecnico(
      solicitudes: solicitudes,
      cotizaciones: cotizaciones,
    );
  });

  test('perfil sin oficios: feed vacío y no consulta solicitudes', () async {
    final feed = await obtenerFeed(_perfil(oficioIds: const []));

    expect(feed.items, isEmpty);
    expect(solicitudes.consultasDeAbiertas, 0);
  });

  test('perfil sin ubicación: feed vacío', () async {
    final feed = await obtenerFeed(_perfil(ubicacion: null));

    expect(feed.items, isEmpty);
    expect(solicitudes.consultasDeAbiertas, 0);
  });

  test('filtra por radio, ordena por distancia y marca "ya coticé"', () async {
    solicitudes.abiertas = [
      solicitudDePrueba(id: 'a-2km', ubicacion: _alNorte(0.018)),
      solicitudDePrueba(id: 'lejos-33km', ubicacion: _alNorte(0.3)),
      solicitudDePrueba(id: 'sin-ubicacion'),
      solicitudDePrueba(id: 'a-500m', ubicacion: _alNorte(0.0045)),
    ];
    cotizaciones.cotizadasPorMi = {'a-2km'};

    final feed = await obtenerFeed(_perfil());

    expect(feed.items.map((i) => i.solicitud.id), ['a-500m', 'a-2km']);
    expect(feed.items.first.yaCotice, isFalse);
    expect(feed.items.last.yaCotice, isTrue);
    expect(feed.items.first.distanciaMetros, closeTo(500, 30));
  });
}
