// Detalle de una solicitud. La misma pantalla sirve al cliente y al técnico;
// lo que ve y puede hacer cada uno lo decide `DetalleSolicitud`.
//
// Flujo: el técnico ofrece sus servicios (precio de la visita y solución); el
// cliente revisa las ofertas, le escribe al que le guste y acuerdan el precio
// por chat.
//
// En móvil: una columna y la acción principal fija abajo. En escritorio: dos
// columnas (la solicitud a la izquierda; guía, acción y ofertas a la
// derecha).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/barra_accion.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/esqueleto_carga.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/presentation/widgets/cotizacion_widgets.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../../perfil_puntos/presentation/widgets/resena_dialog.dart';
import '../../domain/entities/detalle_solicitud.dart';
import '../../domain/entities/foto_solicitud.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/detalle_provider.dart';
import '../widgets/detalle_widgets.dart';
import '../widgets/editar_solicitud_dialog.dart';
import '../widgets/solicitud_widgets.dart';

/// Acción principal del detalle según el rol y el estado.
typedef _Accion = ({String texto, IconData icono, VoidCallback alPulsar});

enum _Opcion { editar, eliminar, cancelar }

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
      'Los técnicos ya no podrán enviarte ofertas.',
      textoConfirmar: 'Sí, cancelar',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.cancel_outlined,
    );
    if (ok) await _resultado(_acciones.cancelar(), 'Solicitud cancelada.');
  }
  Future<DateTime?> _elegirFechaHora() async {
  final ahora = DateTime.now();
  final dia = await showDatePicker(
    context: context,
    initialDate: ahora.add(const Duration(days: 1)),
    firstDate: ahora,
    lastDate: ahora.add(const Duration(days: 90)),
  );
  if (dia == null || !mounted) return null;
  final hora = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 9, minute: 0),
  );
  if (hora == null) return null;
  return DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute);
}

Future<void> _reagendar(String cotizacionId) async {
  final fecha = await _elegirFechaHora();
  if (fecha == null) return;
  await _resultado(
    _acciones.proponerReagendado(cotizacionId, fecha),
    'Propuesta enviada. La otra persona debe aceptarla.',
  );
}

Future<void> _responderReagendado(String cotizacionId, bool acepta) =>
    _resultado(
      _acciones.responderReagendado(cotizacionId, acepta),
      acepta ? 'Nuevo horario confirmado.' : 'Propuesta rechazada.',
    );

