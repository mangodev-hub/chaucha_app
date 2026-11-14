import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/supabase_oficio_repository.dart';
import '../../domain/entities/oficio.dart';

final oficiosProvider = FutureProvider<List<Oficio>>(
  (ref) => ref.watch(oficioRepositoryProvider).listar(),
);
