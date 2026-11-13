import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/cotizaciones/data/models/cotizacion_model.dart';
import 'package:tecnicos_app/features/cotizaciones/data/models/estado_cotizacion_db.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';

Map<String, dynamic> _fila({
  Object? perfil,
  Object? precioBase = 25,
  Object? manoObra,
  Object? materiales = 0,
  Object? total,
  Object? detalle = 'Cambio el empaque de la llave.',
  Object? tarifaEnviada = false,
  Object? fechaServicio,
  String estado = 'pendiente',
}) => {
  'id': 'c1',
  'solicitud_id': 's1',
  'tecnico_id': 't1',
  'precio_base': precioBase,
  'mano_obra': manoObra,
  'materiales': materiales,
  'total': total,
  'detalle': detalle,
  'tarifa_enviada': tarifaEnviada,
  'fecha_servicio': fechaServicio,
  'estado': estado,
  'creado_en': '2026-11-07T10:00:00Z',
  'perfiles_tecnicos': perfil,
};

const Map<String, dynamic> _perfil = {
  'calificacion_promedio': 4.5,
  'usuarios': {'nombres': 'Luis', 'apellidos': 'Mora'},
};

Cotizacion _leer(Map<String, dynamic> fila) => CotizacionModel.desdeFila(fila);

void main() {
  group('CotizacionModel.desdeFila', () {
    test('lee la oferta y el técnico del join como objeto', () {
      final c = _leer(_fila(perfil: _perfil));

      expect(c.id, 'c1');
      expect(c.solicitudId, 's1');
      expect(c.tecnicoId, 't1');
      expect(c.tecnicoNombre, 'Luis Mora');
      expect(c.tecnicoCalificacion, 4.5);
      expect(c.precioBase, 25);
      expect(c.solucion, 'Cambio el empaque de la llave.');
      expect(c.estado, EstadoCotizacion.pendiente);
      expect(c.tarifa, isNull);
      expect(c.tarifaPendiente, isFalse);
    });

    test('acepta el join como lista de un elemento', () {
      final c = _leer(_fila(perfil: [_perfil]));

      expect(c.tecnicoNombre, 'Luis Mora');
      expect(c.tecnicoCalificacion, 4.5);
    });

    test('sin datos del técnico usa "Técnico" y calificación 0', () {
      final c = _leer(_fila());

      expect(c.tecnicoNombre, 'Técnico');
      expect(c.tecnicoCalificacion, 0);
    });

    test('con tarifa_enviada lee el ticket; el precio base no cambia', () {
      final c = _leer(
        _fila(
          manoObra: '45.50', // Llega como texto desde `numeric`.
          materiales: 10,
          total: 55.5,
          tarifaEnviada: true,
          fechaServicio: '2026-11-12T17:00:00Z',
        ),
      );

      expect(c.precioBase, 25);
      expect(c.tarifa?.precioAcordado, 45.5);
      // El total del ticket es el precio acordado: los materiales ya no
      // forman parte del ticket.
      expect(c.tarifa?.total, 45.5);
      expect(c.tarifa?.fechaServicio, isNotNull);
      expect(c.tarifaPendiente, isTrue);
    });

    test('una oferta aceptada con ticket ya no está pendiente', () {
      final c = _leer(
        _fila(manoObra: 40, tarifaEnviada: true, estado: 'aceptada'),
      );

      expect(c.tarifa, isNotNull);
      expect(c.tarifaPendiente, isFalse);
    });

    test('ofertas antiguas sin precio_base usan mano de obra + materiales', () {
      final c = _leer(
        _fila(precioBase: null, manoObra: '25', materiales: '5.50'),
      );

      expect(c.precioBase, 30.5);
      expect(c.tarifa, isNull);
    });

    test('una solución vacía se lee como null', () {
      expect(_leer(_fila(detalle: '   ')).solucion, isNull);
      expect(_leer(_fila(detalle: null)).solucion, isNull);
    });
  });

  test('filaNueva guarda la solución sin espacios extra, sin ticket', () {
    final fila = CotizacionModel.filaNueva(
      solicitudId: 's1',
      tecnicoId: 't1',
      solucion: '  Reviso la instalación.  ',
    );

    expect(fila, {
      'solicitud_id': 's1',
      'tecnico_id': 't1',
      'detalle': 'Reviso la instalación.',
      'materiales': 0,
    });
  });

  test('cambiosRechazo desmarca el ticket', () {
    expect(CotizacionModel.cambiosRechazo, {'tarifa_enviada': false});
  });

  group('EstadoCotizacionDb', () {
    test('ida y vuelta para cada estado', () {
      for (final estado in EstadoCotizacion.values) {
        expect(EstadoCotizacionDb.desdeDb(estado.valorDb), estado);
      }
    });

    test('un estado desconocido lanza FormatException', () {
      expect(() => EstadoCotizacionDb.desdeDb('otro'), throwsFormatException);
    });
  });
}
