// Envío de mensajes de una conversación. El mensaje nuevo aparece solo en
// `mensajesProvider` (tiempo real), aquí únicamente se envía.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_chat_repository.dart';

final enviarMensajeProvider = AsyncNotifierProvider.autoDispose
    .family<EnviarMensajeNotifier, void, String>(EnviarMensajeNotifier.new);

class EnviarMensajeNotifier extends AsyncNotifier<void> {
  EnviarMensajeNotifier(this.conversacionId);

  final String conversacionId;

  @override
  FutureOr<void> build() {}

  /// Devuelve true si el mensaje se envió. Ignora textos vacíos y los envíos
  /// que llegan mientras otro sigue en curso (devuelve false).
  Future<bool> enviar(String texto) async {
    if (texto.trim().isEmpty || state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref
          .read(chatRepositoryProvider)
          .enviar(conversacionId: conversacionId, texto: texto),
    );
    if (ref.mounted) state = resultado;
    return !resultado.hasError;
  }
}
