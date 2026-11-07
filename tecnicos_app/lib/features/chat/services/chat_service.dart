// Devuelve el id de la conversación entre la solicitud y el técnico;
import '../models/mensaje.dart';

abstract interface class ChatService {


  Future<String> obtenerOCrearConversacion({
    required String solicitudId,
    required String tecnicoId,
  });



  Stream<List<Mensaje>> mensajes(String conversacionId);

  Future<void> enviar({required String conversacionId, required String texto});
}
