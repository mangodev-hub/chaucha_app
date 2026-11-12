import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';

/// Registra el token push cada vez que entra un usuario distinto.
/// El borrado al salir lo hace `SesionNotifier.cerrarSesion`.
final registroPushProvider = Provider<void>((ref) {
  ref.listen(usuarioActualProvider.select((u) => u?.id), (anterior, id) {
    if (id == null || id == anterior) return;
    unawaited(
      ref.read(pushServiceProvider).registrar(ref.read(supabaseClientProvider)),
    );
  }, fireImmediately: true);
});
