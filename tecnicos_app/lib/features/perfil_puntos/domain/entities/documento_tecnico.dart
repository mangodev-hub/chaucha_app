// Documento de verificación de identidad que sube el técnico.
enum TipoDocumento { cedulaFrontal, cedulaPosterior, selfie }

enum EstadoDocumento { pendiente, aprobada, rechazada }

class DocumentoTecnico {
  const DocumentoTecnico({
    required this.id,
    required this.tipo,
    required this.estado,
    required this.ruta,
    this.url,
  });

  final String id;
  final TipoDocumento tipo;
  final EstadoDocumento estado;

  /// Ruta del archivo en Storage.
  final String ruta;

  /// URL firmada para mostrar la imagen (el bucket es privado).
  final String? url;

  DocumentoTecnico conUrl(String url) =>
      DocumentoTecnico(id: id, tipo: tipo, estado: estado, ruta: ruta, url: url);
}
