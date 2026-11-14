import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../geo/sector_service.dart';
import '../providers/core_providers.dart';
import '../theme/tokens.dart';

final sectorServiceProvider = Provider<SectorService>(
  (ref) => SectorService(supabase: ref.watch(supabaseClientProvider)),
);

/// Sector de un punto (clave = coordenadas redondeadas, ver
/// [SectorService.clave]).
final sectorProvider = FutureProvider.autoDispose
    .family<String?, (double, double)>((ref, clave) async {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!ref.mounted) return null;
      try {
        return await ref.read(sectorServiceProvider).sectorDe(clave);
      } catch (_) {
        return null;
      }
    });

class EtiquetaSector extends ConsumerWidget {
  const EtiquetaSector({super.key, required this.punto});

  final LatLng punto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sector = ref.watch(sectorProvider(SectorService.clave(punto)));
    final texto = sector.when(
      data: (s) => s == null ? null : 'Sector: $s',
      loading: () => 'Buscando sector…',
      error: (_, _) => null,
    );
    if (texto == null) return const SizedBox.shrink();

    final textos = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.m,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colores.tarjeta,
          borderRadius: BorderRadius.circular(Radios.pildora),
          border: Border.all(color: Colores.linea),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place_outlined, size: 14, color: Colores.primario),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                texto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.labelSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sector de [punto] en la barra superior blanca: pin y nombre en verde.
/// Sin punto o sin sector no ocupa espacio.
class SectorEnBarra extends ConsumerWidget {
  const SectorEnBarra({super.key, required this.punto});

  final LatLng? punto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final punto = this.punto;
    final sector = punto == null
        ? null
        : ref.watch(sectorProvider(SectorService.clave(punto))).value;
    if (sector == null || sector.isEmpty) return const SizedBox.shrink();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 18,
            color: Colores.primario,
          ),
          const SizedBox(width: Espacios.xs),
          Flexible(
            child: Text(
              sector,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 13,
                color: Colores.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
