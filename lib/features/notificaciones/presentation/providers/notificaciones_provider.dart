import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/repositories/supabase_notificaciones_repository.dart';
import '../../domain/entities/notificacion.dart';

final notificacionesRepoProvider = Provider<SupabaseNotificacionesRepository>(
  (ref) => SupabaseNotificacionesRepository(ref.watch(supabaseClientProvider)),
);

final notificacionesNoLeidasProvider =
    StreamProvider.autoDispose<List<Notificacion>>((ref) {
      final uid = ref.watch(supabaseClientProvider).auth.currentUser?.id;
      if (uid == null) return const Stream.empty();
      return ref.watch(notificacionesRepoProvider).noLeidas(uid);
    });
