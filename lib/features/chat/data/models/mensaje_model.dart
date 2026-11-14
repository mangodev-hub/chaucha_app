import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/mensaje.dart';

class MensajeModel {
  const MensajeModel({
    required this.id,
    required this.conversacionId,
    required this.autorId,
    required this.contenido,
    required this.enviadoEn,
    this.tipo = 'texto',
    this.datos,
  });

  factory MensajeModel.fromJson(Map<String, dynamic> json) => MensajeModel(
    id: json['id'] as String,
    conversacionId: json['conversacion_id'] as String,
    autorId: json['autor_id'] as String,
    contenido: json['contenido'] as String,
    enviadoEn: aFecha(json['enviado_en']),
    tipo: (json['tipo'] as String?) ?? 'texto',
    datos: json['datos'] is Map
        ? Map<String, dynamic>.from(json['datos'] as Map)
        : null,
  );

  final String id;
  final String conversacionId;
  final String autorId;
  final String contenido;
  final DateTime enviadoEn;
  final String tipo;
  final Map<String, dynamic>? datos;

  Mensaje aEntidad() => Mensaje(
    id: id,
    conversacionId: conversacionId,
    autorId: autorId,
    contenido: contenido,
    enviadoEn: enviadoEn,
    tipo: tipo,
    datos: datos,
  );
}
