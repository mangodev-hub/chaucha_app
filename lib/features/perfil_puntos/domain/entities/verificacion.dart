// Estado de la verificación de identidad: el documento vigente de cada tipo.
import 'documento_tecnico.dart';

class Verificacion {
  const Verificacion(this.documentos);

  final Map<TipoDocumento, DocumentoTecnico> documentos;

  /// Elige el documento vigente de cada tipo cuando hay varios subidos:
  /// aprobada > pendiente > rechazada.
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
      if (actual == null ||
          prioridad[doc.estado]! > prioridad[actual.estado]!) {
        resultado[doc.tipo] = doc;
      }
    }
    return resultado;
  }

  /// Se puede subir si nunca se envió o si el último fue rechazado.
  bool puedeSubir(TipoDocumento tipo) {
    final doc = documentos[tipo];
    return doc == null || doc.estado == EstadoDocumento.rechazada;
  }

  bool get todoEnviado => TipoDocumento.values.every((t) => !puedeSubir(t));
}
