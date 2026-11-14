import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/conversacion.dart';

abstract final class ConversacionModel {
  static const String columnas =
      'id, solicitud_id, tecnico_id, solicitudes_servicio(cliente_id)';

  static Conversacion desdeFila(Map<String, dynamic> fila) => Conversacion(
    id: fila['id'] as String,
    solicitudId: fila['solicitud_id'] as String,
    tecnicoId: fila['tecnico_id'] as String,
    clienteId: anidado(fila['solicitudes_servicio'])?['cliente_id'] as String?,
  );
}
