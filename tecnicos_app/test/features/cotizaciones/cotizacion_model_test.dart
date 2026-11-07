import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/cotizaciones/data/models/cotizacion_model.dart';
import 'package:tecnicos_app/features/cotizaciones/data/models/estado_cotizacion_db.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';

Map<String, dynamic> _fila({
  Object? perfil,
  Object? total = 30,
  String estado = 'pendiente',
}) =>
    {
      'id': 'c1',
      'solicitud_id': 's1',
      'tecnico_id': 't1',
      'mano_obra': 25,
      'materiales': '5.50',
      'total': total,
      'detalle': 'Incluye repuestos',
      'estado': estado,
      'creado_en': '2026-11-07T10:00:00Z',
      'perfiles_tecnicos': perfil,
    };

const Map<String, dynamic> _perfil = {
  'calificacion_promedio': 4.5,
  'usuarios': {'nombres': 'Luis', 'apellidos': 'Mora'},
};

Cotizacion _leer(Map<String, dynamic> fila) =>
    CotizacionModel.fromJson(fila).aEntidad();

void main() {
  group('CotizacionModel.fromJson', () {
    test('lee los campos y el técnico del join como objeto', () {
      final c = _leer(_fila(perfil: _perfil));

      expect(c.id, 'c1');
      expect(c.solicitudId, 's1');
      expect(c.tecnicoId, 't1');
      expect(c.tecnicoNombre, 'Luis Mora');
      expect(c.tecnicoCalificacion, 4.5);
      expect(c.manoObra, 25);
      expect(c.materiales, 5.5); // Llega como texto desde `numeric`.
      expect(c.total, 30);
      expect(c.detalle, 'Incluye repuestos');
      expect(c.estado, EstadoCotizacion.pendiente);
    });

    test('acepta el join como lista de un elemento', () {
      final c = _leer(_fila(perfil: [_perfil]));

      expect(c.tecnicoNombre, 'Luis Mora');
      expect(c.tecnicoCalificacion, 4.5);
    });

    test('sin datos del técnico usa "Técnico" y calificación 0', () {
      final c = _leer(_fila(perfil: null));

      expect(c.tecnicoNombre, 'Técnico');
      expect(c.tecnicoCalificacion, 0);
    });

    test('si no llega el total lo calcula con mano de obra + materiales', () {
      final c = _leer(_fila(perfil: _perfil, total: null));

      expect(c.total, 30.5);
    });
  });

  group('EstadoCotizacionDb', () {
    test('ida y vuelta para cada estado', () {
      for (final estado in EstadoCotizacion.values) {
        expect(EstadoCotizacionDb.desdeDb(estado.valorDb), estado);
      }
    });

    test('lee los estados de la base', () {
      expect(
        _leer(_fila(estado: 'aceptada')).estado,
        EstadoCotizacion.aceptada,
      );
      expect(
        _leer(_fila(estado: 'rechazada')).estado,
        EstadoCotizacion.rechazada,
      );
    });

    test('un estado desconocido lanza FormatException', () {
      expect(
        () => EstadoCotizacionDb.desdeDb('cancelada'),
        throwsFormatException,
      );
    });
  });
}
