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
    this.rangoBonusM = 0,
  });

  final String usuarioId;
  final double tarifaBase;
  final int rangoCoberturaM;

  /// Bono por reseñas "excelente" de los últimos 90 días (lo calcula un
  /// job nocturno en la base). No lo puede editar el técnico.
  final int rangoBonusM;
  final LatLng? ubicacionActual;
  final int puntos;
  final double calificacionPromedio;
  final int totalResenas;
  final bool verificado;
  final String nivelNombre;
  final double comisionPorcentaje;
  final List<int> oficioIds;

  /// Rango con el que realmente se buscan solicitudes (máx. 50 km).
  int get rangoEfectivoM => (rangoCoberturaM + rangoBonusM).clamp(0, 50000);

  /// Sin oficios o sin ubicación, el técnico no puede ver solicitudes.
  bool get estaCompleto => oficioIds.isNotEmpty && ubicacionActual != null;
}
