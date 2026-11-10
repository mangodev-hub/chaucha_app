import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
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
}
