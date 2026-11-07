// Punto de entrada: solo arranca cosas, no tiene lógica de negocio.
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'core/config/env.dart';
import 'core/supabase/supabase_bootstrap.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final env = Env.fromDartDefines();
  final supabase = await SupabaseBootstrap.initialize(env);
  final dependencies = AppDependencies.supabase(supabase)
    ..sessionStore.iniciar();

  runApp(App(dependencies: dependencies));
}
