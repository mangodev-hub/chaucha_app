import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../domain/entities/solicitud.dart';

String _dos(int n) => n.toString().padLeft(2, '0');

String _fechaHora(DateTime f) =>
    '${_dos(f.day)}/${_dos(f.month)}/${f.year}, ${Formatos.hora(f)}';

/// Píldora sobre fondo suave con texto oscuro del mismo tono.
class _Pildora extends StatelessWidget {
  const _Pildora(
    this.texto, {
    required this.fondo,
    required this.color,
    this.tachada = false,
  });

  final String texto;
  final Color fondo;
  final Color color;
  final bool tachada;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: fondo,
      borderRadius: BorderRadius.circular(Radios.pildora),
    ),
    child: Text(
      texto,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
        decoration: tachada ? TextDecoration.lineThrough : null,
      ),
    ),
  );
}

// ------------------------------------------------------------------ ruta

class RutaSolicitud extends StatelessWidget {
  const RutaSolicitud({
    super.key,
    required this.solicitud,
    required this.onLista,
  });

  final Solicitud solicitud;
  final VoidCallback onLista;

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.bodySmall
        ?.copyWith(fontSize: 12);
    final f = solicitud.creadoEn.toLocal();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: onLista,
          borderRadius: BorderRadius.circular(Radios.pequeno),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '‹ Mis solicitudes',
              style: estilo?.copyWith(color: Colores.tintaSuave),
            ),
          ),
        ),
        Text(' / ', style: estilo?.copyWith(color: Colores.tintaSuave)),
        Text(
          '${solicitud.oficioNombre} · ${_dos(f.day)}/${_dos(f.month)}',
          style: estilo?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------- cabecera

extension EstadoSolicitudCliente on EstadoSolicitud {
  /// Píldora del estado ("Con ofertas · 2", "En curso"...).
  (String, Color, Color) pildora(int ofertas) => switch (this) {
    EstadoSolicitud.abierta || EstadoSolicitud.cotizada =>
      ofertas > 0
          ? ('Con ofertas · $ofertas', Colores.cieloSuave, Colores.cieloOscuro)
          : ('Esperando ofertas', Colores.cieloSuave, Colores.cieloOscuro),
    EstadoSolicitud.aceptada => (
      'En curso',
      Colores.primarioSuave,
      Colores.primario,
    ),
    EstadoSolicitud.porConfirmar => (
      'Por confirmar',
      Colores.avisoSuave,
      Colores.avisoOscuro,
    ),
    EstadoSolicitud.completada => (
      'Completada',
      Colores.primarioSuave,
      Colores.primario,
    ),
    EstadoSolicitud.cancelada => (
      'Cancelada',
      Colores.superficie,
      Colores.tintaSuave,
    ),
  };

  /// Paso actual (0 a 3) de la barra de progreso.
  int get pasoActual => switch (this) {
    EstadoSolicitud.abierta || EstadoSolicitud.cotizada => 0,
    EstadoSolicitud.aceptada => 1,
    EstadoSolicitud.porConfirmar => 2,
    EstadoSolicitud.completada || EstadoSolicitud.cancelada => 3,
  };
}

class CabeceraSolicitud extends StatelessWidget {
  const CabeceraSolicitud({
    super.key,
    required this.solicitud,
    required this.ofertas,
    this.onEditar,
    this.onCancelar,
    this.onEliminar,
    this.accion,
  });

  final Solicitud solicitud;
  final int ofertas;

  /// Solo mientras la solicitud recibe ofertas.
  final VoidCallback? onEditar;
  final VoidCallback? onCancelar;
  final VoidCallback? onEliminar;

  /// Acción principal del estado (confirmar, calificar), en escritorio.
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final s = solicitud;
    final (texto, fondo, color) = s.estado.pildora(ofertas);
    final direccion = s.direccionReferencia?.trim();
    final gris = textos.bodySmall?.copyWith(
      fontSize: 13,
      color: Colores.tintaSuave,
    );

    final titulo = Wrap(
      spacing: Espacios.m,
      runSpacing: Espacios.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          s.descripcion,
          style: textos.headlineSmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        _Pildora(texto, fondo: fondo, color: color),
      ],
    );
    final datos = Wrap(
      spacing: Espacios.m,
      runSpacing: Espacios.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          s.oficioNombre,
          style: gris?.copyWith(
            color: Colores.primario,
            fontWeight: FontWeight.w700,
          ),
        ),
        _ConIcono(
          Icons.schedule_rounded,
          'Publicada el ${_fechaHora(s.creadoEn.toLocal())}',
          estilo: gris,
        ),
        if (direccion != null && direccion.isNotEmpty)
          _ConIcono(Icons.location_on_outlined, direccion, estilo: gris),
      ],
    );
    final acciones = onEditar == null && onCancelar == null
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEditar != null)
                OutlinedButton.icon(
                  onPressed: onEditar,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radios.pequeno),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                ),
              const SizedBox(width: Espacios.s),
              _MenuMas(onCancelar: onCancelar, onEliminar: onEliminar),
            ],
          );

    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, r) {
              final icono = Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colores.cieloSuave,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  iconoOficio(s.oficioNombre),
                  color: Colores.cieloOscuro,
                ),
              );
              final cuerpo = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titulo,
                  const SizedBox(height: Espacios.s),
                  datos,
                ],
              );
              if (r.maxWidth >= 620) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    icono,
                    const SizedBox(width: Espacios.l),
                    Expanded(child: cuerpo),
                    if (acciones != null) ...[
                      const SizedBox(width: Espacios.l),
                      acciones,
                    ],
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [icono, const Spacer(), ?acciones]),
                  const SizedBox(height: Espacios.m),
                  cuerpo,
                ],
              );
            },
          ),
          const Divider(height: Espacios.xxl, color: Colores.linea),
          if (s.estado == EstadoSolicitud.cancelada)
            Container(
              padding: const EdgeInsets.all(Espacios.m),
              decoration: BoxDecoration(
                color: Colores.superficie,
                borderRadius: BorderRadius.circular(Radios.pequeno),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Colores.tintaSuave),
                  const SizedBox(width: Espacios.s),
                  Expanded(
                    child: Text(
                      'Solicitud cancelada',
                      style: textos.bodyMedium?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            PasosSolicitud(estado: s.estado),
          if (accion != null) ...[
            const SizedBox(height: Espacios.l),
            Align(alignment: Alignment.centerLeft, child: accion),
          ],
        ],
      ),
    );
  }
}

