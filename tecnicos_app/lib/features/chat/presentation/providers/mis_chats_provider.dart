import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_chat_repository.dart';
import '../../domain/entities/resumen_chat.dart';

final misChatsProvider = FutureProvider.autoDispose<List<ResumenChat>>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(chatRepositoryProvider).misChats();
});