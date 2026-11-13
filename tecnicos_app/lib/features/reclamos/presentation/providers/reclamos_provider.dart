import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/async_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_reclamo_repository.dart';
import '../../domain/entities/reclamo.dart';

final misReclamosProvider = FutureProvider.autoDispose<List<Reclamo>>((ref) {
  ref.watch(usuarioActualProvider.select((u) => u?.id));
  return ref.watch(reclamoRepositoryProvider).misReclamos();
});

final reclamoProvider = FutureProvider.autoDispose.family<Reclamo, String>(
  (ref, id) => ref.watch(reclamoRepositoryProvider).obtener(id),
);

/// Mi reclamo abierto de un servicio (para la tarjeta de garantía).
final reclamoAbiertoProvider = FutureProvider.autoDispose
    .family<Reclamo?, String>(
      (ref, solicitudId) =>
          ref.watch(reclamoRepositoryProvider).abiertoDeSolicitud(solicitudId),
    );

final mensajesReclamoProvider = StreamProvider.autoDispose
    .family<List<MensajeReclamo>, String>(
      (ref, id) => ref.watch(reclamoRepositoryProvider).mensajes(id),
    );

final urlEvidenciaProvider = FutureProvider.autoDispose.family<String, String>(
  (ref, ruta) => ref.watch(reclamoRepositoryProvider).urlEvidencia(ruta),
);

/// Filtros del panel del asesor.
enum FiltroReclamos {
  abiertos('Abiertos', EstadoReclamo.abiertos),
  recibidos('Recibidos', {EstadoReclamo.recibido}),
  enRevision('En revisión', {EstadoReclamo.enRevision}),
  necesitaInfo('Necesitan información', {EstadoReclamo.necesitaInfo}),
  cerrados('Cerrados', {EstadoReclamo.resuelto, EstadoReclamo.rechazado});

  const FiltroReclamos(this.etiqueta, this.estados);

  final String etiqueta;
  final Set<EstadoReclamo> estados;
}

final reclamosAdminProvider = FutureProvider.autoDispose
    .family<List<Reclamo>, FiltroReclamos>(
      (ref, filtro) =>
          ref.watch(reclamoRepositoryProvider).todos(estados: filtro.estados),
    );

final reclamosRecibidosProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(reclamoRepositoryProvider).contarRecibidos(),
);

final crearReclamoProvider =
    AsyncNotifierProvider.autoDispose<CrearReclamoNotifier, void>(
      CrearReclamoNotifier.new,
    );

class CrearReclamoNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Sube las fotos y crea el reclamo. Devuelve el reclamo creado o null si
  /// falló (el error queda en el estado).
  Future<Reclamo?> enviar({
    required String solicitudId,
    required CategoriaReclamo categoria,
    required String descripcion,
    required List<Uint8List> fotos,
  }) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();
    Reclamo? creado;
    final resultado = await asyncGuard(() async {
      if (descripcion.trim().length < 20) {
        throw const AppFailure(
          'Cuéntanos qué pasó con al menos 20 caracteres.',
        );
      }
      final repo = ref.read(reclamoRepositoryProvider);
      final rutas = await Future.wait(fotos.map(repo.subirEvidencia));
      creado = await repo.crear(
        solicitudId: solicitudId,
        categoria: categoria,
        descripcion: descripcion,
        evidencias: rutas,
      );
    });
    if (!ref.mounted) return creado;
    state = resultado;
    if (!resultado.hasError) {
      ref
        ..invalidate(reclamoAbiertoProvider(solicitudId))
        ..invalidate(misReclamosProvider);
    }
    return creado;
  }
}

/// Acciones sobre un reclamo: responder (usuario) y gestionar (asesor).
final accionesReclamoProvider = AsyncNotifierProvider.autoDispose
    .family<AccionesReclamoNotifier, void, String>(AccionesReclamoNotifier.new);

class AccionesReclamoNotifier extends AsyncNotifier<void> {
  AccionesReclamoNotifier(this.reclamoId);

  final String reclamoId;

  @override
  FutureOr<void> build() {}

  Future<bool> responder(String texto) => _ejecutar(
    () => ref.read(reclamoRepositoryProvider).responder(reclamoId, texto),
  );

  Future<bool> gestionar(EstadoReclamo estado, {String? mensaje}) => _ejecutar(
    () => ref
        .read(reclamoRepositoryProvider)
        .gestionar(reclamoId, estado, mensaje: mensaje),
  );

  Future<bool> _ejecutar(Future<void> Function() accion) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(accion);
    if (!ref.mounted) return !resultado.hasError;
    state = resultado;
    if (!resultado.hasError) {
      ref
        ..invalidate(reclamoProvider(reclamoId))
        ..invalidate(misReclamosProvider)
        ..invalidate(reclamosRecibidosProvider)
        ..invalidate(reclamosAdminProvider);
    }
    return !resultado.hasError;
  }
}
