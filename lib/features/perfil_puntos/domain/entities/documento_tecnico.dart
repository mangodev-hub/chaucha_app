enum TipoDocumento { cedulaFrontal, cedulaPosterior, selfie }

enum EstadoDocumento { pendiente, aprobada, rechazada }

class DocumentoTecnico {
  const DocumentoTecnico({
    required this.id,
    required this.tipo,
    required this.estado,
    required this.ruta,
    this.observacion,
    this.url,
  });

  final String id;
  final TipoDocumento tipo;
  final EstadoDocumento estado;

  /// Ruta del archivo en Storage.
  final String ruta;

  /// Por qué se rechazó (validación automática o admin), si se rechazó.
  final String? observacion;

  /// URL firmada para mostrar la imagen (el bucket es privado).
  final String? url;

  DocumentoTecnico conUrl(String url) => DocumentoTecnico(
    id: id,
    tipo: tipo,
    estado: estado,
    ruta: ruta,
    observacion: observacion,
    url: url,
  );
}