Future<void> _cancelarVisita(String cotizacionId) async {
  final ok = await context.confirmar(
    'Cancelar visita',
    'La solicitud seguirá publicada para que el cliente elija a otro técnico.',
    textoConfirmar: 'Sí, cancelar visita',
    textoCancelar: 'Volver',
    destructivo: true,
    icono: Icons.event_busy_outlined,
  );
  if (ok) await _resultado(_acciones.cancelarVisita(cotizacionId), 'Visita cancelada.');
}

  Future<void> _ofrecer() async {
    final perfil = await ref.read(perfilTecnicoProvider.future);
    if (!mounted) return;
    if (perfil.tarifaBase <= 0) {
      context.mostrarMensaje(
        'Configura tu tarifa base en Mi perfil antes de ofertar.',
        tipo: TipoMensaje.error,
      );
      return;
    }
    final solucion = await mostrarFormularioOferta(
      context,
      tarifaBase: perfil.tarifaBase,
    );
    if (solucion == null) return;
    await _resultado(
      _acciones.enviarOferta(solucion: solucion),
      'Oferta enviada. Si al cliente le interesa, te escribirá.',
    );
  }

  Future<void> _editar(Solicitud solicitud) async {
    final datos = await mostrarEditarSolicitud(context, solicitud);
    if (datos == null) return;
    await _resultado(
      _acciones.editar(
        descripcion: datos.descripcion,
        oficioId: datos.oficioId,
        direccion: datos.direccion,
      ),
      'Solicitud actualizada.',
    );
  }

  Future<void> _eliminar() async {
    final ok = await context.confirmar(
      'Eliminar solicitud',
      'Se borrará la solicitud junto con las propuestas y los chats con '
          'técnicos. No se puede deshacer.',
      textoConfirmar: 'Sí, eliminar',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.delete_outline,
    );
    if (!ok) return;
    final hecho = await _acciones.eliminar();
    if (!mounted) return;
    if (hecho) {
      context
        ..mostrarMensaje(
          'La solicitud y sus propuestas se borraron.',
          tipo: TipoMensaje.eliminado,
          titulo: 'Eliminado correctamente',
        )
        ..pop();
    } else {
      _mostrarErrorDeAccion();
    }
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

  Future<void> _calificar(
    String destinatarioId,
    String nombre, {
    required bool paraTecnico,
  }) async {
    final resena = await mostrarDialogoResena(
      context,
      nombre: nombre,
      paraTecnico: paraTecnico,
    );
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
    await abrirChat(context, id, esCliente: esCliente);
    if (!mounted) return;
    // En el chat se pudo confirmar un ticket (la solicitud pasa a "En curso").
    ref.invalidate(detalleSolicitudProvider(widget.solicitudId));
  }

  /// Vuelve a la pantalla anterior o, si se entró directo por la URL, al
  /// inicio del rol.
  void _regresar() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final esCliente = ref.read(usuarioActualProvider)?.rol == Rol.cliente;
    context.go(esCliente ? AppRoutes.clienteInicio : AppRoutes.tecnicoInicio);
  }

  void _verPerfil(String tecnicoId) =>
      unawaited(context.push(AppRoutes.perfilTecnico(tecnicoId)));

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
            _MenuOpciones(
              habilitado: !procesando,
              onEditar: () => _editar(datos.solicitud),
              onEliminar: _eliminar,
              onCancelar: _cancelar,
            ),
        ],
      ),
      bottomNavigationBar: boton == null || escritorio
          ? null
          : BarraAccion(child: boton),
      body: AsyncValueView<DetalleSolicitud>(
        value: valor,
        cargando: (_) => _DetalleCargando(escritorio: escritorio),
        onError: (context, mensaje) => EstadoMensaje(
          icono: Icons.cloud_off_outlined,
          tipo: TipoEstado.error,
          titulo: 'No se pudo cargar la solicitud',
          mensaje: mensaje,
          textoAccion: 'Reintentar',
          onAccion: () => ref.invalidate(detalle),
          textoAccionSecundaria: 'Regresar',
          onAccionSecundaria: _regresar,
        ),
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
                    ..._ofertas(datos, procesando: procesando),
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
                    ..._ofertas(datos, procesando: procesando),
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
          alPulsar: () => _calificar(
            aceptada.tecnicoId,
            aceptada.tecnicoNombre,
            paraTecnico: true,
          ),
        );
      }
      return null;
    }
    if (estado.recibeCotizaciones && d.miCotizacion == null) {
      return (
        texto: 'Ofrecer mis servicios',
        icono: Icons.handyman_outlined,
        alPulsar: _ofrecer,
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
                alPulsar: () => _calificar(
          d.solicitud.clienteId,
          'el cliente',
          paraTecnico: false,
        ),
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

  List<Widget> _ofertas(DetalleSolicitud d, {required bool procesando}) {
    if (!d.soyCliente) {
      final mia = d.miCotizacion;
      if (mia == null) return const [];
      // El técnico abre el chat para leer o responder; solo el cliente
      // puede escribir primero (lo controla la pantalla del chat).
      return [
        Seccion(
          titulo: 'Tu oferta',
child: Builder(builder: (_) {
  final activa = mia.estado == EstadoCotizacion.aceptada &&
      d.estado == EstadoSolicitud.aceptada;
  return CotizacionCard(
    cotizacion: mia,
    destacada: mia.estado == EstadoCotizacion.aceptada,
    accionesActivas: !procesando,
    textoChat: 'Abrir chat',
    onChat: mia.estado == EstadoCotizacion.rechazada
        ? null
        : () => _chat(mia.tecnicoId),
    miId: ref.read(usuarioActualProvider)?.id,
    onReagendar: activa ? () => _reagendar(mia.id) : null,
    onResponderReagendado:
        activa ? (a) => _responderReagendado(mia.id, a) : null,
    onCancelarVisita: activa ? () => _cancelarVisita(mia.id) : null,
  );
}),
        ),
      ];
    }

    // Con un técnico contratado, se destaca su oferta y el resto se pliega.
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
            onVerPerfil: () => _verPerfil(aceptada.tecnicoId),
            miId: ref.read(usuarioActualProvider)?.id,
onReagendar: d.estado == EstadoSolicitud.aceptada
    ? () => _reagendar(aceptada.id)
    : null,
onResponderReagendado: d.estado == EstadoSolicitud.aceptada
    ? (a) => _responderReagendado(aceptada.id, a)
    : null,
          ),
        ),
        if (otras.isNotEmpty)
          _OfertasPlegadas(ofertas: otras, onVerPerfil: _verPerfil),
      ];
    }

    final n = d.cotizaciones.length;
    final recibeOfertas = d.estado.recibeCotizaciones;
    return [
      Seccion(
        titulo: n == 0 ? 'Ofertas' : 'Ofertas ($n)',
        child: n == 0
            ? EstadoMensaje(
                icono: Icons.local_offer_outlined,
                compacto: true,
                mensaje: recibeOfertas
                    ? 'Aún no hay ofertas. Te avisaremos cuando un técnico '
                          'ofrezca sus servicios.'
                    : 'Esta solicitud no recibió ofertas.',
              )
            : Column(
                children: [
                  for (final c in d.cotizaciones)
                    CotizacionCard(
                      cotizacion: c,
                      accionesActivas: !procesando,
                      // Se contrata confirmando el ticket en el chat.
                      textoChat: c.tarifaPendiente
                          ? 'Revisar ticket en el chat'
                          : 'Escribir al técnico',
                      onChat: () => _chat(c.tecnicoId),
                      onVerPerfil: () => _verPerfil(c.tecnicoId),
                    ),
                ],
              ),
      ),
    ];
  }
}

