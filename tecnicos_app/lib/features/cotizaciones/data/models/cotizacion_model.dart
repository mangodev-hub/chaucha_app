// Fila de `cotizaciones` + nombre y calificación del técnico (vía join).
//
// Columnas de la oferta y de su ticket de trabajo:
//   precio_base      precio de la visita de la oferta (no cambia con el ticket)
//   detalle          cómo resolvería el problema
//   mano_obra        precio acordado en el ticket (null hasta enviarlo)
//   materiales       materiales del ticket (0 por defecto)
//   total            mano_obra + materiales (columna calculada)
//   tarifa_enviada   true cuando el técnico envió el ticket
//   fecha_servicio   día del servicio acordado (opcional)
//   fecha_propuesta  nueva fecha propuesta al reagendar (null si no hay)
//   propuesta_por    quién propuso la nueva fecha (null si no hay)
//
// Las ofertas antiguas (antes de `precio_base`) guardaban su precio en
// mano_obra + materiales, y no tienen ticket.
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/cotizacion.dart';
import '../../domain/entities/tarifa.dart';
import 'estado_cotizacion_db.dart';

abstract final class CotizacionModel {
  /// Columnas que se piden en el `select`, con el join al técnico.
  static const String columnas =
      'id, solicitud_id, tecnico_id, precio_base, detalle, mano_obra, '
      'materiales, total, tarifa_enviada, fecha_servicio, fecha_propuesta, '
      'propuesta_por, estado, creado_en, '
      'perfiles_tecnicos!fk_cotizaciones_tecnico(calificacion_promedio, '
      'usuarios!fk_perfiles_usuario(nombres, apellidos))';

  static Cotizacion desdeFila(Map<String, dynamic> json) {
    // El join puede llegar como objeto o como lista de un elemento.
    final perfil = anidado(json['perfiles_tecnicos']);
    final usuario = anidado(perfil?['usuarios']);
    final nombre = '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'
        .trim();
    final manoObra = aDouble(json['mano_obra']);
    final materiales = aDouble(json['materiales']);
    final solucion = (json['detalle'] as String?)?.trim();
    final fecha = json['fecha_servicio'];
    final propuesta = json['fecha_propuesta'];
    return Cotizacion(
      id: json['id'] as String,
      solicitudId: json['solicitud_id'] as String,
      tecnicoId: json['tecnico_id'] as String,
      tecnicoNombre: nombre.isEmpty ? 'Técnico' : nombre,
      tecnicoCalificacion: aDouble(perfil?['calificacion_promedio']),
      precioBase: json['precio_base'] != null
          ? aDouble(json['precio_base'])
          : aDouble(json['total'], porDefecto: manoObra + materiales),
      solucion: solucion == null || solucion.isEmpty ? null : solucion,
      tarifa: json['tarifa_enviada'] == true
          ? Tarifa(
              precioAcordado: manoObra,
              fechaServicio: fecha is String ? aFecha(fecha).toLocal() : null,
            )
          : null,
      fechaPropuesta: propuesta is String ? aFecha(propuesta).toLocal() : null,
      propuestaPor: json['propuesta_por'] as String?,
      estado: EstadoCotizacionDb.desdeDb(json['estado'] as String),
      creadoEn: aFecha(json['creado_en']),
    );
  }

  static Map<String, dynamic> filaNueva({
    required String solicitudId,
    required String tecnicoId,
    required String solucion,
  }) => {
    'solicitud_id': solicitudId,
    'tecnico_id': tecnicoId,
    'detalle': solucion.trim(),
    'materiales': 0,
  };

  /// Cambios cuando el cliente rechaza el ticket.
  static const Map<String, dynamic> cambiosRechazo = {'tarifa_enviada': false};
}