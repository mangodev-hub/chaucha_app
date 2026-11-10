// Inicializa el SDK de Supabase una sola vez al arrancar la app.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';

abstract final class SupabaseBootstrap {
  static Future<SupabaseClient> initialize(Env env) async {
    await Supabase.initialize(
      url: env.supabaseUrl,
      publishableKey: env.supabaseAnonKey,
    );
    return Supabase.instance.client;
  }
}
