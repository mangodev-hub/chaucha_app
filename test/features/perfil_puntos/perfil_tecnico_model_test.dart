import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/features/perfil_puntos/data/models/perfil_tecnico_model.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_tecnico.dart';

PerfilTecnico _leer(Map<String, dynamic> json) =>
    PerfilTecnicoModel.fromJson(json).aEntidad();

void main() {
  group('PerfilTecnicoModel.fromJson', () {
    test('lee el perfil completo con sus joins', () {
      final perfil = _leer({
        'usuario_id': 't1',
        'tarifa_base': '15.50',
        'rango_cobertura_m': 8000,
        'ubicacion_actual': {
          'type': 'Point',
          'coordinates': [-78.5, -0.2],
        },
        'puntos': 120,
        'calificacion_promedio': 4.8,
        'total_resenas': 10,
        'verificado': true,
        'niveles_gamificacion': {'nombre': 'Oro', 'comision_porcentaje': 8},
        'tecnico_oficios': [
          {'oficio_id': 1},
          {'oficio_id': 3},
        ],
      });

      expect(perfil.usuarioId, 't1');
      expect(perfil.tarifaBase, 15.5);
      expect(perfil.rangoCoberturaM, 8000);
      expect(perfil.ubicacionActual, const LatLng(-0.2, -78.5));
      expect(perfil.puntos, 120);
      expect(perfil.calificacionPromedio, 4.8);
      expect(perfil.totalResenas, 10);
      expect(perfil.verificado, isTrue);
      expect(perfil.nivelNombre, 'Oro');
      expect(perfil.comisionPorcentaje, 8);
      expect(perfil.oficioIds, [1, 3]);
      expect(perfil.estaCompleto, isTrue);
    });

    test('lee la ubicación en formato WKT', () {
      final perfil = _leer({
        'usuario_id': 't1',
        'ubicacion_actual': 'SRID=4326;POINT(-78.5 -0.2)',
      });

      expect(perfil.ubicacionActual, const LatLng(-0.2, -78.5));
    });

    test('aplica valores por defecto cuando faltan datos', () {
      final perfil = _leer({'usuario_id': 't1'});

      expect(perfil.rangoCoberturaM, 5000);
      expect(perfil.nivelNombre, 'Sin nivel');
      expect(perfil.comisionPorcentaje, 0);
      expect(perfil.verificado, isFalse);
      expect(perfil.oficioIds, isEmpty);
      expect(perfil.ubicacionActual, isNull);
      expect(perfil.estaCompleto, isFalse);
    });

    test('acepta el nivel como lista de un elemento', () {
      final perfil = _leer({
        'usuario_id': 't1',
        'niveles_gamificacion': [
          {'nombre': 'Plata', 'comision_porcentaje': 10},
        ],
      });

      expect(perfil.nivelNombre, 'Plata');
      expect(perfil.comisionPorcentaje, 10);
    });
  });
}
