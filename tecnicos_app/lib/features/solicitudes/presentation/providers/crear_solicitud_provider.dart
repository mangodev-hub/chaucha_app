// Envío del formulario "Nueva solicitud". El estado guarda el id creado.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/async_guard.dart';
import '../../data/repositories/supabase_solicitud_repository.dart';
import '../../domain/entities/nueva_solicitud.dart';
import 'listas_provider.dart';

final crearSolicitudProvider =
    AsyncNotifierProvider.autoDispose<CrearSolicitudNotifier, String?>(
      CrearSolicitudNotifier.new,
    );

class CrearSolicitudNotifier extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  /// Devuelve el id de la solicitud creada, o null si falló o se ignoró.
  Future<String?> crear({
    required int? oficioId,
    required String descripcion,
    required String direccion,
    required LatLng ubicacion,
    required List<Uint8List> fotos,
  }) async {
    if (state.isLoading) return null;

    state = const AsyncLoading();
    final resultado = await asyncGuard<String?>(() {
      if (oficioId == null) {
        throw const AppFailure('Selecciona el tipo de servicio.');
      }
      final referencia = direccion.trim();
      return ref
          .read(solicitudRepositoryProvider)
          .crear(
            NuevaSolicitud(
              oficioId: oficioId,
              descripcion: descripcion,
              ubicacion: ubicacion,
              direccionReferencia: referencia.isEmpty ? null : referencia,
              fotos: fotos,
            ),
          );
    });
    if (!ref.mounted) return resultado.value;
    state = resultado;
    // La lista del cliente ya tiene una solicitud más.
    if (resultado.value != null) ref.invalidate(misSolicitudesProvider);
    return resultado.value;
  }
}
