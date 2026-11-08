import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/auth_redirect.dart';
import 'core/config/env.dart';
import 'core/providers/core_providers.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'features/auth/presentation/providers/sesion_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final env = Env.fromDartDefines();
  AuthRedirect.detectar();
  final supabase = await SupabaseBootstrap.initialize(env);

  final container = ProviderContainer(
    overrides: [supabaseClientProvider.overrideWithValue(supabase)],
  )..read(sesionProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}