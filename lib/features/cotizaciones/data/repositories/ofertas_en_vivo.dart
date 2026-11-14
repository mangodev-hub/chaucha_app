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
