// Perfil de trabajo del técnico + su nivel de gamificación y sus oficios.
import 'package:latlong2/latlong.dart';

class PerfilTecnico {
  const PerfilTecnico({
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

  /// Sin oficios o sin ubicación, el técnico no puede ver solicitudes.
  bool get estaCompleto => oficioIds.isNotEmpty && ubicacionActual != null;
}
