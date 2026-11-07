// Implementación de [CotizacionRepository] con Supabase.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/cotizacion.dart';
import '../../domain/entities/nueva_cotizacion.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../models/cotizacion_model.dart';

final cotizacionRepositoryProvider = Provider<CotizacionRepository>(
  (ref) => SupabaseCotizacionRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseCotizacionRepository implements CotizacionRepository {
  SupabaseCotizacionRepository(this._client);

  static const String _tabla = 'cotizaciones';

  final SupabaseClient _client;

  @override
  Future<List<Cotizacion>> deSolicitud(String solicitudId) {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(CotizacionModel.columnas)
          .eq('solicitud_id', solicitudId)
          .order('creado_en');
      return filas
          .map((fila) => CotizacionModel.fromJson(fila).aEntidad())
          .toList();
    });
  }

  @override
  Future<void> enviar(NuevaCotizacion nueva) {
    return supabaseGuard(() async {
      await _client.from(_tabla).insert({
        'solicitud_id': nueva.solicitudId,
        'tecnico_id': _client.uidActual,
        'mano_obra': nueva.manoObra,
        'materiales': nueva.materiales,
        'detalle': nueva.detalle?.trim(),
      });
    });
  }

  @override
  Future<Set<String>> solicitudesCotizadasPorMi() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select('solicitud_id')
          .eq('tecnico_id', _client.uidActual);
      return filas.map((f) => f['solicitud_id'] as String).toSet();
    });
  }

  /// Acepta la cotización, rechaza las demás pendientes y marca la solicitud
  /// como aceptada, todo en una transacción (función RPC en Supabase, ver
  /// `base_de_datos/aceptar_cotizacion.sql`).
  @override
  Future<void> aceptar(Cotizacion cotizacion) {
    return supabaseGuard(() async {
      await _client.rpc(
        'aceptar_cotizacion',
        params: {'p_cotizacion_id': cotizacion.id},
      );
    });
  }
}
