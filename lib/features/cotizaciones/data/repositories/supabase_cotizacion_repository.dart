import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/cotizacion.dart';
import '../../domain/entities/nueva_cotizacion.dart';
import '../../domain/entities/rango_ocupado.dart';
import '../../domain/entities/tarifa.dart';
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
  Future<List<Cotizacion>> deSolicitudes(List<String> solicitudIds) {
    if (solicitudIds.isEmpty) return Future.value(const <Cotizacion>[]);
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(CotizacionModel.columnas)
          .inFilter('solicitud_id', solicitudIds);
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
              solucion: nueva.solucion,
            ),
          );
    });
  }

  @override
  Future<void> enviarTarifa(String cotizacionId, NuevaTarifa tarifa) {
    return supabaseGuard(() async {
      await _client.rpc(
        'enviar_tarifa',
        params: {
          'p_cotizacion_id': cotizacionId,
          'p_mano_obra': tarifa.precioAcordado,
          'p_fecha_servicio': tarifa.fechaServicio?.toUtc().toIso8601String(),
        },
      );
    });
  }

  @override
  Future<void> rechazarTarifa(String cotizacionId) {
    return supabaseGuard(() async {
      await _client.rpc(
        'rechazar_tarifa',
        params: {'p_cotizacion_id': cotizacionId},
      );
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

  @override
  Future<void> aceptar(Cotizacion cotizacion) {
    return supabaseGuard(() async {
      await _client.rpc(
        'aceptar_cotizacion',
        params: {'p_cotizacion_id': cotizacion.id},
      );
    });
  }

  @override
  Future<void> proponerReagendado(String cotizacionId, DateTime nuevaFecha) {
    return supabaseGuard(() async {
      await _client.rpc(
        'proponer_reagenda',
        params: {
          'p_cotizacion_id': cotizacionId,
          'p_nueva_fecha': nuevaFecha.toUtc().toIso8601String(),
        },
      );
    });
  }

  @override
  Future<void> responderReagendado(
    String cotizacionId, {
    required bool acepta,
  }) {
    return supabaseGuard(() async {
      await _client.rpc(
        'responder_reagenda',
        params: {'p_cotizacion_id': cotizacionId, 'p_acepta': acepta},
      );
    });
  }

  @override
  Future<void> cancelarVisita(String cotizacionId) {
    return supabaseGuard(() async {
      await _client.rpc(
        'cancelar_visita',
        params: {'p_cotizacion_id': cotizacionId},
      );
    });
  }

  @override
  Future<List<RangoOcupado>> horariosOcupados(
    String cotizacionId, {
    required DateTime desde,
    required DateTime hasta,
  }) {
    return supabaseGuard(() async {
      final respuesta = await _client.rpc(
        'horarios_ocupados',
        params: {
          'p_cotizacion_id': cotizacionId,
          'p_desde': desde.toUtc().toIso8601String(),
          'p_hasta': hasta.toUtc().toIso8601String(),
        },
      );
      final filas = (respuesta as List<dynamic>).cast<Map<String, dynamic>>();
      return [
        for (final fila in filas)
          RangoOcupado(
            inicio: aFecha(fila['inicio']),
            fin: aFecha(fila['fin']),
          ),
      ];
    });
  }
}
