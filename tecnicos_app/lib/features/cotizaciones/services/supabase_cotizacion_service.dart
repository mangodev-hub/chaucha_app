// Implementación de [CotizacionService] con Supabase.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_extensions.dart';
import '../../../core/supabase/supabase_guard.dart';
import '../models/cotizacion.dart';
import 'cotizacion_service.dart';

class SupabaseCotizacionService implements CotizacionService {
  SupabaseCotizacionService(this._client);

  static const String _tabla = 'cotizaciones';

  final SupabaseClient _client;

  @override
  Future<List<Cotizacion>> deSolicitud(String solicitudId) {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(Cotizacion.columnas)
          .eq('solicitud_id', solicitudId)
          .order('creado_en');
      return filas.map(Cotizacion.fromJson).toList();
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




  @override
  Future<void> aceptar(Cotizacion cotizacion) {
    return supabaseGuard(() async {
      await _client
          .from(_tabla)
          .update({'estado': EstadoCotizacion.aceptada.valorDb})
          .eq('id', cotizacion.id);
      await _client
          .from(_tabla)
          .update({'estado': EstadoCotizacion.rechazada.valorDb})
          .eq('solicitud_id', cotizacion.solicitudId)
          .neq('id', cotizacion.id)
          .eq('estado', EstadoCotizacion.pendiente.valorDb);
      await _client
          .from('solicitudes_servicio')
          .update({'estado': 'aceptada'})
          .eq('id', cotizacion.solicitudId);
    });
  }
}
