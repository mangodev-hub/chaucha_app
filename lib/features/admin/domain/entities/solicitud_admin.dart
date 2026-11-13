// Solicitud con el nombre de quien la publicó (el admin ve las de todos).
import '../../../solicitudes/domain/entities/solicitud.dart';

class SolicitudAdmin {
  const SolicitudAdmin({required this.solicitud, required this.cliente});

  final Solicitud solicitud;
  final String cliente;

  /// Coincide con la búsqueda por oficio, descripción o cliente.
  bool coincide(String texto) {
    final buscado = texto.trim().toLowerCase();
    if (buscado.isEmpty) return true;
    return solicitud.oficioNombre.toLowerCase().contains(buscado) ||
        solicitud.descripcion.toLowerCase().contains(buscado) ||
        cliente.toLowerCase().contains(buscado);
  }
}
