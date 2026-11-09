// Perfil público de un técnico, por id (lo abre el cliente desde una oferta).
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/supabase_perfil_repository.dart';
import '../../domain/entities/perfil_publico.dart';

final perfilPublicoProvider = FutureProvider.autoDispose
    .family<PerfilPublico, String>(
      (ref, tecnicoId) =>
          ref.watch(perfilRepositoryProvider).perfilPublico(tecnicoId),
    );
