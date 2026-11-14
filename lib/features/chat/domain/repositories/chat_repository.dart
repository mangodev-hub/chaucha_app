import '../entities/conversacion.dart';
import '../entities/conversacion_pendiente.dart';
import '../entities/mensaje.dart';
import '../entities/resumen_chat.dart';

abstract interface class ChatRepository {
  /// Datos de una conversación (de qué solicitud y con qué técnico).
  Future<Conversacion> conversacion(String conversacionId);

  /// Conversaciones del técnico conectado en las que el cliente escribió
  /// último, de la más reciente a la más antigua.
  Future<List<ConversacionPendiente>> porResponder();

  /// Devuelve el id de la conversación entre la solicitud y el técnico;
  /// la crea si todavía no existe.
  Future<String> obtenerOCrearConversacion({
    required String solicitudId,
    required String tecnicoId,
  });

  /// Mensajes de la conversación en tiempo real, del más antiguo al más nuevo.
  Stream<List<Mensaje>> mensajes(String conversacionId);

  Future<void> enviar({required String conversacionId, required String texto});

  Future<List<ResumenChat>> misChats();
}
