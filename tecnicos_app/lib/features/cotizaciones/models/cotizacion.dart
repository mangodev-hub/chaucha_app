// Fila de `cotizaciones` + nombre y calificación del técnico.
import '../../../core/utils/json_utils.dart';

enum EstadoCotizacion {
  pendiente('pendiente'),
  aceptada('aceptada'),
  rechazada('rechazada');

  const EstadoCotizacion(this.valorDb);

  final String valorDb;

  static EstadoCotizacion desdeDb(String valor) =>
      values.firstWhere((e) => e.valorDb == valor);
}


class Cotizacion {
  const Cotizacion({
    required this.id,
    required this.solicitudId,
    required this.tecnicoId,
    required this.tecnicoNombre,
    required this.tecnicoCalificacion,
    required this.manoObra,
    required this.materiales,
    required this.total,
    required this.estado,
    required this.creadoEn,
    this.detalle,
  });




  static const String columnas = 'id, solicitud_id, tecnico_id, mano_obra, '
      'materiales, total, detalle, estado, creado_en, '
      'perfiles_tecnicos(calificacion_promedio, usuarios(nombres, apellidos))';

  final String id;
  final String solicitudId;
  final String tecnicoId;
  final String tecnicoNombre;
  final double tecnicoCalificacion;
  final double manoObra;
  final double materiales;
  final double total;
  final String? detalle;
  final EstadoCotizacion estado;
  final DateTime creadoEn;

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    final perfil = anidado(json['perfiles_tecnicos']);
    final usuario = anidado(perfil?['usuarios']);
    final nombre =
        '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'.trim();
    final manoObra = aDouble(json['mano_obra']);
    final materiales = aDouble(json['materiales']);
    return Cotizacion(
      id: json['id'] as String,
      solicitudId: json['solicitud_id'] as String,
      tecnicoId: json['tecnico_id'] as String,
      tecnicoNombre: nombre.isEmpty ? 'Técnico' : nombre,
      tecnicoCalificacion: aDouble(perfil?['calificacion_promedio']),
      manoObra: manoObra,
      materiales: materiales,

      total: aDouble(json['total'], porDefecto: manoObra + materiales),
      detalle: json['detalle'] as String?,
      estado: EstadoCotizacion.desdeDb(json['estado'] as String),
      creadoEn: aFecha(json['creado_en']),
    );
  }
}


class NuevaCotizacion {
  const NuevaCotizacion({
    required this.solicitudId,
    required this.manoObra,
    required this.materiales,
    this.detalle,
  });

  final String solicitudId;
  final double manoObra;
  final double materiales;
  final String? detalle;
}
