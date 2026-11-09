import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/perfil_puntos/data/models/perfil_publico_model.dart';

const Map<String, dynamic> _perfil = {
  'usuario_id': 't1',
  'verificado': true,
  'calificacion_promedio': '4.75',
  'total_resenas': 2,
  'niveles_gamificacion': {'nombre': 'Experto'},
  'usuarios': {'nombres': 'Luis', 'apellidos': 'Mora'},
  'tecnico_oficios': [
    {
      'oficios': {'nombre': 'Plomería'},
    },
    {
      'oficios': [
        {'nombre': 'Electricidad'},
      ],
    },
    {'oficios': null},
  ],
};

void main() {
  group('PerfilPublicoModel.desdeFilas', () {
    test('lee el perfil, los joins y las reseñas', () {
      final p = PerfilPublicoModel.desdeFilas(_perfil, [
        {
          'calificacion': 5,
          'comentario': '  Muy puntual.  ',
          'creado_en': '2026-11-08T10:00:00Z',
          'autor': {'nombres': 'Ana María', 'apellidos': 'Pérez López'},
        },
        {
          'calificacion': 4,
          'comentario': '',
          'creado_en': '2026-11-01T10:00:00Z',
          'autor': [
            {'nombres': 'Jorge', 'apellidos': ''},
          ],
        },
      ]);

      expect(p.tecnicoId, 't1');
      expect(p.nombre, 'Luis Mora');
      expect(p.verificado, isTrue);
      expect(p.nivelNombre, 'Experto');
      expect(p.calificacionPromedio, 4.75);
      expect(p.totalResenas, 2);
      expect(p.esNuevo, isFalse);
      // Ordenados y sin los oficios que no llegaron.
      expect(p.oficios, ['Electricidad', 'Plomería']);

      expect(p.resenas, hasLength(2));
      expect(p.resenas[0].autor, 'Ana P.');
      expect(p.resenas[0].calificacion, 5);
      expect(p.resenas[0].comentario, 'Muy puntual.');
      expect(p.resenas[1].autor, 'Jorge');
      expect(p.resenas[1].comentario, isNull);
    });

    test('sin datos opcionales usa valores por defecto', () {
      final p = PerfilPublicoModel.desdeFilas({'usuario_id': 't2'}, const []);

      expect(p.nombre, 'Técnico');
      expect(p.verificado, isFalse);
      expect(p.nivelNombre, 'Inicial');
      expect(p.totalResenas, 0);
      expect(p.esNuevo, isTrue);
      expect(p.oficios, isEmpty);
      expect(p.resenas, isEmpty);
    });
  });

  test('nombreCorto oculta el apellido completo del autor', () {
    expect(
      PerfilPublicoModel.nombreCorto({'nombres': 'Ana', 'apellidos': 'Pérez'}),
      'Ana P.',
    );
    expect(PerfilPublicoModel.nombreCorto(null), 'Cliente');
  });
}
