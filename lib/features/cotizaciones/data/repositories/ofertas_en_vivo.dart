// Cambios en vivo de las ofertas de una solicitud (Realtime de
// `cotizaciones` filtrado por `solicitud_id`). Emite una huella por oferta
// (id, estado y ticket) para saber cuándo hay que recargar el detalle.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';

final ofertasEnVivoProvider = StreamProvider.autoDispose
    .family<List<String>, String>((ref, solicitudId) {
      return ref
          .watch(supabaseClientProvider)
          .from('cotizaciones')
          .stream(primaryKey: ['id'])
          .eq('solicitud_id', solicitudId)
          .map(
            (filas) => [
              for (final f in filas)
                '${f['id']}|${f['estado']}|${f['tarifa_enviada']}|'
                    '${f['inicio_visita']}|${f['reagenda_inicio']}',
            ]..sort(),
          );
    });
