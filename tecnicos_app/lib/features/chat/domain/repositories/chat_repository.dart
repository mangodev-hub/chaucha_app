// Contrato del chat. Los errores llegan como [AppFailure].
import '../entities/mensaje.dart';

abstract interface class ChatRepository {
  /// Devuelve el id de la conversación entre la solicitud y el técnico;
  /// la crea si todavía no existe.
  Future<String> obtenerOCrearConversacion({
    required String solicitudId,
    required String tecnicoId,
  });

  /// Mensajes de la conversación en tiempo real, del más antiguo al más nuevo.
  Stream<List<Mensaje>> mensajes(String conversacionId);

  Future<void> enviar({required String conversacionId, required String texto});
}
