// Certificados de técnicos por revisar (pestaña "Verificaciones").
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/async_guard.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../perfil_puntos/data/models/certificacion_model.dart';
import '../../../perfil_puntos/domain/entities/certificacion.dart';

final certificacionesPendientesProvider =
    FutureProvider.autoDispose<List<Certificacion>>((ref) {
      ref.watch(usuarioActualProvider.select((u) => u?.id));
      final cliente = ref.watch(supabaseClientProvider);
      final storage = ref.watch(storageServiceProvider);
      return supabaseGuard(() async {
        final filas = await cliente
            .from(CertificacionModel.tabla)
            .select(CertificacionModel.columnasAdmin)
            .eq('estado', EstadoCertificacion.pendiente.valorDb)
            .order('creado_en');
        return Future.wait<Certificacion>([
          for (final f in filas)
            () async {
              final url = await storage.urlFirmada(
                bucket: CertificacionModel.bucket,
                ruta: f['ruta_archivo'] as String,
              );
              return CertificacionModel.desdeFila(f, url: url);
            }(),
        ]);
      });
    });

final revisarCertificacionProvider =
    AsyncNotifierProvider.autoDispose<RevisarCertificacionNotifier, void>(
      RevisarCertificacionNotifier.new,
    );

class RevisarCertificacionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> revisar(String id, {required bool aprobado}) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final cliente = ref.read(supabaseClientProvider);
    final resultado = await asyncGuard(
      () => supabaseGuard(() async {
        await cliente
            .from(CertificacionModel.tabla)
            .update({
              'estado':
                  (aprobado
                          ? EstadoCertificacion.aprobada
                          : EstadoCertificacion.rechazada)
                      .valorDb,
              'revisado_por': cliente.uidActual,
              'revisado_en': DateTime.now().toUtc().toIso8601String(),
            })
            .eq('id', id);
      }),
    );
    if (!ref.mounted) return !resultado.hasError;
    state = resultado;
    ref.invalidate(certificacionesPendientesProvider);
    return !resultado.hasError;
  }
}
