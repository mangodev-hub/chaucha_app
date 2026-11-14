import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/repositories/supabase_documento_repository.dart';
import '../../domain/entities/datos_identidad.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';

/// Se recarga si cambia el usuario conectado (no mezcla datos de cuentas).
final verificacionProvider = FutureProvider.autoDispose<Verificacion>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(documentoRepositoryProvider).miVerificacion();
});

final subirDocumentoProvider =
    AsyncNotifierProvider.autoDispose<SubirDocumentoNotifier, void>(
      SubirDocumentoNotifier.new,
    );

class SubirDocumentoNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Devuelve true si se subió. Al subir, recarga [verificacionProvider] y
  /// lanza la validación automática (sin esperarla).
  Future<bool> subir(TipoDocumento tipo, Uint8List bytes) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(documentoRepositoryProvider).subir(tipo, bytes),
    );
    if (!ref.mounted) return !resultado.hasError;

    state = resultado;
    if (!resultado.hasError) {
      ref.invalidate(verificacionProvider);
      unawaited(ref.read(validacionIdentidadProvider.notifier).iniciar());
    }
    return !resultado.hasError;
  }
}

/// true mientras corre la validación automática de identidad, que sigue
/// aunque se cierre el panel (el resultado llega también como notificación).
final validacionIdentidadProvider =
    NotifierProvider<ValidacionIdentidadNotifier, bool>(
      ValidacionIdentidadNotifier.new,
    );

class ValidacionIdentidadNotifier extends Notifier<bool> {
  /// Hubo otro envío mientras validaba: se valida de nuevo al terminar.
  bool _otraVez = false;

  @override
  bool build() {
    ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
    return false;
  }

  Future<void> iniciar() async {
    if (state) {
      _otraVez = true;
      return;
    }
    state = true;
    do {
      _otraVez = false;
      try {
        await ref.read(documentoRepositoryProvider).validarIdentidad();
      } catch (_) {
        // Los documentos quedan pendientes para la revisión del admin.
      }
    } while (_otraVez && ref.mounted);
    if (!ref.mounted) return;
    state = false;
    ref.invalidate(verificacionProvider);
    try {
      // Puede haber quedado verificado.
      await ref.read(sesionProvider.notifier).recargarUsuario();
    } catch (_) {}
  }
}

/// Datos del registro, para el formulario de corrección.
final misDatosIdentidadProvider = FutureProvider.autoDispose<DatosIdentidad>(
  (ref) => ref.watch(documentoRepositoryProvider).misDatos(),
);

final corregirDatosProvider =
    AsyncNotifierProvider.autoDispose<CorregirDatosNotifier, void>(
      CorregirDatosNotifier.new,
    );

class CorregirDatosNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Guarda los datos corregidos y lanza otra validación. true si se
  /// guardaron.
  Future<bool> corregir(DatosIdentidad datos) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(
      () => ref.read(documentoRepositoryProvider).corregirDatos(datos),
    );
    if (!ref.mounted) return !resultado.hasError;

    state = resultado;
    if (!resultado.hasError) {
      ref
        ..invalidate(verificacionProvider)
        ..invalidate(misDatosIdentidadProvider);
      unawaited(ref.read(validacionIdentidadProvider.notifier).iniciar());
      try {
        await ref.read(sesionProvider.notifier).recargarUsuario();
      } catch (_) {}
    }
    return !resultado.hasError;
  }
}
