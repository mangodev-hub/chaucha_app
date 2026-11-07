// Widgets compartidos de solicitudes: chip de estado, tarjeta y galería.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../domain/entities/solicitud.dart';

extension EstadoSolicitudVista on EstadoSolicitud {
  String get etiqueta => switch (this) {
        EstadoSolicitud.abierta => 'Abierta',
        EstadoSolicitud.cotizada => 'Con cotizaciones',
        EstadoSolicitud.aceptada => 'En curso',
        EstadoSolicitud.porConfirmar => 'Por confirmar',
        EstadoSolicitud.completada => 'Completada',
        EstadoSolicitud.cancelada => 'Cancelada',
      };

  /// El acento (verde) queda solo para lo positivo: trabajo completado.
  Color get color => switch (this) {
        EstadoSolicitud.abierta || EstadoSolicitud.cotizada => Colores.info,
        EstadoSolicitud.aceptada => Colores.tinta,
        EstadoSolicitud.porConfirmar => Colores.aviso,
        EstadoSolicitud.completada => Colores.acento,
        EstadoSolicitud.cancelada => Colores.tintaSuave,
      };
}

class EstadoChip extends StatelessWidget {
  const EstadoChip(this.estado, {super.key});

  final EstadoSolicitud estado;

  @override
  Widget build(BuildContext context) {
    final color = estado.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Text(
        estado.etiqueta,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}


class SolicitudCard extends StatelessWidget {
  const SolicitudCard({
    super.key,
    required this.solicitud,
    required this.onTap,
    this.extra,
  });

  final Solicitud solicitud;
  final VoidCallback onTap;


  final String? extra;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(Radios.grande),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(solicitud.oficioNombre, style: textos.titleMedium),
                  ),
                  EstadoChip(solicitud.estado),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                solicitud.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                [
                  Formatos.fecha(solicitud.creadoEn),
                  ?extra,
                ].join(' · '),
                style: textos.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GaleriaFotos extends StatelessWidget {
  const GaleriaFotos({super.key, required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const Text('Sin fotos.');
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (context, indice) => const SizedBox(width: 8),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog(child: Image.network(urls[i])),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              urls[i],
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, pila) => const SizedBox(
                width: 110,
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
