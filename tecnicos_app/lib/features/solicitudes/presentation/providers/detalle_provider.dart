// Detalle de una solicitud y las acciones que se pueden hacer sobre ella.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/async_guard.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../chat/data/repositories/supabase_chat_repository.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/domain/entities/nueva_cotizacion.dart';
import '../../../perfil_puntos/data/repositories/supabase_perfil_repository.dart';
import '../../../perfil_puntos/domain/entities/nueva_resena.dart';
import '../../data/repositories/supabase_solicitud_repository.dart';
import '../../domain/entities/detalle_solicitud.dart';
import '../../domain/entities/solicitud.dart';
import '../../domain/usecases/aceptar_cotizacion.dart';
import '../../domain/usecases/obtener_detalle_solicitud.dart';

final obtenerDetalleSolicitudProvider = Provider<ObtenerDetalleSolicitud>(
  (ref) => ObtenerDetalleSolicitud(
    solicitudes: ref.watch(solicitudRepositoryProvider),
    cotizaciones: ref.watch(cotizacionRepositoryProvider),
  ),
);

final aceptarCotizacionProvider = Provider<AceptarCotizacion>(
  (ref) => AceptarCotizacion(
    cotizaciones: ref.watch(cotizacionRepositoryProvider),
    solicitudes: ref.watch(solicitudRepositoryProvider),
  ),
);

final detalleSolicitudProvider =
    FutureProvider.autoDispose.family<DetalleSolicitud, String>(
  (ref, solicitudId) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null) {
      throw const AppFailure('Tu sesión expiró. Inicia sesión de nuevo.');
    }
    return ref.watch(obtenerDetalleSolicitudProvider)(solicitudId, usuario);
  },
);

final accionesSolicitudProvider = AsyncNotifierProvider.autoDispose
    .family<AccionesSolicitudNotifier, void, String>(
  AccionesSolicitudNotifier.new,
);

/// Acciones del detalle. Comparten un solo estado de "procesando": mientras
/// una está en curso, las demás se ignoran (devuelven false / null).
class AccionesSolicitudNotifier extends AsyncNotifier<void> {
  AccionesSolicitudNotifier(this.solicitudId);

  final String solicitudId;

  @override
  FutureOr<void> build() {}

  Future<bool> aceptar(Cotizacion cotizacion) =>
      _ejecutar(() => ref.read(aceptarCotizacionProvider)(cotizacion));

  Future<bool> confirmarTerminado() => _ejecutar(
        () => ref
            .read(solicitudRepositoryProvider)
            .cambiarEstado(solicitudId, EstadoSolicitud.completada),
      );

  Future<bool> cancelar() => _ejecutar(
        () => ref
            .read(solicitudRepositoryProvider)
            .cambiarEstado(solicitudId, EstadoSolicitud.cancelada),
      );

  Future<bool> enviarCotizacion({
    required double manoObra,
    required double materiales,
    String? detalle,
  }) {
    return _ejecutar(
      () => ref.read(cotizacionRepositoryProvider).enviar(
            NuevaCotizacion(
              solicitudId: solicitudId,
              manoObra: manoObra,
              materiales: materiales,
              detalle: detalle,
            ),
          ),
    );
  }

  Future<bool> marcarTerminada(List<Uint8List> evidencias) => _ejecutar(
        () => ref
            .read(solicitudRepositoryProvider)
            .marcarTerminada(solicitudId, evidencias),
      );

  Future<bool> calificar({
    required String destinatarioId,
    required int estrellas,
    String? comentario,
  }) {
    return _ejecutar(
      () => ref.read(perfilRepositoryProvider).crearResena(
            NuevaResena(
              solicitudId: solicitudId,
              destinatarioId: destinatarioId,
              calificacion: estrellas,
              comentario: comentario,
            ),
          ),
      recargar: false,
    );
  }

  /// Devuelve el id de la conversación, o null si falló o se ignoró.
  Future<String?> abrirChat(String tecnicoId) async {
    String? conversacionId;
    await _ejecutar(
      () async {
        conversacionId =
            await ref.read(chatRepositoryProvider).obtenerOCrearConversacion(
                  solicitudId: solicitudId,
                  tecnicoId: tecnicoId,
                );
      },
      recargar: false,
    );
    return conversacionId;
  }

  Future<bool> _ejecutar(
    Future<void> Function() accion, {
    bool recargar = true,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(accion);
    if (!ref.mounted) return !resultado.hasError;

    state = resultado;
    if (!resultado.hasError && recargar) {
      ref.invalidate(detalleSolicitudProvider(solicitudId));
    }
    return !resultado.hasError;
  }
}
