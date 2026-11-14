import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FileOptions;

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/async_guard.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../data/models/certificacion_model.dart';
import '../../domain/entities/certificacion.dart';

final misCertificacionesProvider =
    FutureProvider.autoDispose<List<Certificacion>>((ref) {
      final uid = ref.watch(usuarioActualProvider.select((u) => u?.id));
      if (uid == null) return const <Certificacion>[];
      return supabaseGuard(() async {
        final filas = await ref
            .watch(supabaseClientProvider)
            .from(CertificacionModel.tabla)
            .select(CertificacionModel.columnas)
            .eq('tecnico_id', uid)
            .order('creado_en', ascending: false);
        return [for (final f in filas) CertificacionModel.desdeFila(f)];
      });
    });

/// Solo las aprobadas: es lo que ve cualquier usuario en el perfil.
final certificacionesAprobadasProvider = FutureProvider.autoDispose
    .family<List<Certificacion>, String>(
      (ref, tecnicoId) => supabaseGuard(() async {
        final filas = await ref
            .watch(supabaseClientProvider)
            .from(CertificacionModel.tabla)
            .select(CertificacionModel.columnas)
            .eq('tecnico_id', tecnicoId)
            .eq('estado', EstadoCertificacion.aprobada.valorDb)
            .order('creado_en', ascending: false);
        return [for (final f in filas) CertificacionModel.desdeFila(f)];
      }),
    );

final accionesCertificacionProvider =
    AsyncNotifierProvider.autoDispose<AccionesCertificacionNotifier, void>(
      AccionesCertificacionNotifier.new,
    );

class AccionesCertificacionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Sube el archivo (JPG, PNG o PDF) y crea el registro como pendiente.
  /// Devuelve true si salió bien.
  Future<bool> agregar({
    required String nombre,
    required String entidad,
    required Uint8List bytes,
    required String extension,
    int? anio,
  }) {
    return _ejecutar(() async {
      if (nombre.trim().length < 3) {
        throw const AppFailure('Escribe el nombre del certificado.');
      }
      const tipos = {
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
        'pdf': 'application/pdf',
      };
      final ext = extension.toLowerCase();
      final tipo = tipos[ext];
      if (tipo == null) {
        throw const AppFailure('Solo se admite JPG, PNG o PDF.');
      }
      final cliente = ref.read(supabaseClientProvider);
      final uid = cliente.uidActual;
      final ruta =
          '$uid/certificado_${DateTime.now().millisecondsSinceEpoch}.$ext';
      await supabaseGuard(
        () => cliente.storage
            .from(CertificacionModel.bucket)
            .uploadBinary(
              ruta,
              bytes,
              fileOptions: FileOptions(contentType: tipo),
            ),
      );
      await supabaseGuard(() async {
        await cliente.from(CertificacionModel.tabla).insert({
          'tecnico_id': uid,
          'nombre': nombre.trim(),
          'entidad': entidad.trim(),
          'anio': anio,
          'ruta_archivo': ruta,
        });
      });
    });
  }

  Future<bool> eliminar(String id) {
    return _ejecutar(
      () => supabaseGuard(() async {
        await ref
            .read(supabaseClientProvider)
            .from(CertificacionModel.tabla)
            .delete()
            .eq('id', id);
      }),
    );
  }

  Future<bool> _ejecutar(Future<void> Function() accion) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final resultado = await asyncGuard(accion);
    if (!ref.mounted) return !resultado.hasError;
    state = resultado;
    if (!resultado.hasError) {
      ref
        ..invalidate(misCertificacionesProvider)
        ..invalidate(certificacionesAprobadasProvider);
    }
    return !resultado.hasError;
  }
}
