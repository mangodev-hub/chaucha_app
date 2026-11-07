// Fila de `mensajes`.
import '../../../core/utils/json_utils.dart';


class Mensaje {
  const Mensaje({
    required this.id,
    required this.conversacionId,
    required this.autorId,
    required this.contenido,
    required this.enviadoEn,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
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
}
