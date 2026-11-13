import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/rol.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../models/rol_db.dart';
import '../models/usuario_model.dart';

final usuarioRepositoryProvider = Provider<UsuarioRepository>(
  (ref) => SupabaseUsuarioRepository(ref.watch(supabaseClientProvider)),
);

class SupabaseUsuarioRepository implements UsuarioRepository {
  SupabaseUsuarioRepository(this._client);

  static const String _tabla = 'usuarios';

  final SupabaseClient _client;

  @override
  Future<Usuario?> obtenerPorId(String id) {
    return supabaseGuard(() async {
      final fila = await _client
          .from(_tabla)
          .select(UsuarioModel.columnas)
          .eq('id', id)
          .maybeSingle();
      return fila == null ? null : UsuarioModel.fromJson(fila).aEntidad();
    });
  }

  @override
  Future<void> completarPerfil({
    required String cedula,
    required String codigoDactilar,
    required Rol rol,
  }) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'completar_perfil',
        params: {
          'p_cedula': cedula.trim(),
          'p_codigo_dactilar': codigoDactilar.trim(),
          'p_rol': rol.valorDb,
        },
      );
    });
  }

  @override
  Future<String?> registrarSelfie({required String ruta}) {
    return supabaseGuard(() async {
      await _client
          .from(_tabla)
          .update({'foto_perfil_ruta': ruta})
          .eq('id', _client.auth.currentUser!.id);
      final r = await _client.functions.invoke('validar-foto-rostro');
      final datos = r.data as Map<String, dynamic>;
      if (datos['valida'] == true) {
        unawaited(
          _client.functions
              .invoke('comparar-rostro-cedula')
              .then((_) {}, onError: (_) {}),
        );
        return null;
      }
      return (datos['motivo'] as String?) ?? 'No se ve un rostro claro.';
    });
  }

  @override
  Future<void> actualizarUbicacion(LatLng punto) {
    return supabaseGuard(() async {
      await _client
          .from('usuarios')
          .update({'ubicacion_registro': GeoMapper.toPostGisPoint(punto)})
          .eq('id', _client.uidActual);
    });
  }

  @override
  Future<String?> miCedula() {
    return supabaseGuard(() async {
      final fila = await _client
          .from('identidades')
          .select('cedula')
          .eq('usuario_id', _client.uidActual)
          .maybeSingle();
      return fila?['cedula'] as String?;
    });
  }
}
