// Fila de la tabla `mensajes` tal como llega de Supabase.
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/mensaje.dart';

class MensajeModel {
  const MensajeModel({
    required this.id,
    required this.conversacionId,
    required this.autorId,
    required this.contenido,
    required this.enviadoEn,
  });

  factory MensajeModel.fromJson(Map<String, dynamic> json) => MensajeModel(
        id: json['id'] as String,
        conversacionId: json['conversacion_id'] as String,
        autorId: json['autor_id'] as String,
        contenido: json['contenido'] as String,
        enviadoEn: aFecha(json['enviado_en']),
      );

  final String id;
  final String conversacionId;
  final String autorId;
  final String contenido;
  final DateTime enviadoEn;

  Mensaje aEntidad() => Mensaje(
        id: id,
        conversacionId: conversacionId,
        autorId: autorId,
        contenido: contenido,
        enviadoEn: enviadoEn,
      );
}
