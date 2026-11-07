// Chat en tiempo real.
import '../../../core/state/base_store.dart';
import '../../../core/state/view_state.dart';
import '../models/mensaje.dart';
import '../services/chat_service.dart';





class ChatViewModel extends BaseStore<List<Mensaje>> {
  ChatViewModel({
    required this.conversacionId,
    required this.miId,
    required ChatService chatService,
  }) : _chat = chatService;

  final String conversacionId;
  final String miId;
  final ChatService _chat;

  void iniciar() {
    emit(const ViewLoading());
    addSubscription(
      _chat.mensajes(conversacionId).listen(
            (mensajes) => emit(ViewLoaded(mensajes)),
            onError: (Object _) => emit(
              const ViewError(
                'No se pudo conectar al chat. Revisa tu conexión.',
              ),
            ),
          ),
    );
  }

  bool esMio(Mensaje mensaje) => mensaje.autorId == miId;

  Future<String?> enviar(String texto) {
    if (texto.trim().isEmpty) return Future.value();
    return ejecutarAccion(
      () => _chat.enviar(conversacionId: conversacionId, texto: texto),
    );
  }
}
