// Catálogo de oficios. Se carga una vez y queda en memoria mientras viva la
// app (reemplaza el caché manual del antiguo SupabaseOficioService).
// Para recargar tras un error: `ref.invalidate(oficiosProvider)`.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/supabase_oficio_repository.dart';
import '../../domain/entities/oficio.dart';

final oficiosProvider = FutureProvider<List<Oficio>>(
  (ref) => ref.watch(oficioRepositoryProvider).listar(),
);
