// Contrato de solicitudes. Los métodos lanzan [AppFailure] si fallan.
import 'dart:typed_data';

import '../entities/foto_solicitud.dart';
import '../entities/nueva_solicitud.dart';
import '../entities/solicitud.dart';

abstract interface class SolicitudRepository {
  /// Solicitudes del cliente conectado, de la más nueva a la más antigua.
  Future<List<Solicitud>> misSolicitudes();

  /// Crea la solicitud, sube sus fotos y devuelve su id.
  Future<String> crear(NuevaSolicitud nueva);

  /// Solicitudes abiertas o cotizadas de esos oficios.
  Future<List<Solicitud>> abiertasDeOficios(List<int> oficioIds);

  /// Solicitudes en las que el técnico conectado tiene la cotización aceptada.
  Future<List<Solicitud>> misTrabajos();

  /// Sube la evidencia y deja la solicitud por confirmar.
  Future<void> marcarTerminada(String solicitudId, List<Uint8List> evidencias);

  Future<Solicitud> obtener(String id);

  Future<List<FotoSolicitud>> fotos(String solicitudId);

  Future<void> cambiarEstado(String solicitudId, EstadoSolicitud estado);
}
