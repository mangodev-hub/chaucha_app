import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../data/repositories/supabase_mapa_tecnico_repository.dart';
import '../../domain/entities/solicitud_en_mapa.dart';
import 'feed_provider.dart';

final solicitudesEnMapaProvider =
    FutureProvider.autoDispose<List<SolicitudEnMapa>>((ref) {
      ref.watch(usuarioActualProvider.select((u) => u?.id));
      // Cambiar el radio, la zona o los oficios recarga el mapa.
      ref.watch(
        perfilTecnicoProvider.select(
          (p) => (
            p.value?.rangoCoberturaM,
            p.value?.ubicacionActual,
            p.value?.oficioIds.length,
          ),
        ),
      );
      return ref.watch(mapaTecnicoRepositoryProvider).solicitudesEnMapa();
    });

final actualizarRadioProvider =
    AsyncNotifierProvider.autoDispose<ActualizarRadioNotifier, void>(
      ActualizarRadioNotifier.new,
    );

class ActualizarRadioNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> guardar(int metros) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(mapaTecnicoRepositoryProvider).actualizarMiRadio(metros),
    );
    if (!ref.mounted) return !resultado.hasError;
    state = resultado;
    if (!resultado.hasError) {
      ref
        ..invalidate(perfilTecnicoProvider)
        ..invalidate(solicitudesEnMapaProvider)
        ..invalidate(feedProvider);
    }
    return !resultado.hasError;
  }
}
