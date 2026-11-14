import 'documento_tecnico.dart';

/// Dato del registro que se coteja con la cédula.
enum CampoIdentidad {
  cedula('el número de cédula'),
  nombres('los nombres'),
  apellidos('los apellidos'),
  codigoDactilar('el código dactilar');

  const CampoIdentidad(this.descripcion);

  /// Para armar frases: "no coinciden el número de cédula y los nombres".
  final String descripcion;

  static CampoIdentidad? desdeDb(String valor) => switch (valor) {
    'cedula' => CampoIdentidad.cedula,
    'nombres' => CampoIdentidad.nombres,
    'apellidos' => CampoIdentidad.apellidos,
    'codigo_dactilar' => CampoIdentidad.codigoDactilar,
    _ => null,
  };
}

class Verificacion {
  const Verificacion(this.documentos, {this.camposNoCoinciden = const {}});

  final Map<TipoDocumento, DocumentoTecnico> documentos;

  /// Datos del registro que la validación automática encontró distintos a
  /// los de la cédula enviada. La persona los corrige y se vuelve a validar.
  final Set<CampoIdentidad> camposNoCoinciden;

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
