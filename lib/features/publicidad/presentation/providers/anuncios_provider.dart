import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/supabase_anuncio_repository.dart';
import '../../domain/entities/anuncio.dart';

final anunciosProvider = FutureProvider.autoDispose
    .family<List<Anuncio>, UbicacionAnuncio>(
      (ref, ubicacion) =>
          ref.watch(anuncioRepositoryProvider).vigentes(ubicacion),
    );
