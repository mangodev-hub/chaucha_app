import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/cabecera_cielo.dart';
import '../../../../core/widgets/indicador_pasos.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../domain/entities/detalle_solicitud.dart';
import '../../domain/entities/solicitud.dart';
import 'solicitud_widgets.dart';

/// Oficio, estado, fecha, descripción y referencia de la dirección, en la
/// cabecera celeste con el técnico (Lottie) a la derecha.
class EncabezadoSolicitud extends StatelessWidget {
  const EncabezadoSolicitud({super.key, required this.solicitud});

  final Solicitud solicitud;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final direccion = solicitud.direccionReferencia;
    return CabeceraCielo(
      titulo: solicitud.oficioNombre,
      subtitulo: 'Publicada el ${Formatos.fecha(solicitud.creadoEn)}',
      pildora: EstadoChip(solicitud.estado),
      animacion: 'assets/lottie/tecnico.json',
      altoAnimacion: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(solicitud.descripcion, style: textos.bodyLarge),
          if (direccion != null && direccion.isNotEmpty) ...[
            const SizedBox(height: Espacios.m),
            _Dato(icono: Icons.place_outlined, texto: direccion),
          ],
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Colores.tintaSuave);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icono, size: 18, color: Colores.cieloOscuro),
        ),
        const SizedBox(width: Espacios.s),
        Expanded(child: Text(texto, style: estilo)),
      ],
    );
  }
}

/// Mensaje corto que explica en qué punto está la solicitud y qué debe hacer
/// quien la mira, con el progreso de pasos debajo.
class QueSigueCard extends StatelessWidget {
  const QueSigueCard({super.key, required this.detalle});

  final DetalleSolicitud detalle;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final guia = _Guia.de(detalle);
    final cancelada = detalle.estado == EstadoSolicitud.cancelada;
    return Container(
      padding: const EdgeInsets.all(Espacios.l),
      decoration: BoxDecoration(
        color: guia.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(guia.icono, color: guia.color),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guia.titulo, style: textos.titleMedium),
                    const SizedBox(height: Espacios.xs),
                    Text(guia.texto, style: textos.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          if (!cancelada) ...[
            const SizedBox(height: Espacios.l),
            ProgresoSolicitud(estado: detalle.estado),
          ],
        ],
      ),
    );
  }
}

class _Guia {
  const _Guia(this.icono, this.titulo, this.texto, this.color);

  final IconData icono;
  final String titulo;
  final String texto;
  final Color color;

  static _Guia de(DetalleSolicitud d) =>
      d.soyCliente ? _paraCliente(d) : _paraTecnico(d);

  static _Guia _paraCliente(DetalleSolicitud d) {
    final n = d.cotizaciones.length;
    final tecnico = d.cotizacionAceptada?.tecnicoNombre;
    return switch (d.estado) {
      EstadoSolicitud.abierta ||
      EstadoSolicitud.cotizada when n == 0 => const _Guia(
        Icons.hourglass_top,
        'Esperando ofertas',
        'Los técnicos de la zona revisarán tu solicitud. '
            'Te avisaremos cuando ofrezcan sus servicios.',
        Colores.info,
      ),
      EstadoSolicitud.abierta || EstadoSolicitud.cotizada
          when d.cotizaciones.any((c) => c.tarifaPendiente) =>
        const _Guia(
          Icons.receipt_long_outlined,
          'Tienes un ticket por confirmar',
          'Un técnico te envió el precio acordado. Revísalo en el chat y '
              'confírmalo para empezar.',
          Colores.aviso,
        ),
      EstadoSolicitud.abierta || EstadoSolicitud.cotizada => _Guia(
        Icons.local_offer_outlined,
        n == 1 ? 'Tienes 1 oferta' : 'Tienes $n ofertas',
        'Revisa el precio de la visita y la solución de cada técnico. Escríbele al '
        'que te guste para acordar el precio.',
        Colores.info,
      ),
      EstadoSolicitud.aceptada => _Guia(
        Icons.handyman_outlined,
        'Trabajo en curso',
        '${tecnico ?? 'El técnico'} está a cargo. '
            'Coordina los detalles por el chat.',
        Colores.primario,
      ),
      EstadoSolicitud.porConfirmar => const _Guia(
        Icons.fact_check_outlined,
        'Revisa y confirma',
        'El técnico marcó el trabajo como terminado. '
            'Revisa la evidencia y confírmalo.',
        Colores.aviso,
      ),
      EstadoSolicitud.completada => const _Guia(
        Icons.verified_outlined,
        'Trabajo completado',
        'Califica al técnico para ayudar a otros clientes.',
        Colores.acento,
      ),
      EstadoSolicitud.cancelada => const _Guia(
        Icons.cancel_outlined,
        'Solicitud cancelada',
        'Ya no recibe ofertas.',
        Colores.tintaSuave,
      ),
    };
  }

