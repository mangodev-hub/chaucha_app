// Implementación de [CotizacionRepository] con Supabase.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/cotizacion.dart';
import '../../domain/entities/nueva_cotizacion.dart';
import '../../domain/entities/tarifa.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../models/cotizacion_model.dart';
import '../models/estado_cotizacion_db.dart';

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
      return filas.map(CotizacionModel.desdeFila).toList();
    });
  }

  @override
  Future<List<Cotizacion>> misOfertas() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(CotizacionModel.columnas)
          .eq('tecnico_id', _client.uidActual)
          .order('creado_en', ascending: false);
      return filas.map(CotizacionModel.desdeFila).toList();
    });
  }

  @override
  Future<void> enviar(NuevaCotizacion nueva) {
    return supabaseGuard(() async {
      await _client
          .from(_tabla)
          .insert(
            CotizacionModel.filaNueva(
              solicitudId: nueva.solicitudId,
              tecnicoId: _client.uidActual,
              precioBase: nueva.precioBase,
              solucion: nueva.solucion,
            ),
          );
    });
  }

@override
Future<void> enviarTarifa(String cotizacionId, NuevaTarifa tarifa) {
  return supabaseGuard(() async {
    final f = tarifa.fechaServicio;
    await _client.rpc('enviar_tarifa', params: {
      'p_cotizacion_id': cotizacionId,
      'p_mano_obra': tarifa.precioAcordado,
      'p_materiales': tarifa.materiales,
      'p_fecha_servicio': f == null
          ? null
          : DateTime(f.year, f.month, f.day, 12).toUtc().toIso8601String(),
    });
  });
}

  @override
  Future<void> rechazarTarifa(String cotizacionId) {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .update(CotizacionModel.cambiosRechazo)
          .eq('id', cotizacionId)
          .eq('estado', EstadoCotizacion.pendiente.valorDb)
          .select('id');
      if (filas.isEmpty) {
        throw const AppFailure(
          'No se pudo rechazar el ticket. Puede que ya no esté pendiente.',
        );
      }
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
