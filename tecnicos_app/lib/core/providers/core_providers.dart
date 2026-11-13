// Providers de infraestructura compartida (Supabase, storage, GPS).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../geo/ubicacion_service.dart';
import '../push/push_service.dart';
import '../storage/storage_service.dart';

/// Cliente de Supabase ya inicializado.
///
/// Se sobrescribe en `main.dart` después de `SupabaseBootstrap.initialize`.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => throw UnimplementedError(
    'supabaseClientProvider debe sobrescribirse en main.dart.',
  ),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => SupabaseStorageService(ref.watch(supabaseClientProvider)),
);

final ubicacionServiceProvider = Provider<UbicacionService>(
  (ref) => GeolocatorUbicacionService(),
);

/// Notificaciones push. Se sobrescribe en `main.dart` tras inicializar Firebase.
final pushServiceProvider = Provider<PushService>(
  (ref) => PushService.desactivado,
);
