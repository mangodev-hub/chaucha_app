// Detalle de una solicitud. La misma pantalla sirve al cliente y al técnico;
// lo que ve y puede hacer cada uno lo decide `DetalleSolicitud`.
//
// En móvil: una columna y la acción principal fija abajo. En escritorio: dos
// columnas (la solicitud a la izquierda; guía, acción y cotizaciones a la
// derecha).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/barra_accion.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/presentation/widgets/cotizacion_widgets.dart';
import '../../../perfil_puntos/presentation/widgets/resena_dialog.dart';
import '../../domain/entities/detalle_solicitud.dart';
import '../../domain/entities/foto_solicitud.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/detalle_provider.dart';
import '../widgets/detalle_widgets.dart';
import '../widgets/solicitud_widgets.dart';

/// Acción principal del detalle según el rol y el estado.
typedef _Accion = ({String texto, IconData icono, VoidCallback alPulsar});

enum _Opcion { cancelar }

class SolicitudDetalleView extends ConsumerStatefulWidget {
  const SolicitudDetalleView({super.key, required this.solicitudId});

  final String solicitudId;

  @override
  ConsumerState<SolicitudDetalleView> createState() =>
      _SolicitudDetalleViewState();
}

class _SolicitudDetalleViewState extends ConsumerState<SolicitudDetalleView> {
  AccionesSolicitudNotifier get _acciones =>
      ref.read(accionesSolicitudProvider(widget.solicitudId).notifier);

  /// Muestra [exito] si la acción salió bien, o el error si falló.
  /// Si se ignoró porque otra acción seguía en curso, no muestra nada.
  Future<void> _resultado(Future<bool> accion, String exito) async {
    final ok = await accion;
    if (!mounted) return;
    if (ok) {
      context.mostrarMensaje(exito, tipo: TipoMensaje.exito);
    } else {
      _mostrarErrorDeAccion();
    }
  }

