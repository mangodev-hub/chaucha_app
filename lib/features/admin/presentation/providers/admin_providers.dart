import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../auth/domain/entities/registro_datos.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_admin_repository.dart';
import '../../domain/entities/resumen_admin.dart';
import '../../domain/entities/revision_tecnico.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../../domain/entities/usuario_admin.dart';

final resumenAdminProvider = FutureProvider.autoDispose<ResumenAdmin>((ref) {
  ref.watch(usuarioActualProvider.select((u) => u?.id));
  return ref.watch(adminRepositoryProvider).resumen();
});

final solicitudesAdminProvider =
    FutureProvider.autoDispose<List<SolicitudAdmin>>((ref) {
      ref.watch(usuarioActualProvider.select((u) => u?.id));
      return ref.watch(adminRepositoryProvider).solicitudes();
    });

final usuariosAdminProvider = FutureProvider.autoDispose<List<UsuarioAdmin>>((
  ref,
) {
  ref.watch(usuarioActualProvider.select((u) => u?.id));
  return ref.watch(adminRepositoryProvider).usuarios();
});

final revisionesProvider = FutureProvider.autoDispose<List<RevisionTecnico>>((
  ref,
) {
  ref.watch(usuarioActualProvider.select((u) => u?.id));
  return ref.watch(adminRepositoryProvider).revisionesPendientes();
});

final accionesUsuarioProvider = AsyncNotifierProvider.autoDispose
    .family<AccionesUsuarioNotifier, void, String>(AccionesUsuarioNotifier.new);

class AccionesUsuarioNotifier extends AsyncNotifier<void> {
  AccionesUsuarioNotifier(this.usuarioId);

  final String usuarioId;

  @override
  FutureOr<void> build() {}

  Future<bool> actualizar(CambiosUsuario cambios) => _ejecutar(
    () =>
        ref.read(adminRepositoryProvider).actualizarUsuario(usuarioId, cambios),
  );

  Future<bool> suspender({required bool suspendido}) => _ejecutar(
    () => ref
        .read(adminRepositoryProvider)
        .suspenderUsuario(usuarioId, suspendido: suspendido),
  );

  Future<bool> eliminar() => _ejecutar(
    () => ref.read(adminRepositoryProvider).eliminarUsuario(usuarioId),
  );

  Future<bool> _ejecutar(Future<void> Function() accion) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(accion);
    if (!ref.mounted) return false;
    state = resultado;
    if (resultado.hasError) return false;
    ref
      ..invalidate(usuariosAdminProvider)
      ..invalidate(resumenAdminProvider);
    return true;
  }
}

final crearUsuarioProvider =
    AsyncNotifierProvider.autoDispose<CrearUsuarioNotifier, void>(
      CrearUsuarioNotifier.new,
    );

class CrearUsuarioNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> crear(RegistroDatos datos) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(adminRepositoryProvider).crearUsuario(datos),
    );
    if (!ref.mounted) return false;
    state = resultado;
    if (resultado.hasError) return false;
    ref
      ..invalidate(usuariosAdminProvider)
      ..invalidate(resumenAdminProvider);
    return true;
  }
}

final revisionTecnicoProvider = AsyncNotifierProvider.autoDispose
    .family<RevisionTecnicoNotifier, void, String>(RevisionTecnicoNotifier.new);

class RevisionTecnicoNotifier extends AsyncNotifier<void> {
  RevisionTecnicoNotifier(this.tecnicoId);

  final String tecnicoId;

  @override
  FutureOr<void> build() {}

  /// Aprueba o rechaza los documentos con esos ids.
  Future<bool> revisar(
    List<String> documentoIds, {
    required bool aprobado,
  }) async {
    if (state.isLoading || documentoIds.isEmpty) return false;
    state = const AsyncLoading();
    final repo = ref.read(adminRepositoryProvider);
    final resultado = await asyncGuard(() async {
      for (final id in documentoIds) {
        await repo.revisarDocumento(id, aprobado: aprobado);
      }
    });
    if (!ref.mounted) return false;
    state = resultado;
    // Aunque falle a medias, algunos documentos pudieron cambiar.
    ref
      ..invalidate(revisionesProvider)
      ..invalidate(resumenAdminProvider)
      ..invalidate(usuariosAdminProvider);
    return !resultado.hasError;
  }
}
