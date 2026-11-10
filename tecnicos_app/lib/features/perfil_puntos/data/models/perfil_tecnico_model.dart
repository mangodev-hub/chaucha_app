// Fila de `perfiles_tecnicos` + nivel de gamificación + sus oficios (joins).
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/perfil_tecnico.dart';

class PerfilTecnicoModel {
  const PerfilTecnicoModel({
    required this.usuarioId,
    required this.tarifaBase,
    required this.rangoCoberturaM,
    required this.puntos,
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.verificado,
    required this.nivelNombre,
    required this.comisionPorcentaje,
    required this.oficioIds,
    this.ubicacionActual,
  });

  factory PerfilTecnicoModel.fromJson(Map<String, dynamic> json) {
    final nivel = anidado(json['niveles_gamificacion']);
    final oficios = (json['tecnico_oficios'] as List?) ?? const [];
    return PerfilTecnicoModel(
      usuarioId: json['usuario_id'] as String,
      tarifaBase: aDouble(json['tarifa_base']),
      rangoCoberturaM: aInt(json['rango_cobertura_m'], porDefecto: 5000),
      ubicacionActual: GeoMapper.fromDb(json['ubicacion_actual']),
      puntos: aInt(json['puntos']),
      calificacionPromedio: aDouble(json['calificacion_promedio']),
      totalResenas: aInt(json['total_resenas']),
      verificado: json['verificado'] as bool? ?? false,
      nivelNombre: nivel?['nombre'] as String? ?? 'Sin nivel',
      comisionPorcentaje: aDouble(nivel?['comision_porcentaje']),
      oficioIds: [
        for (final fila in oficios.whereType<Map<String, dynamic>>())
          aInt(fila['oficio_id']),
      ],
    );
  }

  /// Columnas que se piden en el `select`, con los joins a nivel y oficios.
  static const String columnas =
      'usuario_id, tarifa_base, rango_cobertura_m, '
      'ubicacion_actual, puntos, calificacion_promedio, total_resenas, '
      'verificado, niveles_gamificacion(nombre, comision_porcentaje), '
      'tecnico_oficios(oficio_id)';

  final String usuarioId;
  final double tarifaBase;
  final int rangoCoberturaM;
  final LatLng? ubicacionActual;
  final int puntos;
  final double calificacionPromedio;
  final int totalResenas;
  final bool verificado;
  final String nivelNombre;
  final double comisionPorcentaje;
  final List<int> oficioIds;

  PerfilTecnico aEntidad() => PerfilTecnico(
    usuarioId: usuarioId,
    tarifaBase: tarifaBase,
    rangoCoberturaM: rangoCoberturaM,
    ubicacionActual: ubicacionActual,
    puntos: puntos,
    calificacionPromedio: calificacionPromedio,
    totalResenas: totalResenas,
    verificado: verificado,
    nivelNombre: nivelNombre,
    comisionPorcentaje: comisionPorcentaje,
    oficioIds: oficioIds,
  );
}
