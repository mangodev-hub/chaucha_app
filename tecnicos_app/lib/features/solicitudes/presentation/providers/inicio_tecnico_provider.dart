// Datos de la pantalla de inicio del técnico. Cada sección tiene su propio
// provider para que, si una falla, las demás se sigan viendo.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../chat/data/repositories/supabase_chat_repository.dart';
import '../../../chat/domain/entities/conversacion_pendiente.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../perfil_puntos/data/repositories/supabase_perfil_repository.dart';
import '../../../perfil_puntos/domain/entities/nivel.dart';
import '../../domain/entities/resumen_tecnico.dart';
import '../../domain/entities/solicitud.dart';
import 'listas_provider.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';

/// Ofertas del técnico conectado.
final misOfertasProvider = FutureProvider.autoDispose<List<Cotizacion>>((ref) {
  ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
  return ref.watch(cotizacionRepositoryProvider).misOfertas();
});

/// Chats donde el cliente escribió último.
final chatsPorResponderProvider =
    FutureProvider.autoDispose<List<ConversacionPendiente>>((ref) {
      ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
      return ref.watch(chatRepositoryProvider).porResponder();
    });

/// Niveles de gamificación (cambian poco: no se descartan al salir).
final nivelesProvider = FutureProvider<List<Nivel>>(
  (ref) => ref.watch(perfilRepositoryProvider).niveles(),
);

/// Ofertas, tickets, trabajos y lo ganado en el mes.
final resumenTecnicoProvider = FutureProvider.autoDispose<ResumenTecnico>((
  ref,
) async {
  // Future.wait (no `.wait` de records) para conservar el AppFailure.
  final resultados = await Future.wait<Object>([
    ref.watch(misOfertasProvider.future),
    ref.watch(misTrabajosProvider.future),
  ]);
  return ResumenTecnico.calcular(
    ofertas: resultados[0] as List<Cotizacion>,
    trabajos: resultados[1] as List<Solicitud>,
    hoy: DateTime.now(),
  );
});

/// Chats por responder que aún no se abrieron. Al abrirlos salen de
/// "Pendientes" y quedan solo en el botón flotante de mensajes.
final chatsPendientesProvider =
    Provider.autoDispose<AsyncValue<List<ConversacionPendiente>>>((ref) {
      final chats = ref.watch(chatsPorResponderProvider);
      final sinLeer = ref.watch(notificacionesNoLeidasProvider);
      final lista = sinLeer.value;
      if (lista == null) {
        return sinLeer.hasError
            ? chats
            : const AsyncLoading<List<ConversacionPendiente>>();
      }
      final ids = {
        for (final n in lista)
          if ((n.tipo == 'mensaje' || n.tipo == 'chat') &&
              n.referenciaId != null)
            n.referenciaId!,
      };
      return chats.whenData(
        (l) => [
          for (final c in l)
            if (ids.contains(c.conversacionId)) c,
        ],
      );
    });
