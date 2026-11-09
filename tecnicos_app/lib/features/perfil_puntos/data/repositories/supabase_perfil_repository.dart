// Implementación de [PerfilRepository] con Supabase.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/cambios_perfil.dart';
import '../../domain/entities/nivel.dart';
import '../../domain/entities/nueva_resena.dart';
import '../../domain/entities/perfil_publico.dart';
import '../../domain/entities/perfil_tecnico.dart';
import '../../domain/repositories/perfil_repository.dart';
import '../models/perfil_publico_model.dart';
import '../models/perfil_tecnico_model.dart';

final perfilRepositoryProvider = Provider<PerfilRepository>(
  (ref) => SupabasePerfilRepository(ref.watch(supabaseClientProvider)),
);

class SupabasePerfilRepository implements PerfilRepository {
  SupabasePerfilRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<PerfilTecnico> miPerfilTecnico() {
    return supabaseGuard(() async {
      final fila = await _client
          .from('perfiles_tecnicos')
          .select(PerfilTecnicoModel.columnas)
          .eq('usuario_id', _client.uidActual)
          .maybeSingle();
      if (fila == null) {
        throw const AppFailure(
          'Tu perfil de técnico aún no existe. Contacta al soporte.',
        );
      }
      return PerfilTecnicoModel.fromJson(fila).aEntidad();
    });
  }

  /// Actualiza el perfil y sincroniza `tecnico_oficios`: borra los que ya no
  /// están e inserta los nuevos.
  // OJO: varias escrituras separadas, no una transacción. Si una falla a
  // medias, volver a guardar lo corrige. Candidato a RPC en Supabase.
  @override
  Future<void> guardar(CambiosPerfil cambios) {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      await _client
          .from('perfiles_tecnicos')
          .update({
            'tarifa_base': cambios.tarifaBase,
            'rango_cobertura_m': cambios.rangoCoberturaM,
            'ubicacion_actual': GeoMapper.toPostGisPoint(cambios.ubicacion),
          })
          .eq('usuario_id', uid);

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

  @override
  Future<List<Nivel>> niveles() {
    return supabaseGuard(() async {
      final filas = await _client
          .from('niveles_gamificacion')
          .select('nombre, puntos_minimos')
          .order('puntos_minimos');
      return [
        for (final f in filas)
          Nivel(
            nombre: f['nombre'] as String,
            puntosMinimos: aInt(f['puntos_minimos']),
          ),
      ];
    });
  }

  /// Perfil y reseñas en paralelo. `Future.wait` (y no el `.wait` de
  /// records) para conservar el [AppFailure] original si una falla.
  @override
  Future<PerfilPublico> perfilPublico(String tecnicoId) {
    return supabaseGuard(() async {
      final resultados = await Future.wait<Object?>([
        _client
            .from('perfiles_tecnicos')
            .select(PerfilPublicoModel.columnasPerfil)
            .eq('usuario_id', tecnicoId)
            .maybeSingle(),
        _client
            .from('resenas')
            .select(PerfilPublicoModel.columnasResenas)
            .eq('destinatario_id', tecnicoId)
            .order('creado_en', ascending: false)
            .limit(PerfilPublicoModel.limiteResenas),
      ]);
      final perfil = resultados[0] as Map<String, dynamic>?;
      if (perfil == null) {
        throw const AppFailure('No encontramos el perfil de este técnico.');
      }
      final resenas = resultados[1]! as List<Map<String, dynamic>>;
      return PerfilPublicoModel.desdeFilas(perfil, resenas);
    });
  }
}
