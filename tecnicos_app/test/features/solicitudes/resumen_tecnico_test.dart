import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/tarifa.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/resumen_tecnico.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';

import 'falsos.dart';

final _hoy = DateTime(2026, 11, 20);

void main() {
  test('cuenta ofertas pendientes y tickets por confirmar', () {
    final r = ResumenTecnico.calcular(
      ofertas: [
        cotizacionDePrueba(id: 'a'),
        cotizacionDePrueba(id: 'b', tarifa: const Tarifa(precioAcordado: 40)),
        cotizacionDePrueba(id: 'c', estado: EstadoCotizacion.rechazada),
      ],
      trabajos: const [],
      hoy: _hoy,
    );

    expect(r.ofertasPendientes, 2);
    expect(r.ticketsPorConfirmar, 1);
    expect(r.completados, 0);
    expect(r.ganadoEsteMes, 0);
  });

  test('los trabajos en curso incluyen los que esperan confirmación', () {
    final r = ResumenTecnico.calcular(
      ofertas: const [],
      trabajos: [
        solicitudDePrueba(id: 's1', estado: EstadoSolicitud.aceptada),
        solicitudDePrueba(id: 's2', estado: EstadoSolicitud.porConfirmar),
        solicitudDePrueba(id: 's3', estado: EstadoSolicitud.completada),
      ],
      hoy: _hoy,
    );

    expect(r.trabajosEnCurso.map((s) => s.id), ['s1', 's2']);
    expect(r.completados, 1);
  });

  test('lo ganado suma los trabajos completados del mes: total del ticket '
      'o precio base, por fecha de servicio', () {
    final r = ResumenTecnico.calcular(
      ofertas: [
        // Completado este mes, con ticket: cuenta el total (40 + 10).
        cotizacionDePrueba(
          id: 'a',
          solicitudId: 's1',
          estado: EstadoCotizacion.aceptada,
          tarifa: Tarifa(
            precioAcordado: 40,
            materiales: 10,
            fechaServicio: DateTime(2026, 11, 5),
          ),
        ),
        // Completado, sin ticket: cuenta el precio base (25), por la fecha
        // de la oferta (7 de noviembre).
        cotizacionDePrueba(
          id: 'b',
          solicitudId: 's2',
          estado: EstadoCotizacion.aceptada,
        ),
        // Completado el mes pasado: no cuenta.
        cotizacionDePrueba(
          id: 'c',
          solicitudId: 's3',
          estado: EstadoCotizacion.aceptada,
          tarifa: Tarifa(
            precioAcordado: 99,
            fechaServicio: DateTime(2026, 10, 30),
          ),
        ),
        // Aceptado pero todavía en curso: no cuenta.
        cotizacionDePrueba(
          id: 'd',
          solicitudId: 's4',
          estado: EstadoCotizacion.aceptada,
        ),
      ],
      trabajos: [
        solicitudDePrueba(id: 's1', estado: EstadoSolicitud.completada),
        solicitudDePrueba(id: 's2', estado: EstadoSolicitud.completada),
        solicitudDePrueba(id: 's3', estado: EstadoSolicitud.completada),
        solicitudDePrueba(id: 's4', estado: EstadoSolicitud.aceptada),
      ],
      hoy: _hoy,
    );

    expect(r.ganadoEsteMes, 75);
    expect(r.completados, 3);
  });
}
