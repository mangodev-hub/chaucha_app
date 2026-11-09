import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_inicio_repository.dart';
import '../../domain/entities/tecnico_cercano.dart';

const int radioInicioM = 5000;


final ubicacionInicioProvider = FutureProvider.autoDispose<LatLng>((ref) async {
  final actual = await ref.watch(ubicacionServiceProvider).obtenerActual();
  return actual ?? GeoMapper.quito;
});

final tecnicosCercanosProvider =
    FutureProvider.autoDispose<List<TecnicoCercano>>((ref) async {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  final punto = await ref.watch(ubicacionInicioProvider.future);
  return ref
      .watch(inicioRepositoryProvider)
      .tecnicosCercanos(punto: punto, radioM: radioInicioM);
});