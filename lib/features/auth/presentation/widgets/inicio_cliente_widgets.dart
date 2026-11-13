// Bloques del inicio del cliente: portada, solicitud activa, técnicos cerca,
// chats y próxima visita.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../../chat/domain/entities/resumen_chat.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../domain/entities/tecnico_cercano.dart';

String _iniciales(String nombre) => nombre
    .split(' ')
    .where((p) => p.isNotEmpty)
    .take(2)
    .map((p) => p[0])
    .join()
    .toUpperCase();

class TituloBloque extends StatelessWidget {
  const TituloBloque({
    super.key,
    required this.titulo,
    this.enlace,
    this.onEnlace,
    this.tamano = 18,
  });

  final String titulo;
  final String? enlace;
  final VoidCallback? onEnlace;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final enlace = this.enlace;
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: textos.titleMedium?.copyWith(
              fontSize: tamano,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (enlace != null && onEnlace != null)
          TextButton(
            onPressed: onEnlace,
            style: TextButton.styleFrom(
              foregroundColor: Colores.primario,
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: Espacios.s),
              textStyle: textos.labelLarge?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: Text(enlace),
          ),
      ],
    );
  }
}

class PortadaCliente extends StatelessWidget {
  const PortadaCliente({
    super.key,
    required this.nombre,
    required this.subtitulo,
    required this.oficios,
    required this.onOficio,
    required this.onTodos,
  });