  void _mostrarErrorDeAccion() {
    final estado = ref.read(accionesSolicitudProvider(widget.solicitudId));
    if (estado case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  Future<void> _aceptar(Cotizacion cotizacion) async {
    final ok = await context.confirmar(
      'Aceptar cotización',
      '¿Contratar a ${cotizacion.tecnicoNombre} por '
          '${Formatos.dinero(cotizacion.total)}? Las demás se rechazarán.',
      textoConfirmar: 'Contratar',
      icono: Icons.handshake_outlined,
    );
    if (ok) {
      await _resultado(_acciones.aceptar(cotizacion), 'Cotización aceptada.');
    }
  }

  Future<void> _confirmarTerminado() async {
    final ok = await context.confirmar(
      'Confirmar trabajo',
      '¿El técnico terminó el trabajo correctamente?',
      textoConfirmar: 'Sí, confirmar',
      icono: Icons.verified_outlined,
      textoCancelar: 'Todavía no',
    );
    if (ok) {
      await _resultado(_acciones.confirmarTerminado(), 'Trabajo completado.');
    }
  }

  Future<void> _cancelar() async {
    final ok = await context.confirmar(
      'Cancelar solicitud',
      'Los técnicos ya no podrán cotizarla.',
      textoConfirmar: 'Sí, cancelar',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.cancel_outlined,
    );
    if (ok) await _resultado(_acciones.cancelar(), 'Solicitud cancelada.');
  }

  Future<void> _cotizar() async {
    final datos = await mostrarFormularioCotizacion(context);
    if (datos == null) return;
    await _resultado(
      _acciones.enviarCotizacion(
        manoObra: datos.manoObra,
        materiales: datos.materiales,
        detalle: datos.detalle,
      ),
      'Cotización enviada.',
    );
  }

  Future<void> _marcarTerminada() async {
    final evidencias = await SelectorFotos.elegir(maximo: 3);
    if (!mounted) return;
    if (evidencias.isEmpty) {
      context.mostrarMensaje(
        'Sube al menos una foto del trabajo.',
        tipo: TipoMensaje.error,
      );
      return;
    }
    await _resultado(
      _acciones.marcarTerminada(evidencias),
      'Listo. El cliente debe confirmar el trabajo.',
    );
  }

  Future<void> _calificar(String destinatarioId, String nombre) async {
    final resena = await mostrarDialogoResena(context, nombre: nombre);
    if (resena == null) return;
    await _resultado(
      _acciones.calificar(
        destinatarioId: destinatarioId,
        estrellas: resena.estrellas,
        comentario: resena.comentario,
      ),
      '¡Gracias por tu calificación!',
    );
  }

  Future<void> _chat(String tecnicoId) async {
    final id = await _acciones.abrirChat(tecnicoId);
    if (!mounted) return;
    if (id == null) {
      _mostrarErrorDeAccion();
      return;
    }
    final esCliente = ref.read(usuarioActualProvider)?.id != tecnicoId;
    await context.push(AppRoutes.chat(id, esCliente: esCliente));
  }

  @override
  Widget build(BuildContext context) {
    final detalle = detalleSolicitudProvider(widget.solicitudId);
    final valor = ref.watch(detalle);
    final procesando = ref
        .watch(accionesSolicitudProvider(widget.solicitudId))
        .isLoading;
    final escritorio = ResponsiveLayout.isDesktop(context);

    // La barra y el menú solo existen cuando se ven los datos (no en error).
    final datos = valor.hasError ? null : valor.value;
    final accion = datos == null ? null : _accionPrincipal(datos);
    final boton = accion == null
        ? null
        : BotonCarga(
            texto: accion.texto,
            icono: accion.icono,
            cargando: procesando,
            onPressed: accion.alPulsar,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la solicitud'),
        actions: [
          if (datos != null && _puedeCancelar(datos))
            _MenuOpciones(habilitado: !procesando, onCancelar: _cancelar),
        ],
      ),
      bottomNavigationBar: boton == null || escritorio
          ? null
          : BarraAccion(child: boton),
      body: AsyncValueView<DetalleSolicitud>(
        value: valor,
        onRetry: () => ref.invalidate(detalle),
        onData: (context, datos) => RefreshIndicator(
          onRefresh: () => esperarSinError(ref.refresh(detalle.future)),
          child: escritorio
              ? _Escritorio(
                  izquierda: [
                    EncabezadoSolicitud(solicitud: datos.solicitud),
                    ..._evidencia(datos),
                    ..._fotosProblema(datos),
                    ..._ubicacion(datos, altura: 280),
                  ],
                  derecha: [
                    QueSigueCard(detalle: datos),
                    if (boton != null) ...[
                      const SizedBox(height: Espacios.l),
                      boton,
                    ],
                    ..._cotizaciones(datos, procesando: procesando),
                  ],
                )
              : _Movil(
                  children: [
                    EncabezadoSolicitud(solicitud: datos.solicitud),
                    const SizedBox(height: Espacios.l),
                    QueSigueCard(detalle: datos),
                    // Por confirmar, la evidencia es lo que hay que revisar.
                    if (datos.estado == EstadoSolicitud.porConfirmar)
                      ..._evidencia(datos),
                    ..._cotizaciones(datos, procesando: procesando),
                    if (datos.estado != EstadoSolicitud.porConfirmar)
                      ..._evidencia(datos),
                    ..._fotosProblema(datos),
                    ..._ubicacion(datos, altura: 220),
                  ],
                ),
        ),
      ),
    );
  }

  bool _puedeCancelar(DetalleSolicitud d) =>
      d.soyCliente && d.estado.recibeCotizaciones;

  _Accion? _accionPrincipal(DetalleSolicitud d) {
    final estado = d.estado;
    if (d.soyCliente) {
      final aceptada = d.cotizacionAceptada;
      if (estado == EstadoSolicitud.porConfirmar) {
        return (
          texto: 'Confirmar trabajo terminado',
          icono: Icons.verified_outlined,
          alPulsar: _confirmarTerminado,
        );
      }
      if (estado == EstadoSolicitud.completada && aceptada != null) {
        return (
          texto: 'Calificar al técnico',
          icono: Icons.star_outline,
          alPulsar: () =>
              _calificar(aceptada.tecnicoId, aceptada.tecnicoNombre),
        );
      }
      return null;
    }
    if (estado.recibeCotizaciones && d.miCotizacion == null) {
      return (
        texto: 'Enviar cotización',
        icono: Icons.request_quote_outlined,
        alPulsar: _cotizar,
      );
    }
    if (d.soyTecnicoAsignado && estado == EstadoSolicitud.aceptada) {
      return (
        texto: 'Marcar como terminado',
        icono: Icons.task_alt,
        alPulsar: _marcarTerminada,
      );
    }
    if (d.soyTecnicoAsignado && estado == EstadoSolicitud.completada) {
      return (
        texto: 'Calificar al cliente',
        icono: Icons.star_outline,
        alPulsar: () => _calificar(d.solicitud.clienteId, 'el cliente'),
      );
    }
    return null;
  }

  List<Widget> _evidencia(DetalleSolicitud d) {
    final evidencias = d.fotosDe(TipoArchivo.evidencia);
    if (evidencias.isEmpty) return const [];
    return [
      Seccion(
        titulo: 'Evidencia del trabajo',
        child: GaleriaFotos(urls: [for (final f in evidencias) f.url]),
      ),
    ];
  }

  List<Widget> _fotosProblema(DetalleSolicitud d) => [
    Seccion(
      titulo: 'Fotos del problema',
      child: GaleriaFotos(
        urls: [for (final f in d.fotosDe(TipoArchivo.problema)) f.url],
        mensajeVacio: d.soyCliente
            ? 'No adjuntaste fotos.'
            : 'El cliente no adjuntó fotos.',
      ),
    ),
  ];

  List<Widget> _ubicacion(DetalleSolicitud d, {required double altura}) {
    final ubicacion = d.solicitud.ubicacion;
    if (ubicacion == null) return const [];
    return [
      Seccion(
        titulo: 'Ubicación',
        child: MapaUbicacion(punto: ubicacion, altura: altura),
      ),
    ];
  }

  List<Widget> _cotizaciones(DetalleSolicitud d, {required bool procesando}) {
    if (!d.soyCliente) {
      final mia = d.miCotizacion;
      if (mia == null) return const [];
      return [
        Seccion(
          titulo: 'Tu cotización',
          child: CotizacionCard(
            cotizacion: mia,
            destacada: mia.estado == EstadoCotizacion.aceptada,
            accionesActivas: !procesando,
            onChat: () => _chat(mia.tecnicoId),
          ),
        ),
      ];
    }

    // Con un técnico contratado, se destaca su cotización y el resto se pliega.
    final aceptada = d.cotizacionAceptada;
    if (aceptada != null) {
      final otras = [
        for (final c in d.cotizaciones)
          if (c.id != aceptada.id) c,
      ];
      return [
        Seccion(
          titulo: 'Técnico asignado',
          child: CotizacionCard(
            cotizacion: aceptada,
            destacada: true,
            accionesActivas: !procesando,
            onChat: () => _chat(aceptada.tecnicoId),
          ),
        ),
        if (otras.isNotEmpty) _CotizacionesPlegadas(cotizaciones: otras),
      ];
    }

    final n = d.cotizaciones.length;
    final puedeAceptar = d.estado.recibeCotizaciones;
    return [
      Seccion(
        titulo: n == 0 ? 'Cotizaciones' : 'Cotizaciones ($n)',
        child: n == 0
            ? EstadoMensaje(
                icono: Icons.request_quote_outlined,
                compacto: true,
                mensaje: puedeAceptar
                    ? 'Aún no hay cotizaciones. Te avisaremos cuando lleguen.'
                    : 'Esta solicitud no recibió cotizaciones.',
              )
            : Column(
                children: [
                  for (final c in d.cotizaciones)
                    CotizacionCard(
                      cotizacion: c,
                      accionesActivas: !procesando,
                      onAceptar:
                          puedeAceptar && c.estado == EstadoCotizacion.pendiente
                          ? () => _aceptar(c)
                          : null,
                      onChat: () => _chat(c.tecnicoId),
                    ),
                ],
              ),
      ),
    ];
  }
}

class _Movil extends StatelessWidget {
  const _Movil({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Espacios.l),
      children: [
        AnchoMaximo(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              const SizedBox(height: Espacios.xl),
            ],
          ),
        ),
      ],
    );
  }
}