/// Esqueleto del detalle mientras carga: la misma forma que la pantalla
/// (encabezado, guía, fotos y mapa).
class _DetalleCargando extends StatelessWidget {
  const _DetalleCargando({required this.escritorio});

  final bool escritorio;

  @override
  Widget build(BuildContext context) {
    const separacion = SizedBox(height: Espacios.l);
    const encabezado = TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BloqueEsqueleto.circulo(tamano: 44),
              SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloqueEsqueleto(alto: 18, ancho: 160),
                    SizedBox(height: Espacios.s),
                    BloqueEsqueleto(ancho: 96),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Espacios.l),
          BloqueEsqueleto(),
          SizedBox(height: Espacios.s),
          BloqueEsqueleto(ancho: 220),
        ],
      ),
    );
    const queSigue = TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BloqueEsqueleto(alto: 16, ancho: 120),
          SizedBox(height: Espacios.m),
          BloqueEsqueleto(),
          SizedBox(height: Espacios.s),
          BloqueEsqueleto(ancho: 200),
        ],
      ),
    );
    const foto = BloqueEsqueleto(alto: 96, ancho: 96, radio: Radios.medio);
    const fotos = Wrap(
      spacing: Espacios.s,
      runSpacing: Espacios.s,
      children: [foto, foto, foto],
    );
    final mapa = BloqueEsqueleto(
      alto: escritorio ? 280 : 220,
      radio: Radios.grande,
    );

    return EsqueletoCarga(
      etiqueta: 'Cargando la solicitud',
      child: escritorio
          ? _Escritorio(
              izquierda: [encabezado, separacion, fotos, separacion, mapa],
              derecha: const [queSigue],
            )
          : _Movil(
              children: [
                encabezado,
                separacion,
                queSigue,
                separacion,
                fotos,
                separacion,
                mapa,
              ],
            ),
    );
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
  const _MenuOpciones({
    required this.habilitado,
    required this.onEditar,
    required this.onEliminar,
    required this.onCancelar,
  });

  final bool habilitado;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback onCancelar;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    PopupMenuItem<_Opcion> item(
      _Opcion v,
      IconData icono,
      String texto, {
      Color? color,
    }) => PopupMenuItem(
      value: v,
      child: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: Espacios.m),
          Text(texto, style: TextStyle(color: color)),
        ],
      ),
    );

    return PopupMenuButton<_Opcion>(
      tooltip: 'Más opciones',
      enabled: habilitado,
      onSelected: (o) => switch (o) {
        _Opcion.editar => onEditar(),
        _Opcion.eliminar => onEliminar(),
        _Opcion.cancelar => onCancelar(),
      },
      itemBuilder: (context) => [
        item(_Opcion.editar, Icons.edit_outlined, 'Editar solicitud'),
        item(
          _Opcion.cancelar,
          Icons.cancel_outlined,
          'Cancelar solicitud',
          color: error,
        ),
        item(
          _Opcion.eliminar,
          Icons.delete_outline,
          'Eliminar solicitud',
          color: error,
        ),
      ],
    );
  }
}

/// Ofertas que no se eligieron, plegadas debajo del técnico asignado.
class _OfertasPlegadas extends StatelessWidget {
  const _OfertasPlegadas({required this.ofertas, required this.onVerPerfil});

  final List<Cotizacion> ofertas;
  final void Function(String tecnicoId) onVerPerfil;

  @override
  Widget build(BuildContext context) {
    final n = ofertas.length;
    return Padding(
      padding: const EdgeInsets.only(top: Espacios.s),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          n == 1 ? 'Ver 1 oferta no elegida' : 'Ver $n ofertas no elegidas',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        children: [
          for (final c in ofertas)
            CotizacionCard(
              cotizacion: c,
              onVerPerfil: () => onVerPerfil(c.tecnicoId),
            ),
        ],
      ),
    );
  }
}
