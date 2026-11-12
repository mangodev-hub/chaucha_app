// Contexto del chat (solicitud y oferta del técnico, con su ticket) y las
// acciones del ticket de trabajo: el técnico lo envía; el cliente lo
// confirma o lo rechaza. El envío y la confirmación dejan su mensaje en el
// chat desde la base de datos; el rechazo lo avisa la app.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/async_guard.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/domain/entities/reglas_tarifa.dart';
import '../../../cotizaciones/domain/entities/tarifa.dart';
import '../../../solicitudes/data/repositories/supabase_solicitud_repository.dart';
import '../../data/repositories/supabase_chat_repository.dart';
import '../../domain/entities/contexto_chat.dart';
import '../../domain/usecases/obtener_contexto_chat.dart';

final obtenerContextoChatProvider = Provider<ObtenerContextoChat>(
  (ref) => ObtenerContextoChat(
    chat: ref.watch(chatRepositoryProvider),
    solicitudes: ref.watch(solicitudRepositoryProvider),
    cotizaciones: ref.watch(cotizacionRepositoryProvider),
  ),
);

final contextoChatProvider = FutureProvider.autoDispose
    .family<ContextoChat, String>(
      (ref, conversacionId) =>
          ref.watch(obtenerContextoChatProvider)(conversacionId),
    );

final accionesTarifaProvider = AsyncNotifierProvider.autoDispose
    .family<AccionesTarifaNotifier, void, String>(AccionesTarifaNotifier.new);

/// Acciones del ticket de una conversación. Comparten un solo estado de
/// "procesando": mientras una está en curso, las demás se ignoran.
class AccionesTarifaNotifier extends AsyncNotifier<void> {
  AccionesTarifaNotifier(this.conversacionId);

  final String conversacionId;

  @override
  FutureOr<void> build() {}

  /// El técnico envía el ticket con el precio acordado por chat. La base
  /// avisa al cliente en el chat. El precio de la visita de su oferta no cambia.
  Future<bool> enviar(NuevaTarifa tarifa) {
    return _ejecutar(() async {
      if (tarifa.precioAcordado <= 0) {
        throw const AppFailure('El precio acordado debe ser mayor que 0.');
      }
      final contexto = await _contexto();
      final motivo = ReglasTarifa.motivoParaNoEnviar(
        soyCliente: false,
        oferta: contexto.oferta,
        estadoSolicitud: contexto.estadoSolicitud,
      );
      if (motivo != null) throw AppFailure(motivo);

      await ref
          .read(cotizacionRepositoryProvider)
          .enviarTarifa(contexto.oferta!.id, tarifa);
    });
  }

  /// El cliente confirma: se acepta la oferta con el ticket (la solicitud
  /// pasa a "En curso" y las demás ofertas no se eligen), en una sola
  /// transacción (RPC `aceptar_cotizacion`). La base avisa en el chat.
  Future<bool> confirmar() {
    return _ejecutar(() async {
      final contexto = await _contexto();
      final oferta = contexto.oferta;
      if (!ReglasTarifa.puedeResponder(
        soyCliente: true,
        oferta: oferta,
        estadoSolicitud: contexto.estadoSolicitud,
      )) {
        throw const AppFailure('Este ticket ya no se puede confirmar.');
      }
      await ref.read(cotizacionRepositoryProvider).aceptar(oferta!);
    });
  }

  /// El cliente rechaza el ticket; pueden seguir conversando y el técnico
  /// puede enviar otro.
  Future<bool> rechazar() {
    return _ejecutar(() async {
      final contexto = await _contexto();
      final oferta = contexto.oferta;
      if (!ReglasTarifa.puedeResponder(
        soyCliente: true,
        oferta: oferta,
        estadoSolicitud: contexto.estadoSolicitud,
      )) {
        throw const AppFailure('Este ticket ya no se puede rechazar.');
      }
      await ref.read(cotizacionRepositoryProvider).rechazarTarifa(oferta!.id);
    });
  }

  /// Lee el contexto actualizado (por si la otra persona cambió algo).
  Future<ContextoChat> _contexto() =>
      ref.refresh(contextoChatProvider(conversacionId).future);

  Future<bool> _ejecutar(Future<void> Function() accion) async {
    if (state.isLoading) return false;

    state = const AsyncLoading();
    final resultado = await asyncGuard(accion);
    if (!ref.mounted) return !resultado.hasError;

    state = resultado;
    // Recarga la oferta para mostrar el ticket actualizado.
    ref.invalidate(contextoChatProvider(conversacionId));
    return !resultado.hasError;
  }
}
