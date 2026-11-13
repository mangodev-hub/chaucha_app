import 'dart:typed_data';

import '../entities/reclamo.dart';

abstract interface class ReclamoRepository {
  /// Sube una foto al bucket `reclamos` y devuelve su ruta.
  Future<String> subirEvidencia(Uint8List bytes);

  Future<String> urlEvidencia(String ruta);

  Future<Reclamo> crear({
    required String solicitudId,
    required CategoriaReclamo categoria,
    required String descripcion,
    required List<String> evidencias,
  });

  Future<List<Reclamo>> misReclamos();

  Future<Reclamo> obtener(String id);

  /// Mi reclamo abierto de ese servicio, si hay uno.
  Future<Reclamo?> abiertoDeSolicitud(String solicitudId);

  Stream<List<MensajeReclamo>> mensajes(String reclamoId);

  Future<void> responder(String reclamoId, String texto);

  /// Panel del asesor: los reclamos en [estados], del más antiguo al más
  /// nuevo.
  Future<List<Reclamo>> todos({required Set<EstadoReclamo> estados});

  Future<int> contarRecibidos();

  Future<void> gestionar(
    String reclamoId,
    EstadoReclamo estado, {
    String? mensaje,
  });
}