  static _Guia _paraTecnico(DetalleSolicitud d) {
    final mia = d.miCotizacion;
    if (d.estado == EstadoSolicitud.cancelada) {
      return const _Guia(
        Icons.cancel_outlined,
        'Solicitud cancelada',
        'El cliente canceló esta solicitud.',
        Colores.tintaSuave,
      );
    }
    if (d.soyTecnicoAsignado) {
      return switch (d.estado) {
        EstadoSolicitud.porConfirmar => const _Guia(
          Icons.hourglass_top,
          'Esperando al cliente',
          'El cliente debe revisar la evidencia y confirmar el trabajo.',
          Colores.aviso,
        ),
        EstadoSolicitud.completada => const _Guia(
          Icons.verified_outlined,
          'Trabajo completado',
          'Califica al cliente para cerrar el trabajo.',
          Colores.acento,
        ),
        _ => const _Guia(
          Icons.handyman_outlined,
          'Trabajo asignado',
          'Cuando termines, sube fotos del trabajo para que el cliente '
              'lo confirme.',
          Colores.primario,
        ),
      };
    }
    if (mia?.estado == EstadoCotizacion.rechazada) {
      return const _Guia(
        Icons.info_outline,
        'El cliente eligió otra oferta',
        'Esta solicitud ya no está disponible para ti.',
        Colores.tintaSuave,
      );
    }
    if (!d.estado.recibeCotizaciones) {
      return const _Guia(
        Icons.lock_outline,
        'Solicitud cerrada',
        'Esta solicitud ya no recibe ofertas.',
        Colores.tintaSuave,
      );
    }
    if (mia?.tarifaPendiente ?? false) {
      return const _Guia(
        Icons.receipt_long_outlined,
        'Ticket enviado',
        'Esperando que el cliente lo confirme en el chat.',
        Colores.aviso,
      );
    }
    if (mia == null) {
      return const _Guia(
        Icons.handyman_outlined,
        'Ofrece tus servicios',
        'Revisa el problema y la ubicación. Envía tu precio de la visita y explica '
            'cómo lo resolverías.',
        Colores.info,
      );
    }
    return const _Guia(
      Icons.schedule_send_outlined,
      'Oferta enviada',
      'Si al cliente le interesa, te escribirá por el chat para acordar el '
          'precio.',
      Colores.info,
    );
  }
}

/// Cuatro pasos: publicada → en curso → por confirmar → completada.
class ProgresoSolicitud extends StatelessWidget {
  const ProgresoSolicitud({super.key, required this.estado});

  static const List<String> _pasos = [
    'Publicada',
    'En curso',
    'Por confirmar',
    'Completada',
  ];

  final EstadoSolicitud estado;

  int get _completados => switch (estado) {
    EstadoSolicitud.abierta ||
    EstadoSolicitud.cotizada ||
    EstadoSolicitud.cancelada => 1,
    EstadoSolicitud.aceptada => 2,
    EstadoSolicitud.porConfirmar => 3,
    EstadoSolicitud.completada => 4,
  };

  @override
  Widget build(BuildContext context) {
    return IndicadorPasos(
      total: _pasos.length,
      completados: _completados,
      etiquetas: _pasos,
      color: estado == EstadoSolicitud.completada
          ? Colores.acento
          : Colores.primarioOscuro,
    );
  }
}
