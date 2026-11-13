import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/reclamo.dart';

extension CategoriaReclamoDb on CategoriaReclamo {
  String get db => switch (this) {
    CategoriaReclamo.fallaTrabajo => 'falla_trabajo',
    CategoriaReclamo.noSePresento => 'no_se_presento',
    CategoriaReclamo.trato => 'trato',
    CategoriaReclamo.cobroIndebido => 'cobro_indebido',
    CategoriaReclamo.otro => 'otro',
  };

  static CategoriaReclamo desdeDb(String valor) => CategoriaReclamo.values
      .firstWhere((c) => c.db == valor, orElse: () => CategoriaReclamo.otro);
}

extension EstadoReclamoDb on EstadoReclamo {
  String get db => switch (this) {
    EstadoReclamo.recibido => 'recibido',
    EstadoReclamo.enRevision => 'en_revision',
    EstadoReclamo.necesitaInfo => 'necesita_info',
    EstadoReclamo.resuelto => 'resuelto',
    EstadoReclamo.rechazado => 'rechazado',
  };

  static EstadoReclamo desdeDb(String valor) => EstadoReclamo.values.firstWhere(
    (e) => e.db == valor,
    orElse: () => EstadoReclamo.recibido,
  );
}

abstract final class ReclamoModel {
  static const String columnas =
      'id, numero, solicitud_id, cotizacion_id, autor_id, contra_id, '
      'categoria, descripcion, evidencias, estado, resolucion, creado_en, '
      'cerrado_en, '
      'solicitud:solicitudes_servicio(descripcion, cliente_id, oficios(nombre)), '
      'cotizacion:cotizaciones(inicio_visita), '
      'autor:usuarios!reclamos_autor_id_fkey(nombres, apellidos), '
      'contra:usuarios!reclamos_contra_id_fkey(nombres, apellidos)';

  static String? _nombre(Object? fila) {
    final u = anidado(fila);
    if (u == null) return null;
    final nombre = '${u['nombres'] ?? ''} ${u['apellidos'] ?? ''}'.trim();
    return nombre.isEmpty ? null : nombre;
  }

  static DateTime? _fecha(Object? valor) =>
      valor is String ? aFecha(valor).toLocal() : null;

  static Reclamo desdeFila(Map<String, dynamic> f) {
    final solicitud = anidado(f['solicitud']);
    return Reclamo(
      id: f['id'] as String,
      numero: aInt(f['numero']),
      solicitudId: f['solicitud_id'] as String,
      cotizacionId: f['cotizacion_id'] as String?,
      autorId: f['autor_id'] as String,
      contraId: f['contra_id'] as String?,
      categoria: CategoriaReclamoDb.desdeDb(f['categoria'] as String),
      descripcion: f['descripcion'] as String,
      evidencias: [
        for (final e in (f['evidencias'] as List<dynamic>? ?? const []))
          e as String,
      ],
      estado: EstadoReclamoDb.desdeDb(f['estado'] as String),
      resolucion: f['resolucion'] as String?,
      creadoEn: aFecha(f['creado_en']).toLocal(),
      cerradoEn: _fecha(f['cerrado_en']),
      clienteId: solicitud?['cliente_id'] as String?,
      oficio: anidado(solicitud?['oficios'])?['nombre'] as String?,
      servicio: solicitud?['descripcion'] as String?,
      autorNombre: _nombre(f['autor']),
      contraNombre: _nombre(f['contra']),
      inicioVisita: _fecha(anidado(f['cotizacion'])?['inicio_visita']),
    );
  }

  static MensajeReclamo mensajeDesdeFila(Map<String, dynamic> f) =>
      MensajeReclamo(
        id: f['id'] as String,
        autorId: f['autor_id'] as String?,
        esAsesor: f['es_asesor'] as bool? ?? false,
        texto: f['texto'] as String,
        creadoEn: aFecha(f['creado_en']).toLocal(),
      );
}