class _ConIcono extends StatelessWidget {
  const _ConIcono(this.icono, this.texto, {this.estilo});

  final IconData icono;
  final String texto;
  final TextStyle? estilo;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icono, size: 15, color: Colores.tintaSuave),
      const SizedBox(width: 4),
      Flexible(child: Text(texto, style: estilo)),
    ],
  );
}

enum _Opcion { cancelar, eliminar }

class _MenuMas extends StatelessWidget {
  const _MenuMas({required this.onCancelar, required this.onEliminar});

  final VoidCallback? onCancelar;
  final VoidCallback? onEliminar;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 40,
      child: PopupMenuButton<_Opcion>(
        tooltip: 'Más opciones',
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.more_vert_rounded),
        style: IconButton.styleFrom(
          side: const BorderSide(color: Colores.linea),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radios.pequeno),
          ),
        ),
        onSelected: (o) => switch (o) {
          _Opcion.cancelar => onCancelar?.call(),
          _Opcion.eliminar => onEliminar?.call(),
        },
        itemBuilder: (context) => [
          if (onCancelar != null)
            const PopupMenuItem(
              value: _Opcion.cancelar,
              child: Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colores.error),
                  SizedBox(width: Espacios.m),
                  Text(
                    'Cancelar solicitud',
                    style: TextStyle(color: Colores.error),
                  ),
                ],
              ),
            ),
          if (onEliminar != null)
            const PopupMenuItem(
              value: _Opcion.eliminar,
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colores.error),
                  SizedBox(width: Espacios.m),
                  Text(
                    'Eliminar solicitud',
                    style: TextStyle(color: Colores.error),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Publicada → En curso → Por confirmar → Completada.
class PasosSolicitud extends StatelessWidget {
  const PasosSolicitud({super.key, required this.estado});

  final EstadoSolicitud estado;

  static const _pasos = [
    ('Publicada', 'Recibiendo ofertas'),
    ('En curso', 'Al acordar con un técnico'),
    ('Por confirmar', 'Revisa que quedó listo'),
    ('Completada', 'Califica al técnico'),
  ];

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final actual = estado.pasoActual;
    final todoListo = estado == EstadoSolicitud.completada;
    // Angosto: las 4 barras y, debajo, solo el paso actual.
    if (MediaQuery.sizeOf(context).width < 560) {
      return Semantics(
        label: 'Paso ${actual + 1} de 4: ${_pasos[actual].$1}',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (var i = 0; i < _pasos.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= actual
                            ? Colores.primarioVivo
                            : Colores.linea,
                        borderRadius: BorderRadius.circular(Radios.pildora),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: Espacios.s),
            Text(
              'Paso ${actual + 1} de 4 · ${_pasos[actual].$1}',
              style: textos.labelMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              _pasos[actual].$2,
              style: textos.bodySmall?.copyWith(
                fontSize: 11,
                color: Colores.tintaSuave,
              ),
            ),
          ],
        ),
      );
    }
    return Semantics(
      label: 'Paso ${actual + 1} de 4: ${_pasos[actual].$1}',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _pasos.length; i++) ...[
            if (i > 0) const SizedBox(width: Espacios.s),
            Expanded(
              child: _Paso(
                numero: i + 1,
                titulo: _pasos[i].$1,
                ayuda: _pasos[i].$2,
                hecho: i < actual || todoListo,
                actual: i == actual && !todoListo,
                textos: textos,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso({
    required this.numero,
    required this.titulo,
    required this.ayuda,
    required this.hecho,
    required this.actual,
    required this.textos,
  });

  final int numero;
  final String titulo;
  final String ayuda;
  final bool hecho;
  final bool actual;
  final TextTheme textos;

  @override
  Widget build(BuildContext context) {
    final verde = hecho || actual;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: verde ? Colores.primarioVivo : Colores.linea,
            borderRadius: BorderRadius.circular(Radios.pildora),
          ),
        ),
        const SizedBox(height: Espacios.s),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: hecho ? Colores.primarioVivo : Colores.tarjeta,
                shape: BoxShape.circle,
                border: Border.all(
                  color: verde ? Colores.primarioVivo : Colores.linea,
                  width: 1.5,
                ),
              ),
              child: hecho
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colores.sobreOscuro,
                    )
                  : Text(
                      '$numero',
                      style: textos.labelSmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: actual
                            ? Colores.primarioVivo
                            : Colores.tintaSuave,
                      ),
                    ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: textos.labelMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: verde ? Colores.tinta : Colores.tintaSuave,
                    ),
                  ),
                  Text(
                    ayuda,
                    style: textos.bodySmall?.copyWith(
                      fontSize: 11,
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --------------------------------------------------------------- ofertas

enum OrdenOfertas {
  menorPrecio('Menor precio'),
  mejorCalificacion('Mejor calificación'),
  masCercano('Más cercano'),
  masReciente('Más reciente');

  const OrdenOfertas(this.etiqueta);

  final String etiqueta;

  List<Cotizacion> ordenar(List<Cotizacion> ofertas, LatLng? punto) {
    double distancia(Cotizacion c) {
      final u = c.tecnicoUbicacion;
      if (u == null || punto == null) return double.infinity;
      return GeoMapper.metrosEntre(punto, u);
    }

    return [...ofertas]..sort(
      (a, b) => switch (this) {
        OrdenOfertas.menorPrecio => a.precioBase.compareTo(b.precioBase),
        OrdenOfertas.mejorCalificacion => b.tecnicoCalificacion.compareTo(
          a.tecnicoCalificacion,
        ),
        OrdenOfertas.masCercano => distancia(a).compareTo(distancia(b)),
        OrdenOfertas.masReciente => b.creadoEn.compareTo(a.creadoEn),
      },
    );
  }
}

/// Lista de ofertas con su encabezado, el orden y los estados vacío y
/// con técnico elegido.
class OfertasRecibidas extends StatefulWidget {
  const OfertasRecibidas({
    super.key,
    required this.ofertas,
    required this.puntoSolicitud,
    required this.recibeOfertas,
    required this.onChat,
    required this.onVerPerfil,
    required this.activas,
    this.aceptada,
    this.accionesVisita,
  });

  final List<Cotizacion> ofertas;
  final LatLng? puntoSolicitud;

  /// En false (cancelada, sin técnico), las ofertas se ven sin botón.
  final bool recibeOfertas;
  final Cotizacion? aceptada;
  final ValueChanged<Cotizacion> onChat;
  final ValueChanged<Cotizacion> onVerPerfil;
  final bool activas;

  /// Reagendar y cancelar la visita de la oferta aceptada.
  final Widget? accionesVisita;

  @override
  State<OfertasRecibidas> createState() => _OfertasRecibidasState();
}

class _OfertasRecibidasState extends State<OfertasRecibidas> {
  OrdenOfertas _orden = OrdenOfertas.menorPrecio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final aceptada = widget.aceptada;
    final otras = _orden.ordenar([
      for (final c in widget.ofertas)
        if (c.id != aceptada?.id) c,
    ], widget.puntoSolicitud);
    String? masBarata;
    if (aceptada == null && widget.ofertas.length > 1) {
      masBarata = OrdenOfertas.menorPrecio
          .ordenar(widget.ofertas, null)
          .first
          .id;
    }

    Widget tarjeta(
      Cotizacion c, {
      bool atenuada = false,
      bool conBoton = true,
    }) {
      final esAceptada = c.id == aceptada?.id;
      return _Aparece(
        key: ValueKey(c.id),
        child: Opacity(
          opacity: atenuada ? 0.6 : 1,
          child: TarjetaOferta(
            cotizacion: c,
            aceptada: esAceptada,
            menorPrecio: c.id == masBarata,
            onVerPerfil: () => widget.onVerPerfil(c),
            onChat: conBoton && widget.activas ? () => widget.onChat(c) : null,
            mostrarBoton: conBoton,
            accionesVisita: esAceptada ? widget.accionesVisita : null,
          ),
        ),
      );
    }

    final cabecera = Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: Espacios.l,
      runSpacing: Espacios.s,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ofertas recibidas',
              style: textos.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Compara precio y propuesta. Escríbele al que te guste para '
              'acordar.',
              style: textos.bodySmall?.copyWith(
                fontSize: 13,
                color: Colores.tintaSuave,
              ),
            ),
          ],
        ),
        if (otras.length > 1)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Ordenar por',
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
              const SizedBox(width: Espacios.s),
              DropdownButton<OrdenOfertas>(
                value: _orden,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(Radios.pequeno),
                style: textos.labelLarge?.copyWith(
                  color: Colores.tinta,
                  fontWeight: FontWeight.w700,
                ),
                items: [
                  for (final o in OrdenOfertas.values)
                    DropdownMenuItem(value: o, child: Text(o.etiqueta)),
                ],
                onChanged: (o) {
                  if (o != null) setState(() => _orden = o);
                },
              ),
            ],
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        cabecera,
        const SizedBox(height: Espacios.m),
        if (widget.ofertas.isEmpty)
          const _SinOfertas()
        else if (aceptada != null) ...[
          tarjeta(aceptada),
          if (otras.isNotEmpty) ...[
            const SizedBox(height: Espacios.l),
            Text(
              'Otras ofertas',
              style: textos.titleSmall?.copyWith(color: Colores.tintaSuave),
            ),
            const SizedBox(height: Espacios.s),
            for (final c in otras) ...[
              tarjeta(c, atenuada: true, conBoton: false),
              const SizedBox(height: Espacios.m),
            ],
          ],
        ] else
          for (final c in otras) ...[
            tarjeta(c, conBoton: widget.recibeOfertas),
            const SizedBox(height: Espacios.m),
          ],
        const SizedBox(height: Espacios.s),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: Colores.tintaSuave,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Pagas solo la visita que acuerdes. Las nuevas ofertas '
                'aparecen aquí y te avisamos.',
                style: textos.bodySmall?.copyWith(
                  fontSize: 12,
                  color: Colores.tintaSuave,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Entrada suave (aparece y sube un poco) la primera vez que se dibuja.
class _Aparece extends StatelessWidget {
  const _Aparece({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Movimiento.de(context, Movimiento.lento),
      curve: Movimiento.entrada,
      builder: (context, t, hijo) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - t)),
          child: hijo,
        ),
      ),
      child: child,
    );
  }
}

