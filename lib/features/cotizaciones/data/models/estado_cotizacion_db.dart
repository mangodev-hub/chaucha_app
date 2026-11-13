// Mapeo de [EstadoCotizacion] al texto de `cotizaciones.estado`.
import '../../domain/entities/cotizacion.dart';

extension EstadoCotizacionDb on EstadoCotizacion {
  String get valorDb => switch (this) {
    EstadoCotizacion.pendiente => 'pendiente',
    EstadoCotizacion.aceptada => 'aceptada',
    EstadoCotizacion.rechazada => 'rechazada',
  };

  static EstadoCotizacion desdeDb(String valor) =>
      EstadoCotizacion.values.firstWhere(
        (estado) => estado.valorDb == valor,
        orElse: () =>
            throw FormatException('Estado de cotización desconocido: $valor'),
      );
}
