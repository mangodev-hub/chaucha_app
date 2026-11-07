// Listas de solicitudes: las del cliente y los trabajos del técnico.
// Se recargan si cambia el usuario conectado (no mezclan datos de cuentas).
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_solicitud_repository.dart';
import '../../domain/entities/solicitud.dart';

final misSolicitudesProvider =
    FutureProvider.autoDispose<List<Solicitud>>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(solicitudRepositoryProvider).misSolicitudes();
});

final misTrabajosProvider = FutureProvider.autoDispose<List<Solicitud>>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(solicitudRepositoryProvider).misTrabajos();
});
