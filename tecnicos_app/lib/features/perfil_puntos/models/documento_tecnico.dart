// Tipos permitidos por el CHECK de `documentos_tecnico.tipo`.
enum TipoDocumento {
  cedulaFrontal('cedula_frontal'),
  cedulaPosterior('cedula_posterior'),
  selfie('selfie');

  const TipoDocumento(this.valorDb);

  final String valorDb;

  static TipoDocumento desdeDb(String valor) =>
      values.firstWhere((t) => t.valorDb == valor);
}



enum EstadoDocumento {
  pendiente('pendiente'),
  aprobada('aprobada'),
  rechazada('rechazada');

  const EstadoDocumento(this.valorDb);

  final String valorDb;

  static EstadoDocumento desdeDb(String valor) =>
      values.firstWhere((e) => e.valorDb == valor);
}


class DocumentoTecnico {
  const DocumentoTecnico({
    required this.id,
    required this.tipo,
    required this.estado,
    required this.ruta,
    this.url,
  });

  static const String columnas = 'id, tipo, ruta_archivo, estado';

  final String id;
  final TipoDocumento tipo;
  final EstadoDocumento estado;
  final String ruta;
  final String? url;

  factory DocumentoTecnico.fromJson(Map<String, dynamic> json) {
    return DocumentoTecnico(
      id: json['id'] as String,
      tipo: TipoDocumento.desdeDb(json['tipo'] as String),
      estado: EstadoDocumento.desdeDb(json['estado'] as String),
      ruta: json['ruta_archivo'] as String,
    );
  }

  DocumentoTecnico conUrl(String url) =>
      DocumentoTecnico(id: id, tipo: tipo, estado: estado, ruta: ruta, url: url);

  
  
  static Map<TipoDocumento, DocumentoTecnico> vigentes(
    List<DocumentoTecnico> documentos,
  ) {
    const prioridad = {
      EstadoDocumento.aprobada: 3,
      EstadoDocumento.pendiente: 2,
      EstadoDocumento.rechazada: 1,
    };
    final resultado = <TipoDocumento, DocumentoTecnico>{};
    for (final doc in documentos) {
      final actual = resultado[doc.tipo];
      if (actual == null || prioridad[doc.estado]! > prioridad[actual.estado]!) {
        resultado[doc.tipo] = doc;
      }
    }
    return resultado;
  }
}


class Verificacion {
  const Verificacion(this.documentos);

  final Map<TipoDocumento, DocumentoTecnico> documentos;

  
  bool puedeSubir(TipoDocumento tipo) {
    final doc = documentos[tipo];
    return doc == null || doc.estado == EstadoDocumento.rechazada;
  }

  bool get todoEnviado => TipoDocumento.values.every((t) => !puedeSubir(t));
}