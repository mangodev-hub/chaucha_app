import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/chat/domain/entities/mensaje.dart';
import 'package:tecnicos_app/features/chat/domain/entities/reglas_chat.dart';

Mensaje _de(String autorId) => Mensaje(
  id: 'm-$autorId',
  conversacionId: 'k1',
  autorId: autorId,
  contenido: 'Hola',
  enviadoEn: DateTime(2026, 11, 8),
);

void main() {
  group('ReglasChat.puedeEscribir', () {
    test('el cliente puede escribir aunque no haya mensajes', () {
      expect(
        ReglasChat.puedeEscribir(soyCliente: true, miId: 'c1', mensajes: []),
        isTrue,
      );
    });

    test('el técnico no puede escribir primero', () {
      expect(
        ReglasChat.puedeEscribir(soyCliente: false, miId: 't1', mensajes: []),
        isFalse,
      );
    });

    test('el técnico puede responder cuando el cliente ya escribió', () {
      expect(
        ReglasChat.puedeEscribir(
          soyCliente: false,
          miId: 't1',
          mensajes: [_de('c1')],
        ),
        isTrue,
      );
    });

    test('sus propios mensajes no cuentan como inicio del cliente', () {
      expect(
        ReglasChat.puedeEscribir(
          soyCliente: false,
          miId: 't1',
          mensajes: [_de('t1')],
        ),
        isFalse,
      );
    });
  });
}
