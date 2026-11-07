// Fila de la tabla `oficios` tal como llega de Supabase.
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/oficio.dart';

class OficioModel {
  const OficioModel({required this.id, required this.nombre});

  factory OficioModel.fromJson(Map<String, dynamic> json) =>
      OficioModel(id: aInt(json['id']), nombre: json['nombre'] as String);

  final int id;
  final String nombre;

  Oficio aEntidad() => Oficio(id: id, nombre: nombre);
}
