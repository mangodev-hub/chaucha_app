// Actualiza el perfil y sincroniza `tecnico_oficios`: borra los que ya se realizaron
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/geo/geo_mapper.dart';
import '../../../core/supabase/supabase_extensions.dart';
import '../../../core/supabase/supabase_guard.dart';
import '../../../core/utils/json_utils.dart';
import '../models/perfil_tecnico.dart';
import 'perfil_service.dart';

class SupabasePerfilService implements PerfilService {
  SupabasePerfilService(this._client);

  final SupabaseClient _client;

  @override
  Future<PerfilTecnico> miPerfilTecnico() {
    return supabaseGuard(() async {
      final fila = await _client
          .from('perfiles_tecnicos')
          .select(PerfilTecnico.columnas)
          .eq('usuario_id', _client.uidActual)
          .maybeSingle();
      if (fila == null) {
        throw const AppFailure(
          'Tu perfil de técnico aún no existe. Contacta al soporte.',
        );
      }
      return PerfilTecnico.fromJson(fila);
    });
  }



  @override
  Future<void> guardar(CambiosPerfil cambios) {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      await _client.from('perfiles_tecnicos').update({
        'tarifa_base': cambios.tarifaBase,
        'rango_cobertura_m': cambios.rangoCoberturaM,
        'ubicacion_actual': GeoMapper.toPostGisPoint(cambios.ubicacion),
      }).eq('usuario_id', uid);

      final actuales = await _client
          .from('tecnico_oficios')
          .select('oficio_id')
          .eq('tecnico_id', uid);
      final ids = actuales.map((f) => aInt(f['oficio_id'])).toSet();

      final quitar = ids.difference(cambios.oficioIds);
      final agregar = cambios.oficioIds.difference(ids);

      if (quitar.isNotEmpty) {
        await _client
            .from('tecnico_oficios')
            .delete()
            .eq('tecnico_id', uid)
            .inFilter('oficio_id', quitar.toList());
      }
      if (agregar.isNotEmpty) {
        await _client.from('tecnico_oficios').insert([
          for (final id in agregar) {'tecnico_id': uid, 'oficio_id': id},
        ]);
      }
    });
  }

  @override
  Future<void> crearResena(NuevaResena resena) {
    return supabaseGuard(() async {
      await _client.from('resenas').insert({
        'solicitud_id': resena.solicitudId,
        'autor_id': _client.uidActual,
        'destinatario_id': resena.destinatarioId,
        'calificacion': resena.calificacion,
        'comentario': resena.comentario?.trim(),
      });
    });
  }
}
