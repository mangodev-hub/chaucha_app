// Mensajes de una conversación en tiempo real. La suscripción se cancela
// sola al salir de la pantalla (autoDispose).
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/supabase_chat_repository.dart';
import '../../domain/entities/mensaje.dart';

final mensajesProvider =
    StreamProvider.autoDispose.family<List<Mensaje>, String>(
  (ref, conversacionId) =>
      ref.watch(chatRepositoryProvider).mensajes(conversacionId),
);
