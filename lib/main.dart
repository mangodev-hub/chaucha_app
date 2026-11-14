import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/env.dart';
import 'core/providers/core_providers.dart';
import 'core/providers/reintento.dart';
import 'core/push/push_service.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'features/auth/presentation/providers/sesion_provider.dart';
import 'features/notificaciones/presentation/providers/push_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final licencia = await rootBundle.loadString(
      'assets/fonts/plus_jakarta_sans/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['Plus Jakarta Sans'], licencia);
  });

  final env = Env.fromDartDefines();
  final supabase = await SupabaseBootstrap.initialize(env);
  // Opcional: sin claves de Firebase en env.json la app funciona sin push.
  final push = await PushService.inicializar();

  // Contenedor de Riverpod. Vive lo mismo que la app.
  final container =
      ProviderContainer(
          overrides: [
            supabaseClientProvider.overrideWithValue(supabase),
            pushServiceProvider.overrideWithValue(push),
          ],
          // Sin esto, un error se esconde ~38 s detrás de "cargando".
          retry: Reintento.decidir,
        )
        // Empieza a escuchar la sesión desde el arranque.
        ..read(sesionProvider)
        // Registra el token push cuando hay usuario conectado.
        ..read(registroPushProvider);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
