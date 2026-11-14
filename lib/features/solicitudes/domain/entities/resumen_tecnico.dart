import '../../../cotizaciones/domain/entities/cotizacion.dart';
import 'solicitud.dart';

class ResumenTecnico {
  const ResumenTecnico({
    required this.ofertasPendientes,
    required this.ticketsPorConfirmar,
    required this.trabajosEnCurso,
    required this.completados,
    required this.ganadoEsteMes,
  });

  /// [ofertas]: las del técnico.
  factory ResumenTecnico.calcular({
    required List<Cotizacion> ofertas,
    required List<Solicitud> trabajos,
    required DateTime hoy,
  }) {
    final completadas = {
      for (final t in trabajos)
        if (t.estado == EstadoSolicitud.completada) t.id,
    };
    var ganado = 0.0;
    for (final o in ofertas) {
      if (o.estado != EstadoCotizacion.aceptada) continue;
      if (!completadas.contains(o.solicitudId)) continue;
      final fecha = o.tarifa?.fechaServicio ?? o.creadoEn;
      if (fecha.year == hoy.year && fecha.month == hoy.month) {
        ganado += o.tarifa?.total ?? o.precioBase;
      }
    }
    return ResumenTecnico(
      ofertasPendientes: ofertas
          .where((o) => o.estado == EstadoCotizacion.pendiente)
          .length,
      ticketsPorConfirmar: ofertas.where((o) => o.tarifaPendiente).length,
      trabajosEnCurso: [
        for (final t in trabajos)
          if (t.estado == EstadoSolicitud.aceptada ||
              t.estado == EstadoSolicitud.porConfirmar)
            t,
      ],
      completados: completadas.length,
      ganadoEsteMes: ganado,
    );
  }

  final int ofertasPendientes;
  final int ticketsPorConfirmar;

  /// En curso o esperando que el cliente confirme.
  final List<Solicitud> trabajosEnCurso;
  final int completados;
  final double ganadoEsteMes;
}
