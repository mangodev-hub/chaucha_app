// Implementa supabase_usuario_service para la aplicación.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_guard.dart';
import '../models/usuario.dart';
import 'usuario_service.dart';

class SupabaseUsuarioService implements UsuarioService {
  SupabaseUsuarioService(this._client);

  static const String _tabla = 'usuarios';

  final SupabaseClient _client;

  @override
  Future<Usuario?> obtenerPorId(String id) {
    return supabaseGuard(() async {
      final fila = await _client
          .from(_tabla)
          .select(Usuario.columnas)
          .eq('id', id)
          .maybeSingle();
      return fila == null ? null : Usuario.fromJson(fila);
    });
  }
}
