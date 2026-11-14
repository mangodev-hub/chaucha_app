import '../../domain/entities/documento_tecnico.dart';

extension TipoDocumentoDb on TipoDocumento {
  String get valorDb => switch (this) {
    TipoDocumento.cedulaFrontal => 'cedula_frontal',
    TipoDocumento.cedulaPosterior => 'cedula_posterior',
    TipoDocumento.selfie => 'selfie',
  };

  static TipoDocumento desdeDb(String valor) => TipoDocumento.values.firstWhere(
    (tipo) => tipo.valorDb == valor,
    orElse: () =>
        throw FormatException('Tipo de documento desconocido: $valor'),
  );
}

extension EstadoDocumentoDb on EstadoDocumento {
  String get valorDb => switch (this) {
    EstadoDocumento.pendiente => 'pendiente',
    EstadoDocumento.aprobada => 'aprobada',
    EstadoDocumento.rechazada => 'rechazada',
  };

  static EstadoDocumento desdeDb(String valor) =>
      EstadoDocumento.values.firstWhere(
        (estado) => estado.valorDb == valor,
        orElse: () =>
            throw FormatException('Estado de documento desconocido: $valor'),
      );
}