  final String nombre;
  final String subtitulo;
  final List<Oficio> oficios;
  final ValueChanged<Oficio> onOficio;
  final VoidCallback? onTodos;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, restricciones) {
        final amplia = restricciones.maxWidth >= 600;
        final titulo = nombre.isEmpty
            ? '¿Qué arreglamos hoy?'
            : '¿Qué arreglamos hoy, $nombre?';
        return Material(
          color: Colores.primario,
          borderRadius: BorderRadius.circular(Radios.grande),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: amplia ? -70 : -60,
                child: _Circulo(
                  tamano: amplia ? 240 : 170,
                  color: Colores.cieloClaro,
                ),
              ),
              Positioned(
                right: amplia ? 110 : 14,
                top: amplia ? 110 : 104,
                child: _Circulo(
                  tamano: amplia ? 70 : 44,
                  color: Colores.primarioClaro,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(amplia ? 28 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: amplia ? 420 : 240),
                      child: Text(
                        titulo,
                        style: textos.headlineMedium?.copyWith(
                          fontSize: amplia ? 32 : 26,
                          color: Colores.sobreOscuro,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: Espacios.s + 2),
                    ConstrainedBox(
                      // En el teléfono deja libre el borde derecho, donde
                      // va el círculo verde.
                      constraints: BoxConstraints(
                        maxWidth: amplia ? double.infinity : 220,
                      ),
                      child: Text(
                        subtitulo,
                        style: textos.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colores.sobreOscuro.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    if (oficios.isNotEmpty || onTodos != null) ...[
                      const SizedBox(height: Espacios.m + 2),
                      Wrap(
                        spacing: Espacios.s,
                        runSpacing: Espacios.s,
                        children: [
                          for (final o in oficios)
                            _ChipPortada(
                              texto: o.nombre,
                              onTap: () => onOficio(o),
                            ),
                          if (onTodos != null)
                            _ChipPortada(
                              texto: 'Todos los oficios',
                              resaltado: true,
                              onTap: onTodos!,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Circulo extends StatelessWidget {
  const _Circulo({required this.tamano, required this.color});

  final double tamano;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: IgnorePointer(
      child: Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

class _ChipPortada extends StatelessWidget {
  const _ChipPortada({
    required this.texto,
    required this.onTap,
    this.resaltado = false,
  });

  final String texto;
  final VoidCallback onTap;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: resaltado
          ? Colores.tarjeta
          : Colores.sobreOscuro.withValues(alpha: 0.16),
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Center(
            widthFactor: 1,
            child: Text(
              texto,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 13,
                color: resaltado ? Colores.primario : Colores.sobreOscuro,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.texto, this.cielo = false, this.icono});

  final String texto;
  final bool cielo;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final color = cielo ? Colores.cieloOscuro : Colores.primario;
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: cielo ? Colores.cieloSuave : Colores.primarioSuave,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonChico extends StatelessWidget {
  const _BotonChico({
    required this.texto,
    required this.onPressed,
    this.conBorde = false,
  });

  final String texto;
  final VoidCallback? onPressed;
  final bool conBorde;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colores.primario,
        backgroundColor: conBorde ? Colores.tarjeta : Colores.primarioSuave,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.pequeno),
          side: conBorde
              ? const BorderSide(color: Colores.primarioVivo, width: 1.5)
              : BorderSide.none,
        ),
        textStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      child: Text(texto, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

/// Pasos del progreso de una solicitud y lo que se muestra en cada uno.
extension ProgresoSolicitud on EstadoSolicitud {
  static const pasos = [
    'Publicada',
    'Con cotizaciones',
    'Agendada',
    'Completada',
  ];

  int get paso => switch (this) {
    EstadoSolicitud.abierta => 1,
    EstadoSolicitud.cotizada => 2,
    EstadoSolicitud.aceptada => 3,
    EstadoSolicitud.porConfirmar ||
    EstadoSolicitud.completada ||
    EstadoSolicitud.cancelada => 4,
  };

  String get accionInicio => switch (this) {
    EstadoSolicitud.abierta => 'Ver solicitud',
    EstadoSolicitud.cotizada => 'Comparar cotizaciones',
    EstadoSolicitud.aceptada => 'Ver visita',
    EstadoSolicitud.porConfirmar || EstadoSolicitud.completada => 'Calificar',
    EstadoSolicitud.cancelada => 'Ver solicitud',
  };
}

class TarjetaSolicitudActiva extends StatelessWidget {
  const TarjetaSolicitudActiva({
    super.key,
    required this.solicitud,
    required this.ofertas,
    required this.onTap,
  });

  final Solicitud solicitud;
  final int ofertas;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final s = solicitud;
    final paso = s.estado.paso;
    final nombrePaso = ProgresoSolicitud.pasos[paso - 1];
    final chip = s.estado == EstadoSolicitud.cotizada
        ? 'Con cotizaciones · $ofertas'
        : s.estado == EstadoSolicitud.porConfirmar
        ? 'Por confirmar'
        : nombrePaso;
    final direccion = s.direccionReferencia?.trim();
    final detalle = [
      'Publicada ${Formatos.haceTiempo(s.creadoEn)}',
      switch (ofertas) {
        0 => 'Sin cotizaciones aún',
        1 => '1 técnico cotizó',
        final n => '$n técnicos cotizaron',
      },
      if (direccion != null && direccion.isNotEmpty) direccion,
    ].join(' · ');

    final icono = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colores.cieloSuave,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(iconoOficio(s.oficioNombre), color: Colores.cieloOscuro),
    );
    final progreso = Semantics(
      label: 'Paso $paso de 4: $nombrePaso',
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Row(
          children: [
            for (var i = 1; i <= 4; i++) ...[
              if (i > 1) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= paso ? Colores.primarioVivo : Colores.linea,
                    borderRadius: BorderRadius.circular(Radios.pildora),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${s.oficioNombre} · ${s.descripcion}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textos.titleSmall?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Espacios.xs),
        Text(
          detalle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textos.bodySmall?.copyWith(
            fontSize: 13,
            color: Colores.tintaSuave,
          ),
        ),
        const SizedBox(height: Espacios.s),
        progreso,
      ],
    );
    Widget acciones(WrapAlignment alineacion) => Wrap(
      alignment: alineacion,
      spacing: Espacios.s + 2,
      runSpacing: Espacios.s,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _Chip(texto: chip, cielo: true),
        _BotonChico(texto: s.estado.accionInicio, onPressed: onTap),
      ],
    );

    return TarjetaInicio(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: LayoutBuilder(
        builder: (context, r) {
          if (r.maxWidth >= 620) {
            return Row(
              children: [
                icono,
                const SizedBox(width: Espacios.l),
                Expanded(flex: 3, child: info),
                const SizedBox(width: Espacios.l),
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: acciones(WrapAlignment.end),
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icono,
                  const SizedBox(width: Espacios.m),
                  Expanded(child: info),
                ],
              ),
              const SizedBox(height: Espacios.m),
              acciones(WrapAlignment.start),
            ],
          );
        },
      ),
    );
  }
}

class SinSolicitudActiva extends StatelessWidget {
  const SinSolicitudActiva({super.key, required this.onPublicar});

  final VoidCallback onPublicar;

  @override
  Widget build(BuildContext context) {
    return TarjetaInicio(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Espacios.m,
        runSpacing: Espacios.m,
        children: [
          Text(
            'No tienes solicitudes activas',
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          FilledButton.icon(
            onPressed: onPublicar,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radios.pequeno),
              ),
              textStyle: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Publicar solicitud'),
          ),
        ],
      ),
    );
  }
}

class TarjetaTecnicoCerca extends StatelessWidget {
  const TarjetaTecnicoCerca({
    super.key,
    required this.tecnico,
    required this.cielo,
    required this.onTap,
  });

  final TecnicoCercano tecnico;

  /// Alterna el fondo del avatar entre verde y cielo.
  final bool cielo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = tecnico;
    final oficio = t.oficios.isEmpty ? 'Técnico' : t.oficios.first;
    final calificacion = t.calificacion.toStringAsFixed(1).replaceAll('.', ',');

    return TarjetaInicio(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              FotoPerfilCaja(
                tamano: 44,
                circular: true,
                rutaFoto: t.fotoRuta,
                iniciales: t.iniciales,
                colorFondo: cielo ? Colores.cieloSuave : Colores.primarioSuave,
                estiloTexto: textos.titleSmall?.copyWith(
                  color: cielo ? Colores.cieloOscuro : Colores.primario,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: Espacios.s + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.nombreCorto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleSmall?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$oficio · ${Formatos.kilometros(t.metros.toDouble())}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.s + 2),
          Wrap(
            spacing: Espacios.s,
            runSpacing: Espacios.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Semantics(
                label: 'Calificación $calificacion de 5',
                excludeSemantics: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colores.estrella,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      calificacion,
                      style: textos.labelLarge?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const _Chip(texto: 'Verificado', icono: Icons.check_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class ResumenChats extends StatelessWidget {
  const ResumenChats({
    super.key,
    required this.contenido,
    required this.onVerTodos,
  });

  /// Las filas, o el estado de carga, error o vacío.
  final Widget contenido;
  final VoidCallback onVerTodos;

  @override
  Widget build(BuildContext context) {
    return TarjetaInicio(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TituloBloque(
            titulo: 'Chats',
            tamano: 16,
            enlace: 'Ver todos',
            onEnlace: onVerTodos,
          ),
          contenido,
        ],
      ),
    );
  }
}

class FilaChat extends StatelessWidget {
  const FilaChat({
    super.key,
    required this.chat,
    required this.sinLeer,
    required this.cielo,
    required this.onTap,
  });

  final ResumenChat chat;
  final int sinLeer;
  final bool cielo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final nuevos = sinLeer > 0;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Espacios.s),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colores.linea)),
        ),
        child: Row(
          children: [
            FotoPerfilCaja(
              tamano: 40,
              circular: true,
              iniciales: _iniciales(chat.otroNombre),
              colorFondo: cielo ? Colores.cieloSuave : Colores.primarioSuave,
              estiloTexto: textos.labelLarge?.copyWith(
                fontSize: 13,
                color: cielo ? Colores.cieloOscuro : Colores.primario,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: Espacios.s + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.otroNombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: nuevos ? FontWeight.w800 : FontWeight.w700,
                    ),
                  ),
                  Text(
                    chat.ultimoMensaje ?? 'Sin mensajes todavía',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodySmall?.copyWith(
                      fontSize: 12,
                      color: nuevos ? Colores.tinta : Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
            ),
            if (nuevos) ...[
              const SizedBox(width: Espacios.s),
              InsigniaConteo(cantidad: sinLeer),
            ],
          ],
        ),
      ),
    );
  }
}

/// Número de no leídos en una píldora verde.
class InsigniaConteo extends StatelessWidget {
  const InsigniaConteo({super.key, required this.cantidad});

  final int cantidad;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$cantidad sin leer',
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minWidth: 18),
        height: 18,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colores.primario,
          borderRadius: BorderRadius.circular(Radios.pildora),
        ),
        child: Text(
          cantidad > 99 ? '99+' : '$cantidad',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 11,
            color: Colores.sobreOscuro,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class TarjetaProximaVisita extends StatelessWidget {
  const TarjetaProximaVisita({super.key, required this.contenido});

  /// [DatosProximaVisita], o el estado de carga, error o vacío.
  final Widget contenido;

  @override
  Widget build(BuildContext context) {
    return TarjetaInicio(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tu próxima visita',
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: Espacios.s + 2),
          contenido,
        ],
      ),
    );
  }
}

class DatosProximaVisita extends StatelessWidget {
  const DatosProximaVisita({
    super.key,
    required this.inicio,
    required this.fin,
    required this.tecnico,
    required this.titulo,
    required this.precio,
    required this.onReagendar,
    required this.onEscribir,
    this.textoSecundario = 'Reagendar',
  });

  /// Texto del botón con borde (el técnico ve "Ver detalle").
  final String textoSecundario;
  final DateTime inicio;
  final DateTime fin;
  final String tecnico;
  final String titulo;
  final double precio;
  final VoidCallback onReagendar;
  final VoidCallback onEscribir;

  static const _dias = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 60,
              decoration: BoxDecoration(
                color: Colores.primario,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dias[inicio.weekday - 1],
                    style: textos.labelSmall?.copyWith(
                      fontSize: 11,
                      color: Colores.sobreOscuro.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${inicio.day}',
                    style: textos.headlineSmall?.copyWith(
                      fontSize: 22,
                      color: Colores.sobreOscuro,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Formatos.hora(inicio)} a ${Formatos.hora(fin)} · $tecnico',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textos.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$titulo · ${Formatos.precio(precio)} la visita',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodySmall?.copyWith(
                      fontSize: 12,
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Espacios.m),
        Row(
          children: [
            Expanded(
              child: _BotonChico(
                texto: textoSecundario,
                conBorde: true,
                onPressed: onReagendar,
              ),
            ),
            const SizedBox(width: Espacios.s),
            Expanded(
              child: _BotonChico(texto: 'Escribir', onPressed: onEscribir),
            ),
          ],
        ),
      ],
    );
  }
}

/// Texto gris para los estados vacíos dentro de una tarjeta.
class TextoVacio extends StatelessWidget {
  const TextoVacio(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Espacios.s),
    child: Text(
      texto,
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(fontSize: 13, color: Colores.tintaSuave),
    ),
  );
}

/// Tres razones para confiar: verificación, garantía y precio. En fila
/// desde 700 px; en el teléfono, una debajo de otra. Cada una abre una
/// ventana con más información.
class TarjetasConfianza extends StatelessWidget {
  const TarjetasConfianza({
    super.key,
    required this.onVerificacion,
    required this.onGarantia,
    required this.onPago,
  });

  final VoidCallback onVerificacion;
  final VoidCallback onGarantia;
  final VoidCallback onPago;

  @override
  Widget build(BuildContext context) {
    final tarjetas = [
      TarjetaConfianza(
        icono: Icons.verified_user_rounded,
        fondo: Colores.primarioSuave,
        color: Colores.primarioVivo,
        titulo: 'Técnicos 100 % verificados',
        texto: 'Cédula y selfie revisadas por nuestro equipo.',
        onTap: onVerificacion,
      ),
      TarjetaConfianza(
        icono: Icons.shield_outlined,
        insignia: Icons.schedule_rounded,
        fondo: Colores.cieloSuave,
        color: Colores.cieloOscuro,
        titulo: 'Garantía de 30 días',
        texto: 'Si algo falla, repórtalo desde tu ticket.',
        onTap: onGarantia,
      ),
      TarjetaConfianza(
        icono: Icons.payments_outlined,
        fondo: Colores.avisoSuave,
        color: Colores.aviso,
        titulo: 'Pagas solo la visita',
        texto: 'Precio acordado antes de agendar, sin comisiones.',
        onTap: onPago,
      ),
    ];
    return FilaTarjetasInicio(tarjetas: tarjetas);
  }
}

/// Tarjetas chicas en fila desde 640 px de ancho, todas del mismo alto; más
/// angosto, una debajo de otra.
class FilaTarjetasInicio extends StatelessWidget {
  const FilaTarjetasInicio({super.key, required this.tarjetas});

  final List<Widget> tarjetas;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, r) {
        if (r.maxWidth < 640) {
          return Column(
            children: [
              for (var i = 0; i < tarjetas.length; i++) ...[
                if (i > 0) const SizedBox(height: Espacios.m),
                tarjetas[i],
              ],
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < tarjetas.length; i++) ...[
                if (i > 0) const SizedBox(width: Espacios.m),
                Expanded(child: tarjetas[i]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class TarjetaConfianza extends StatelessWidget {
  const TarjetaConfianza({
    super.key,
    required this.icono,
    required this.fondo,
    required this.color,
    required this.titulo,
    required this.texto,
    this.insignia,
    this.onTap,
  });

  final IconData icono;
  final IconData? insignia;
  final Color fondo;
  final Color color;
  final String titulo;
  final String texto;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final insignia = this.insignia;
    return Semantics(
      button: onTap != null,
      child: TarjetaInicio(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 76 - 28),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(icono, color: color, size: 22),
                    if (insignia != null)
                      Positioned(
                        right: 7,
                        bottom: 7,
                        child: Icon(insignia, color: color, size: 11),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: textos.titleSmall?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      texto,
                      style: textos.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
