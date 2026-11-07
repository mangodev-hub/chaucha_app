// Fila de `cotizaciones` + nombre y calificación del técnico (vía join).
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/cotizacion.dart';
import 'estado_cotizacion_db.dart';

class CotizacionModel {
  const CotizacionModel({
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

  factory CotizacionModel.fromJson(Map<String, dynamic> json) {
    // El join puede llegar como objeto o como lista de un elemento.
    final perfil = anidado(json['perfiles_tecnicos']);
    final usuario = anidado(perfil?['usuarios']);
    final nombre =
        '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'.trim();
    final manoObra = aDouble(json['mano_obra']);
    final materiales = aDouble(json['materiales']);
    return CotizacionModel(
      id: json['id'] as String,
      solicitudId: json['solicitud_id'] as String,
      tecnicoId: json['tecnico_id'] as String,
      tecnicoNombre: nombre.isEmpty ? 'Técnico' : nombre,
      tecnicoCalificacion: aDouble(perfil?['calificacion_promedio']),
      manoObra: manoObra,
      materiales: materiales,
      // `total` es una columna calculada; si no llega, se calcula aquí.
      total: aDouble(json['total'], porDefecto: manoObra + materiales),
      detalle: json['detalle'] as String?,
      estado: EstadoCotizacionDb.desdeDb(json['estado'] as String),
      creadoEn: aFecha(json['creado_en']),
    );
  }

  /// Columnas que se piden en el `select`, con el join al técnico.
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

  Cotizacion aEntidad() => Cotizacion(
        id: id,
        solicitudId: solicitudId,
        tecnicoId: tecnicoId,
        tecnicoNombre: tecnicoNombre,
        tecnicoCalificacion: tecnicoCalificacion,
        manoObra: manoObra,
        materiales: materiales,
        total: total,
        estado: estado,
        creadoEn: creadoEn,
        detalle: detalle,
      );
}
