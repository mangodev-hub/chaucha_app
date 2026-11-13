import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/documento_tecnico.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/verificacion.dart';

DocumentoTecnico _doc(String id, TipoDocumento tipo, EstadoDocumento estado) =>
    DocumentoTecnico(id: id, tipo: tipo, estado: estado, ruta: '$id.jpg');

void main() {
  group('Verificacion.vigentes', () {
    test('prioriza aprobada > pendiente > rechazada sin importar el orden', () {
      final vigentes = Verificacion.vigentes([
        _doc('r', TipoDocumento.selfie, EstadoDocumento.rechazada),
        _doc('a', TipoDocumento.selfie, EstadoDocumento.aprobada),
        _doc('p', TipoDocumento.selfie, EstadoDocumento.pendiente),
        _doc('p2', TipoDocumento.cedulaFrontal, EstadoDocumento.pendiente),
        _doc('r2', TipoDocumento.cedulaFrontal, EstadoDocumento.rechazada),
      ]);

      expect(vigentes[TipoDocumento.selfie]?.id, 'a');
      expect(vigentes[TipoDocumento.cedulaFrontal]?.id, 'p2');
      expect(vigentes.containsKey(TipoDocumento.cedulaPosterior), isFalse);
    });
  });

  group('Verificacion.puedeSubir / todoEnviado', () {
    test('puede subir si no hay documento o si fue rechazado', () {
      final verificacion = Verificacion({
        TipoDocumento.cedulaFrontal: _doc(
          '1',
          TipoDocumento.cedulaFrontal,
          EstadoDocumento.pendiente,
        ),
        TipoDocumento.selfie: _doc(
          '2',
          TipoDocumento.selfie,
          EstadoDocumento.rechazada,
        ),
      });

      expect(verificacion.puedeSubir(TipoDocumento.cedulaFrontal), isFalse);
      expect(verificacion.puedeSubir(TipoDocumento.selfie), isTrue);
      expect(verificacion.puedeSubir(TipoDocumento.cedulaPosterior), isTrue);
      expect(verificacion.todoEnviado, isFalse);
    });

    test('todo enviado cuando ningún tipo se puede volver a subir', () {
      final verificacion = Verificacion({
        for (final tipo in TipoDocumento.values)
          tipo: _doc(tipo.name, tipo, EstadoDocumento.aprobada),
      });

      expect(verificacion.todoEnviado, isTrue);
    });
  });
}
