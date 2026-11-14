import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../domain/entities/reclamo.dart';
import '../providers/reclamos_provider.dart';

extension EstadoReclamoVista on EstadoReclamo {
  /// (fondo, texto)
  (Color, Color) get colores => switch (this) {
    EstadoReclamo.recibido => (Colores.superficie, Colores.tintaSuave),
    EstadoReclamo.enRevision => (Colores.cieloSuave, Colores.cieloOscuro),
    EstadoReclamo.necesitaInfo => (Colores.avisoSuave, Colores.avisoOscuro),
    EstadoReclamo.resuelto => (Colores.primarioSuave, Colores.primario),
    EstadoReclamo.rechazado => (Colores.superficieFuerte, Colores.tinta),
  };
}

class PildoraEstadoReclamo extends StatelessWidget {
  const PildoraEstadoReclamo(this.estado, {super.key});

  final EstadoReclamo estado;

  @override
  Widget build(BuildContext context) {
    final (fondo, texto) = estado.colores;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Text(
        estado.etiqueta,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: texto, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Recibido → En revisión → Cerrado (Resuelto o Rechazado).
class PasosReclamo extends StatelessWidget {
  const PasosReclamo({super.key, required this.estado});

  final EstadoReclamo estado;

  @override
  Widget build(BuildContext context) {
    final paso = switch (estado) {
      EstadoReclamo.recibido => 0,
      EstadoReclamo.enRevision || EstadoReclamo.necesitaInfo => 1,
      EstadoReclamo.resuelto || EstadoReclamo.rechazado => 2,
    };
    final cierre = switch (estado) {
      EstadoReclamo.resuelto => 'Resuelto',
      EstadoReclamo.rechazado => 'Rechazado',
      _ => 'Cerrado',
    };
    final pasos = ['Recibido', 'En revisión', cierre];
    final textos = Theme.of(context).textTheme;
    return Semantics(
      label: 'Paso ${paso + 1} de 3: ${pasos[paso]}',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 0; i < pasos.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: Espacios.xs),
                  color: i <= paso ? Colores.primarioVivo : Colores.linea,
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: i <= paso ? Colores.primarioVivo : Colores.tarjeta,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: i <= paso ? Colores.primarioVivo : Colores.linea,
                      width: 2,
                    ),
                  ),
                  child: i < paso || (i == paso && paso == 2)
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colores.sobreOscuro,
                        )
                      : null,
                ),
                const SizedBox(height: Espacios.xs),
                Text(
                  pasos[i],
                  style: textos.labelSmall?.copyWith(
                    color: i <= paso ? Colores.tinta : Colores.tintaSuave,
                    fontWeight: i == paso ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Un mensaje de la conversación del reclamo. El sistema va centrado, el
/// asesor a la izquierda y [esMio] a la derecha en verde suave.
class BurbujaReclamo extends StatelessWidget {
  const BurbujaReclamo({super.key, required this.mensaje, required this.esMio});

  final MensajeReclamo mensaje;
  final bool esMio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final hora =
        '${Formatos.dia(mensaje.creadoEn)} ${Formatos.hora(mensaje.creadoEn)}';

    if (mensaje.esSistema) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(vertical: Espacios.s),
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.l,
            vertical: Espacios.m,
          ),
          decoration: BoxDecoration(
            color: Colores.superficie,
            borderRadius: BorderRadius.circular(Radios.medio),
          ),
          child: Text(
            mensaje.texto,
            textAlign: TextAlign.center,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ),
      );
    }

    final burbuja = Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.m + 2,
        vertical: Espacios.s + 2,
      ),
      decoration: BoxDecoration(
        color: esMio ? Colores.primarioSuave : Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.medio),
        border: esMio ? null : Border.all(color: Colores.linea),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mensaje.esAsesor)
            Text(
              'Asesor ChauchaApp',
              style: textos.labelMedium?.copyWith(
                color: Colores.primario,
                fontWeight: FontWeight.w800,
              ),
            ),
          Text(mensaje.texto, style: textos.bodyMedium),
          const SizedBox(height: 2),
          Text(
            hora,
            style: textos.labelSmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.xs),
      child: Row(
        mainAxisAlignment: esMio
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (mensaje.esAsesor) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colores.primarioSuave,
              child: Icon(
                Icons.shield_outlined,
                size: 18,
                color: Colores.primario,
              ),
            ),
            const SizedBox(width: Espacios.s),
          ],
          Flexible(child: burbuja),
        ],
      ),
    );
  }
}

/// Miniatura de una evidencia (URL firmada). Al tocarla se ve grande.
class MiniaturaEvidencia extends ConsumerWidget {
  const MiniaturaEvidencia({super.key, required this.ruta, this.lado = 72});

  final String ruta;
  final double lado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(urlEvidenciaProvider(ruta)).value;
    final borde = BorderRadius.circular(Radios.pequeno);
    final caja = Container(
      width: lado,
      height: lado,
      color: Colores.superficie,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Colores.tintaSuave),
    );
    return Semantics(
      button: url != null,
      label: 'Foto de evidencia',
      child: InkWell(
        borderRadius: borde,
        onTap: url == null
            ? null
            : () => showDialog<void>(
                context: context,
                builder: (dialogo) => Dialog(
                  clipBehavior: Clip.antiAlias,
                  child: InteractiveViewer(child: Image.network(url)),
                ),
              ),
        child: ClipRRect(
          borderRadius: borde,
          child: url == null
              ? caja
              : Image.network(
                  url,
                  width: lado,
                  height: lado,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => caja,
                ),
        ),
      ),
    );
  }
}
