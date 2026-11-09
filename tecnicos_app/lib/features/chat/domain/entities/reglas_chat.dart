// Reglas de negocio del chat entre cliente y técnico.
import 'mensaje.dart';

abstract final class ReglasChat {
  /// Solo el cliente inicia la conversación: el técnico puede escribir
  /// cuando el cliente ya envió al menos un mensaje.
  static bool puedeEscribir({
    required bool soyCliente,
    required String miId,
    required List<Mensaje> mensajes,
  }) => soyCliente || mensajes.any((m) => m.autorId != miId);
}