class _Escritorio extends StatelessWidget {
  const _Escritorio({required this.izquierda, required this.derecha});

  final List<Widget> izquierda;
  final List<Widget> derecha;

  @override
  Widget build(BuildContext context) {
    Widget columna(List<Widget> hijos) =>
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: hijos);
    return ListView(
      padding: const EdgeInsets.all(Espacios.xl),
      children: [
        AnchoMaximo(
          ancho: 1200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: columna(izquierda)),
              const SizedBox(width: Espacios.xl),
              Expanded(flex: 2, child: columna(derecha)),
            ],
          ),
        ),
        const SizedBox(height: Espacios.xxl),
      ],
    );
  }
}

/// Menú ⋮ del AppBar con las acciones secundarias (hoy: cancelar).
class _MenuOpciones extends StatelessWidget {
  const _MenuOpciones({required this.habilitado, required this.onCancelar});

  final bool habilitado;
  final VoidCallback onCancelar;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return PopupMenuButton<_Opcion>(
      tooltip: 'Más opciones',
      enabled: habilitado,
      onSelected: (opcion) => switch (opcion) {
        _Opcion.cancelar => onCancelar(),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _Opcion.cancelar,
          child: Row(
            children: [
              Icon(Icons.cancel_outlined, color: error),
              const SizedBox(width: Espacios.m),
              Text('Cancelar solicitud', style: TextStyle(color: error)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Cotizaciones que no se eligieron, plegadas debajo del técnico asignado.
class _CotizacionesPlegadas extends StatelessWidget {
  const _CotizacionesPlegadas({required this.cotizaciones});

  final List<Cotizacion> cotizaciones;

  @override
  Widget build(BuildContext context) {
    final n = cotizaciones.length;
    return Padding(
      padding: const EdgeInsets.only(top: Espacios.s),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          n == 1
              ? 'Ver 1 cotización no elegida'
              : 'Ver $n cotizaciones no elegidas',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        children: [for (final c in cotizaciones) CotizacionCard(cotizacion: c)],
      ),
    );
  }
}
