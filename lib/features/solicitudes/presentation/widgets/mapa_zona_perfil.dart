// Mapa de la zona del técnico conectado a sus datos: centro y radio de su
// perfil, y las solicitudes del feed como pines. Cambiar el radio en el mapa
// lo guarda en el perfil y recarga el feed. Lo usan el Inicio y la pestaña
// "Solicitudes cerca".
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/mensajes.dart';
import '../../../perfil_puntos/domain/entities/cambios_perfil.dart';
import '../../../perfil_puntos/domain/entities/perfil_tecnico.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../domain/entities/feed.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/feed_provider.dart';
import 'mapa_zona_tecnico.dart';

class MapaZonaPerfil extends ConsumerWidget {
  const MapaZonaPerfil({super.key, this.alto = 380, this.onTapSolicitud});

  final double alto;

  /// Al tocar el pin de una solicitud.
  final ValueChanged<Solicitud>? onTapSolicitud;

  Future<void> _cambiarRadio(
    BuildContext context,
    WidgetRef ref,
    PerfilTecnico perfil,
    int metros,
  ) async {
    final centro = perfil.ubicacionActual;
    if (centro == null) return;
    final ok = await ref
        .read(guardarPerfilProvider.notifier)
        .guardar(
          CambiosPerfil(
            tarifaBase: perfil.tarifaBase,
            rangoCoberturaM: metros,
            ubicacion: centro,
            oficioIds: perfil.oficioIds.toSet(),
          ),
        );
    if (!context.mounted) return;
    if (ok) {
      ref.invalidate(feedProvider);
    } else {
      context.mostrarMensaje(
        'No se pudo guardar el radio.',
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mantiene vivo el notifier mientras se guarda el radio.
    ref.watch(guardarPerfilProvider);
    final perfil = ref.watch(perfilTecnicoProvider).value;
    final centro = perfil?.ubicacionActual;
    if (perfil == null || centro == null) return const SizedBox.shrink();
    final items = ref.watch(feedProvider).value?.items ?? const <ItemFeed>[];
    return MapaZonaTecnico(
      centro: centro,
      radioM: perfil.rangoCoberturaM,
      solicitudes: [for (final i in items) i.solicitud],
      alto: alto,
      onCambiarRadio: (m) => _cambiarRadio(context, ref, perfil, m),
      onTapSolicitud: onTapSolicitud,
    );
  }
}