class _SinOfertas extends StatelessWidget {
  const _SinOfertas();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _BordePunteado(),
      child: Padding(
        padding: const EdgeInsets.all(Espacios.xl),
        child: Row(
          children: [
            const Icon(Icons.schedule_rounded, color: Colores.tintaSuave),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Text(
                'Aún no hay ofertas. Te avisaremos cuando un técnico cotice.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colores.tintaSuave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BordePunteado extends CustomPainter {
  const _BordePunteado();

  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()
      ..color = Colores.linea
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final camino = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(Radios.tarjeta),
        ),
      );
    for (final metrica in camino.computeMetrics()) {
      var d = 0.0;
      while (d < metrica.length) {
        canvas.drawPath(metrica.extractPath(d, d + 6), pincel);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(_BordePunteado anterior) => false;
}

/// Una oferta: técnico y propuesta a la izquierda; precio, estado y botón a
/// la derecha (debajo en pantallas angostas).
class TarjetaOferta extends StatefulWidget {
  const TarjetaOferta({
    super.key,
    required this.cotizacion,
    required this.onVerPerfil,
    this.onChat,
    this.aceptada = false,
    this.menorPrecio = false,
    this.mostrarBoton = true,
    this.accionesVisita,
  });

  final Cotizacion cotizacion;
  final VoidCallback onVerPerfil;
  final VoidCallback? onChat;
  final bool aceptada;
  final bool menorPrecio;
  final bool mostrarBoton;
  final Widget? accionesVisita;

  @override
  State<TarjetaOferta> createState() => _TarjetaOfertaState();
}

class _TarjetaOfertaState extends State<TarjetaOferta> {
  bool _completa = false;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final c = widget.cotizacion;
    final nombre = c.tecnicoNombre.trim();
    final propuesta = c.solucion;
    final borde = BorderRadius.circular(Radios.tarjeta);

    final izquierda = Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FotoPerfilCaja(
                tamano: 44,
                circular: true,
                rutaFoto: c.tecnicoFotoRuta,
                iniciales: nombre.isEmpty ? '?' : nombre[0].toUpperCase(),
                colorFondo: Colores.cieloSuave,
                estiloTexto: textos.titleMedium?.copyWith(
                  color: Colores.cieloOscuro,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.tecnicoNombre,
                      style: textos.titleSmall?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (c.tecnicoTotalResenas == 0)
                          Text(
                            'Técnico nuevo',
                            style: textos.bodySmall?.copyWith(
                              color: Colores.tintaSuave,
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colores.estrella,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            c.tecnicoCalificacion
                                .toStringAsFixed(1)
                                .replaceAll('.', ','),
                            style: textos.labelMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                        InkWell(
                          onTap: widget.onVerPerfil,
                          borderRadius: BorderRadius.circular(Radios.pequeno),
                          child: Text(
                            ' · Ver perfil',
                            style: textos.bodySmall?.copyWith(
                              color: Colores.primario,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.menorPrecio)
                const _Pildora(
                  'Menor precio',
                  fondo: Colores.cieloSuave,
                  color: Colores.cieloOscuro,
                ),
            ],
          ),
          if (propuesta != null) ...[
            const SizedBox(height: Espacios.m),
            Text(
              'CÓMO LO RESOLVERÍA',
              style: textos.labelSmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: Colores.tintaSuave,
              ),
            ),
            const SizedBox(height: Espacios.xs),
            Text(
              propuesta,
              style: textos.bodyMedium?.copyWith(fontSize: 14),
              maxLines: _completa ? null : 4,
              overflow: _completa ? null : TextOverflow.ellipsis,
            ),
            // Cuatro líneas son unos 200 caracteres en la tarjeta.
            if (propuesta.length > 200)
              TextButton(
                onPressed: () => setState(() => _completa = !_completa),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                ),
                child: Text(_completa ? 'Ver menos' : 'Ver más'),
              ),
          ],
        ],
      ),
    );

    final (estado, fondoEstado, colorEstado, tachado) = switch (c.estado) {
      EstadoCotizacion.aceptada => (
        'Aceptada',
        Colores.primarioSuave,
        Colores.primario,
        false,
      ),
      EstadoCotizacion.rechazada => (
        'Rechazada',
        Colores.superficie,
        Colores.tintaSuave,
        true,
      ),
      EstadoCotizacion.pendiente when c.tarifaPendiente => (
        'Ticket por confirmar',
        Colores.avisoSuave,
        Colores.avisoOscuro,
        false,
      ),
      EstadoCotizacion.pendiente => (
        'Pendiente',
        Colores.superficie,
        Colores.tintaSuave,
        false,
      ),
    };
    final visita = c.inicioVisita;
    final derecha = Container(
      padding: const EdgeInsets.all(18),
      color: Colores.fondoClaro,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Precio de la visita',
            style: textos.bodySmall?.copyWith(
              fontSize: 12,
              color: Colores.tintaSuave,
            ),
          ),
          Text(
            Formatos.precio(c.precioBase),
            style: textos.headlineMedium?.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colores.cieloOscuro,
            ),
          ),
          const SizedBox(height: Espacios.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: _Pildora(
              estado,
              fondo: fondoEstado,
              color: colorEstado,
              tachada: tachado,
            ),
          ),
          if (widget.aceptada && visita != null) ...[
            const SizedBox(height: Espacios.s),
            Text(
              'Visita: ${Formatos.fechaCorta(visita)} · ${Formatos.hora(visita)}',
              style: textos.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
          if (widget.mostrarBoton) ...[
            const SizedBox(height: Espacios.m),
            FilledButton.icon(
              onPressed: widget.onChat,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radios.pequeno),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: Text(
                widget.aceptada ? 'Ir al chat' : 'Escribir al técnico',
              ),
            ),
          ],
          if (widget.accionesVisita != null) ...[
            const SizedBox(height: Espacios.s),
            widget.accionesVisita!,
          ],
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: borde,
        boxShadow: Sombras.tarjeta,
        border: widget.aceptada
            ? Border.all(color: Colores.primarioClaro, width: 1.5)
            : null,
      ),
      child: ClipRRect(
        borderRadius: borde,
        child: LayoutBuilder(
          builder: (context, r) {
            if (r.maxWidth >= 560) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: izquierda),
                    SizedBox(width: 260, child: derecha),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [izquierda, derecha],
            );
          },
        ),
      ),
    );
  }
}

