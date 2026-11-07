// Feed del técnico. Depende del perfil: cuando el técnico guarda su perfil
// (oficios, ubicación, radio), el feed se recalcula solo.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../data/repositories/supabase_solicitud_repository.dart';
import '../../domain/entities/feed.dart';
import '../../domain/usecases/obtener_feed_tecnico.dart';

final obtenerFeedTecnicoProvider = Provider<ObtenerFeedTecnico>(
  (ref) => ObtenerFeedTecnico(
    solicitudes: ref.watch(solicitudRepositoryProvider),
    cotizaciones: ref.watch(cotizacionRepositoryProvider),
  ),
);

final feedProvider = FutureProvider.autoDispose<DatosFeed>((ref) async {
  final perfil = await ref.watch(perfilTecnicoProvider.future);
  return ref.watch(obtenerFeedTecnicoProvider)(perfil);
});
