import 'dart:typed_data';

import '../entities/foto_solicitud.dart';
import '../entities/nueva_solicitud.dart';
import '../entities/servicio_completado.dart';
import '../entities/solicitud.dart';

abstract interface class SolicitudRepository {
  Future<List<Solicitud>> misSolicitudes();

  /// Servicios completados del cliente, del más reciente al más antiguo,
  /// con el técnico, el precio de la visita y la reseña que dejó.
  Future<List<ServicioCompletado>> historialServicios(
    String clienteId, {
    int limite = 50,
  });

  Future<String> crear(NuevaSolicitud nueva);

  Future<List<Solicitud>> abiertasDeOficios(List<int> oficioIds);

  Future<List<Solicitud>> misTrabajos();

  Future<void> marcarTerminada(String solicitudId, List<Uint8List> evidencias);

  Future<Solicitud> obtener(String id);

  Future<List<FotoSolicitud>> fotos(String solicitudId);
  Future<List<Solicitud>> porIds(List<String> ids);
  Future<void> cambiarEstado(String solicitudId, EstadoSolicitud estado);
  Future<void> editar(
    String id, {
    required String descripcion,
    required int oficioId,
    String? direccion,
  });

  Future<void> eliminar(String id);

  /// Agrega fotos del problema a una solicitud ya publicada.
  Future<void> agregarFotos(String solicitudId, List<Uint8List> fotos);
}
