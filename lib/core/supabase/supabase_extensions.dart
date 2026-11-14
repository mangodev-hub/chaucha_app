import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/app_failure.dart';

extension UsuarioActual on SupabaseClient {
  String get uidActual {
    final id = auth.currentUser?.id;
    if (id == null) {
      throw const AppFailure('Tu sesión expiró. Inicia sesión de nuevo.');
    }
    return id;
  }
}
