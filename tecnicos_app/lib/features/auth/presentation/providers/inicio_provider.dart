import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/presentation/providers/agenda_provider.dart';
import '../../../solicitudes/presentation/providers/listas_provider.dart';
import '../../data/repositories/supabase_inicio_repository.dart';
import '../../domain/entities/tecnico_cercano.dart';

class RadioInicio extends Notifier<int> {
  @override
  int build() => 5000;

  void cambiar(int metros) => state = metros;
}

final radioInicioProvider = NotifierProvider<RadioInicio, int>(RadioInicio.new);

/// Oficio elegido en "Cerca de ti" (null = todos).
class OficioInicio extends Notifier<int?> {
  @override
  int? build() => null;

  void elegir(int? oficioId) => state = oficioId;
}

final oficioInicioProvider = NotifierProvider<OficioInicio, int?>(
  OficioInicio.new,
);

final ubicacionInicioProvider = FutureProvider.autoDispose<LatLng>((ref) async {
  final actual = await ref.watch(ubicacionServiceProvider).obtenerActual();
  return actual ?? GeoMapper.quito;
});

final tecnicosCercanosProvider =
    FutureProvider.autoDispose<List<TecnicoCercano>>((ref) async {
      ref.watch(usuarioActualProvider.select((usuario) => usuario?.id));
      final punto = await ref.watch(ubicacionInicioProvider.future);
      final radioM = ref.watch(radioInicioProvider);
      final oficioId = ref.watch(oficioInicioProvider);
      return ref
          .watch(inicioRepositoryProvider)
          .tecnicosCercanos(punto: punto, radioM: radioM, oficioId: oficioId);
    });

/// La solicitud activa más reciente del cliente y cuántos técnicos la
/// cotizaron, para la tarjeta "Tu solicitud activa" del inicio. Null si no
/// tiene ninguna en curso.
final solicitudActivaProvider =
    FutureProvider.autoDispose<({Solicitud solicitud, int ofertas})?>((
      ref,
    ) async {
      final lista = await ref.watch(misSolicitudesProvider.future);
      final activas = [
        for (final s in lista)
          if (s.estado != EstadoSolicitud.completada &&
              s.estado != EstadoSolicitud.cancelada)
            s,
      ]..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
      if (activas.isEmpty) return null;
      final solicitud = activas.first;
      final ofertas = await ref
          .watch(cotizacionRepositoryProvider)
          .deSolicitud(solicitud.id);
      return (solicitud: solicitud, ofertas: ofertas.length);
    });

/// La próxima visita aceptada del cliente que todavía no empieza.
final proximaVisitaProvider = FutureProvider.autoDispose<ItemAgenda?>((
  ref,
) async {
  final agenda = await ref.watch(agendaProvider(true).future);
  final ahora = DateTime.now();
  DateTime? inicio(ItemAgenda i) => i.oferta.inicioVisita ?? i.fecha;
  final futuras = [
    for (final i in agenda.proximos)
      if (inicio(i)?.isAfter(ahora) ?? false) i,
  ]..sort((a, b) => inicio(a)!.compareTo(inicio(b)!));
  return futuras.isEmpty ? null : futuras.first;
});
