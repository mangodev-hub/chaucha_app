import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core_providers.dart';
import '../../features/solicitudes/presentation/providers/agenda_provider.dart';
import '../../features/solicitudes/presentation/providers/feed_provider.dart';
import '../../features/solicitudes/presentation/providers/listas_provider.dart';

final sincronizacionProvider = Provider.autoDispose<void>((ref) {
  final cliente = ref.watch(supabaseClientProvider);
  Timer? espera;

  void refrescar() {
    espera?.cancel();
    espera = Timer(const Duration(milliseconds: 400), () {
      ref
        ..invalidate(misSolicitudesProvider)
        ..invalidate(misTrabajosProvider)
        ..invalidate(feedProvider)
        ..invalidate(agendaProvider);
    });
  }

  final canal = cliente.channel('sincronizacion-datos');
  for (final tabla in ['solicitudes_servicio', 'cotizaciones']) {
    canal.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: tabla,
      callback: (_) => refrescar(),
    );
  }
  canal.subscribe();

  ref.onDispose(() {
    espera?.cancel();
    cliente.removeChannel(canal);
  });
});