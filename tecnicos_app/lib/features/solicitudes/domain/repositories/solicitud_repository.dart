import 'dart:typed_data';

import '../entities/foto_solicitud.dart';
import '../entities/nueva_solicitud.dart';
import '../entities/solicitud.dart';

abstract interface class SolicitudRepository {
  Future<List<Solicitud>> misSolicitudes();

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
}
