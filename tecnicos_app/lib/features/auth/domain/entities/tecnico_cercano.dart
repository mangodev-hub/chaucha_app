import 'package:latlong2/latlong.dart';

class TecnicoCercano {
  const TecnicoCercano({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.oficios,
    required this.calificacion,
    required this.totalResenas,
    required this.metros,
    required this.ubicacion,
    required this.tarifaBase,
    required this.nivel,
  });

  final String id;
  final String nombres;
  final String apellidos;
  final List<String> oficios;
  final double calificacion;
  final int totalResenas;
  final int metros;
  final LatLng ubicacion;
  final double tarifaBase;
  final String nivel;

  String get primerNombre => nombres.split(' ').first;

  String get nombreCorto => '$primerNombre ${apellidos.split(' ').first}'.trim();

  String get iniciales {
    final a = nombres.isEmpty ? '' : nombres[0];
    final b = apellidos.isEmpty ? '' : apellidos[0];
    return '$a$b'.toUpperCase();
  }
}