// ------------------------------------------------------- columna lateral

class DetallesProblema extends StatelessWidget {
  const DetallesProblema({
    super.key,
    required this.descripcion,
    required this.fotos,
    this.onAgregar,
    this.agregando = false,
    this.titulo = 'Detalles del problema',
    this.mostrarDescripcion = true,
  });

  final String descripcion;
  final List<String> fotos;
  final VoidCallback? onAgregar;
  final bool agregando;
  final String titulo;
  final bool mostrarDescripcion;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaInicio(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titulo,
            style: textos.titleSmall?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (mostrarDescripcion) ...[
            const SizedBox(height: Espacios.s),
            Text(descripcion, style: textos.bodyMedium?.copyWith(fontSize: 14)),
          ],
          const SizedBox(height: Espacios.m),
          if (fotos.isEmpty)
            Container(
              padding: const EdgeInsets.all(Espacios.m),
              decoration: BoxDecoration(
                color: Colores.fondoClaro,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image_outlined, color: Colores.tintaSuave),
                  const SizedBox(width: Espacios.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sin fotos',
                          style: textos.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Con fotos los técnicos cotizan más preciso.',
                          style: textos.bodySmall?.copyWith(
                            fontSize: 12,
                            color: Colores.tintaSuave,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onAgregar != null)
                    TextButton(
                      onPressed: agregando ? null : onAgregar,
                      style: TextButton.styleFrom(
                        backgroundColor: Colores.primarioSuave,
                        foregroundColor: Colores.primario,
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radios.pequeno),
                        ),
                      ),
                      child: agregando
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Agregar'),
                    ),
                ],
              ),
            )
          else
            Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.s,
              children: [for (final url in fotos) _Miniatura(url: url)],
            ),
        ],
      ),
    );
  }
}

