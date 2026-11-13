import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/features/solicitudes/data/models/solicitud_db.dart';
import 'package:tecnicos_app/features/solicitudes/data/models/solicitud_model.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/foto_solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';

Map<String, dynamic> _fila({Object? oficios, String estado = 'abierta'}) => {
  'id': 's1',
  'cliente_id': 'c1',
  'oficio_id': '3',
  'descripcion': 'Gotea la llave',
  'ubicacion': 'SRID=4326;POINT(-78.47 -0.18)',
  'direccion_referencia': 'Portón negro',
  'estado': estado,
  'creado_en': '2026-11-07T10:00:00Z',
  'oficios': oficios,
};

Solicitud _leer(Map<String, dynamic> fila) =>
    SolicitudModel.fromJson(fila).aEntidad();

void main() {
  group('SolicitudModel.fromJson', () {
    test('lee los campos, el oficio del join y la ubicación', () {
      final s = _leer(_fila(oficios: {'nombre': 'Plomería'}));

      expect(s.id, 's1');
      expect(s.clienteId, 'c1');
      expect(s.oficioId, 3);
      expect(s.oficioNombre, 'Plomería');
      expect(s.ubicacion, const LatLng(-0.18, -78.47));
      expect(s.direccionReferencia, 'Portón negro');
      expect(s.estado, EstadoSolicitud.abierta);
    });

    test('acepta el join como lista y usa "Oficio" si no llega', () {
      expect(
        _leer(
          _fila(
            oficios: [
              {'nombre': 'Gasfitería'},
            ],
          ),
        ).oficioNombre,
        'Gasfitería',
      );
      expect(_leer(_fila()).oficioNombre, 'Oficio');
    });

    test('lee "por_confirmar" de la base', () {
      expect(
        _leer(_fila(estado: 'por_confirmar')).estado,
        EstadoSolicitud.porConfirmar,
      );
    });
  });

  group('mapeo de enums', () {
    test('ida y vuelta para cada estado de solicitud', () {
      for (final estado in EstadoSolicitud.values) {
        expect(EstadoSolicitudDb.desdeDb(estado.valorDb), estado);
      }
    });

    test('un estado desconocido lanza FormatException', () {
      expect(() => EstadoSolicitudDb.desdeDb('borrada'), throwsFormatException);
    });

    test('tipo de archivo: solo "evidencia" es evidencia', () {
      expect(TipoArchivoDb.desdeDb('evidencia'), TipoArchivo.evidencia);
      expect(TipoArchivoDb.desdeDb('problema'), TipoArchivo.problema);
      expect(TipoArchivoDb.desdeDb(null), TipoArchivo.problema);
    });
  });

  test('recibeCotizaciones solo en abierta y cotizada', () {
    final reciben = EstadoSolicitud.values.where((e) => e.recibeCotizaciones);
    expect(reciben, [EstadoSolicitud.abierta, EstadoSolicitud.cotizada]);
  });
}
