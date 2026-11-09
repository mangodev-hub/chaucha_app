// Fila de la tabla `conversaciones` tal como llega de Supabase.
import '../../domain/entities/conversacion.dart';

abstract final class ConversacionModel {
  static const String columnas = 'id, solicitud_id, tecnico_id';

  static Conversacion desdeFila(Map<String, dynamic> fila) => Conversacion(
    id: fila['id'] as String,
    solicitudId: fila['solicitud_id'] as String,
    tecnicoId: fila['tecnico_id'] as String,
  );
}