class _Miniatura extends StatelessWidget {
  const _Miniatura({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final borde = BorderRadius.circular(10);
    final vacio = Container(
      width: 72,
      height: 72,
      color: Colores.superficie,
      child: const Icon(Icons.image_outlined, color: Colores.tintaSuave),
    );
    return Semantics(
      button: true,
      label: 'Ver foto',
      child: InkWell(
        borderRadius: borde,
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => Dialog(
            clipBehavior: Clip.antiAlias,
            child: InteractiveViewer(child: Image.network(url)),
          ),
        ),
        child: ClipRRect(
          borderRadius: borde,
          child: Image.network(
            url,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => vacio,
          ),
        ),
      ),
    );
  }
}

class UbicacionSolicitud extends StatelessWidget {
  const UbicacionSolicitud({
    super.key,
    required this.punto,
    this.direccion,
    this.ciudad,
  });

  final LatLng punto;
  final String? direccion;
  final String? ciudad;

  Future<void> _abrirMapa() => launchUrl(
    Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${punto.latitude},${punto.longitude}',
    }),
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final direccion = this.direccion?.trim();
    final ciudad = this.ciudad?.trim();
    return TarjetaInicio(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Radios.tarjeta),
            ),
            // Solo para ubicar: sin arrastrar ni hacer zoom.
            child: IgnorePointer(
              child: MapaUbicacion(
                punto: punto,
                altura: 160,
                colorMarcador: Colores.primarioVivo,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Espacios.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (direccion != null && direccion.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colores.primario,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          direccion,
                          style: textos.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (ciudad != null && ciudad.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      '$ciudad, Pichincha',
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ),
                const SizedBox(height: Espacios.xs),
                TextButton.icon(
                  onPressed: () => unawaited(_abrirMapa()),
                  style: TextButton.styleFrom(
                    foregroundColor: Colores.primario,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Abrir en el mapa'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
