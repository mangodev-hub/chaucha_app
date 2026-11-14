import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../core/media/selector_fotos.dart';
import '../../../../core/providers/core_providers.dart';
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
import '../../../../core/widgets/pantalla_secundaria.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../auth/presentation/widgets/confirmar_identidad.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../cotizaciones/data/repositories/ofertas_en_vivo.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/presentation/widgets/cotizacion_widgets.dart';
import '../../../cotizaciones/presentation/widgets/selector_franja.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';
import '../../../perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import '../../../perfil_puntos/presentation/widgets/escucha_calificaciones.dart';
import '../../../perfil_puntos/presentation/widgets/resena_dialog.dart';
import '../../../reclamos/presentation/widgets/tarjeta_garantia.dart';
import '../../domain/entities/detalle_solicitud.dart';
import '../../domain/entities/foto_solicitud.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/detalle_provider.dart';
import '../providers/novedades_provider.dart';
import '../widgets/detalle_cliente_widgets.dart';
import '../widgets/detalle_widgets.dart';
import '../widgets/editar_solicitud_dialog.dart';
import '../widgets/solicitud_widgets.dart';

/// Acción principal del detalle según el rol y el estado.
typedef _Accion = ({String texto, IconData icono, VoidCallback alPulsar});

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
  Future<bool> _resultado(Future<bool> accion, String exito) async {
    final ok = await accion;
    if (!mounted) return ok;
    if (ok) {
      context.mostrarMensaje(exito, tipo: TipoMensaje.exito);
    } else {
      _mostrarErrorDeAccion();
    }
    return ok;
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
    if (!ok) return;
    final listo = await _resultado(
      _acciones.confirmarTerminado(),
      'Trabajo completado.',
    );
    // Como al terminar un viaje: la calificación aparece sola.
    if (listo && mounted) {
      ref.read(revisarCalificacionesProvider.notifier).ahora();
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

  Future<DateTime?> _elegirFechaHora(String cotizacionId) => elegirFranja(
    context,
    titulo: 'Nueva fecha y hora',
    cargarOcupados: (desde, hasta) => ref
        .read(cotizacionRepositoryProvider)
        .horariosOcupados(cotizacionId, desde: desde, hasta: hasta),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_marcarNovedadesLeidas());
  }

  Future<void> _marcarNovedadesLeidas() async {
    final uid = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (uid == null) return;
    try {
      final detalle = await ref.read(
        detalleSolicitudProvider(widget.solicitudId).future,
      );
      await ref
          .read(notificacionesRepoProvider)
          .marcarLeidasDe(
            uid,
            tipos: const [...tiposDeSolicitud, 'cotizacion_aceptada'],
            referenciaIds: [
              widget.solicitudId,
              for (final c in detalle.cotizaciones) c.id,
            ],
          );
    } on Object {
      // Es secundario: el detalle se muestra igual.
    }
  }

  Future<void> _reagendar(String cotizacionId) async {
    final fecha = await _elegirFechaHora(cotizacionId);
    if (fecha == null || !mounted) return;
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

  Future<void> _cancelarVisita(
    String cotizacionId, {
    bool esCliente = false,
  }) async {
    final ok = await context.confirmar(
      'Cancelar visita',
      esCliente
          ? 'Se cancelará la visita y tu solicitud. Solo es posible con al menos 24 horas de anticipación.'
          : 'La solicitud seguirá publicada para que el cliente elija a otro técnico. Solo es posible con al menos 24 horas de anticipación.',
      textoConfirmar: 'Sí, cancelar visita',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.event_busy_outlined,
    );
    if (ok) {
      await _resultado(
        _acciones.cancelarVisita(cotizacionId),
        'Visita cancelada.',
      );
    }
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
    if (solucion == null || !mounted) return;
    // Cada oferta exige confirmar que es el técnico (biometría o rostro).
    if (!await confirmarIdentidadParaOfertar(context, ref) || !mounted) return;
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
        etiquetas: resena.etiquetas,
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

  void _verPerfil(String tecnicoId) => unawaited(
    context.push(
      AppRoutes.perfilTecnico(
        tecnicoId,
        esCliente: ref.read(usuarioActualProvider)?.rol != Rol.tecnico,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final detalle = detalleSolicitudProvider(widget.solicitudId);
    final valor = ref.watch(detalle);
    final procesando = ref
        .watch(accionesSolicitudProvider(widget.solicitudId))
        .isLoading;
    final escritorio = ResponsiveLayout.isDesktop(context);
    ref.listen(ofertasEnVivoProvider(widget.solicitudId), (antes, ahora) {
      final previas = antes?.value;
      final nuevas = ahora.value;
      if (previas != null &&
          nuevas != null &&
          previas.join(',') != nuevas.join(',')) {
        ref.invalidate(detalle);
      }
    });

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

    return PantallaSecundaria(
      titulo: 'Detalle de la solicitud',
      // El cliente ya tiene su ruta "‹ Mis solicitudes / Oficio · fecha".
      conMigas: !(datos?.soyCliente ?? false),
      barraInferior: boton == null || escritorio
          ? null
          : BarraAccion(child: boton),
      color: datos != null && datos.soyCliente
          ? Colores.fondoClaro
          : Colores.lienzo,
      cuerpo: AsyncValueView<DetalleSolicitud>(
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
          child: datos.soyCliente
              ? _vistaCliente(
                  datos,
                  procesando: procesando,
                  boton: escritorio ? boton : null,
                )
              : escritorio
              ? _Escritorio(
                  izquierda: [
                    EncabezadoSolicitud(solicitud: datos.solicitud),
                    ..._cliente(datos),
                    ..._evidencia(datos),
                    ..._fotosProblema(datos),
                    ..._ubicacion(datos, altura: 280),
                  ],
                  derecha: [
                    QueSigueCard(detalle: datos),
                    ..._garantia(datos),
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
                    ..._cliente(datos),
                    const SizedBox(height: Espacios.l),
                    QueSigueCard(detalle: datos),
                    ..._garantia(datos),
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

  /// Garantía de 30 días: solo para el cliente y el técnico del servicio,
  /// cuando ya se completó.
  List<Widget> _garantia(DetalleSolicitud d) {
    final completadaEn = d.solicitud.completadaEn;
    if (d.estado != EstadoSolicitud.completada ||
        completadaEn == null ||
        !(d.soyCliente || d.soyTecnicoAsignado)) {
      return const [];
    }
    return [
      TarjetaGarantia(
        solicitudId: d.solicitud.id,
        completadaEn: completadaEn,
        esCliente: d.soyCliente,
      ),
    ];
  }

  Future<void> _agregarFotos() async {
    final fotos = await SelectorFotos.elegir(maximo: 5);
    if (!mounted || fotos.isEmpty) return;
    await _resultado(_acciones.agregarFotos(fotos), 'Fotos agregadas.');
  }

  /// "Mis solicitudes" en la ruta: vuelve a la lista.
  void _aLaLista() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    ref.read(pestanaSolicitadaProvider.notifier).pedir('Mis solicitudes');
    context.go(AppRoutes.clienteInicio);
  }

  Widget _vistaCliente(
    DetalleSolicitud d, {
    required bool procesando,
    required Widget? boton,
  }) {
    final s = d.solicitud;
    final recibe = d.estado.recibeCotizaciones;
    final aceptada = d.cotizacionAceptada;
    final ancho = MediaQuery.sizeOf(context).width >= 1000;
    final miId = ref.read(usuarioActualProvider)?.id;
    final evidencias = d.fotosDe(TipoArchivo.evidencia);
    final ubicacion = s.ubicacion;

    final ofertas = OfertasRecibidas(
      ofertas: d.cotizaciones,
      puntoSolicitud: ubicacion,
      recibeOfertas: recibe,
      aceptada: aceptada,
      activas: !procesando,
      onChat: (c) => _chat(c.tecnicoId),
      onVerPerfil: (c) => _verPerfil(c.tecnicoId),
      accionesVisita: aceptada != null && d.estado == EstadoSolicitud.aceptada
          ? AccionesVisita(
              cotizacion: aceptada,
              miId: miId,
              activas: !procesando,
              onReagendar: () => _reagendar(aceptada.id),
              onResponder: (a) => _responderReagendado(aceptada.id, a),
              onCancelar: () => _cancelarVisita(aceptada.id, esCliente: true),
            )
          : null,
    );
    final lateral = <Widget>[
      DetallesProblema(
        descripcion: s.descripcion,
        fotos: [for (final f in d.fotosDe(TipoArchivo.problema)) f.url],
        onAgregar: d.estado.activa ? _agregarFotos : null,
        agregando: procesando,
      ),
      if (evidencias.isNotEmpty) ...[
        const SizedBox(height: Espacios.l),
        DetallesProblema(
          titulo: 'Evidencia del trabajo',
          descripcion: '',
          mostrarDescripcion: false,
          fotos: [for (final f in evidencias) f.url],
        ),
      ],
      if (ubicacion != null) ...[
        const SizedBox(height: Espacios.l),
        UbicacionSolicitud(
          punto: ubicacion,
          direccion: s.direccionReferencia,
          ciudad: d.usuario.ciudad,
        ),
      ],
      ..._garantia(d),
    ];
    Widget columna(List<Widget> hijos) =>
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: hijos);

    return ListaDePagina(
      padding: EstructuraWeb.de(context) != null
          ? const EdgeInsets.only(top: 16, bottom: 20)
          : const EdgeInsets.all(20),
      children: [
        AnchoMaximo(
          ancho: 1180,
          child: columna([
            RutaSolicitud(solicitud: s, onLista: _aLaLista),
            const SizedBox(height: Espacios.m),
            CabeceraSolicitud(
              solicitud: s,
              ofertas: d.cotizaciones.length,
              onEditar: recibe && !procesando ? () => _editar(s) : null,
              onCancelar: recibe && !procesando ? _cancelar : null,
              onEliminar: recibe && !procesando ? _eliminar : null,
              accion: boton,
            ),
            const SizedBox(height: 20),
            if (ancho)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ofertas),
                  const SizedBox(width: 20),
                  SizedBox(width: 340, child: columna(lateral)),
                ],
              )
            else ...[
              ...lateral,
              const SizedBox(height: 20),
              ofertas,
            ],
            const SizedBox(height: Espacios.xxl),
          ]),
        ),
      ],
    );
  }

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
        alPulsar: () =>
            _calificar(d.solicitud.clienteId, 'el cliente', paraTecnico: false),
      );
    }
    return null;
  }

  List<Widget> _cliente(DetalleSolicitud d) {
    if (ref.read(usuarioActualProvider)?.rol != Rol.tecnico) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(top: Espacios.m),
        child: OutlinedButton.icon(
          onPressed: () => unawaited(
            context.push(AppRoutes.perfilCliente(d.solicitud.clienteId)),
          ),
          icon: const Icon(Icons.person_outline),
          label: const Text('Ver perfil del cliente'),
        ),
      ),
    ];
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
      return [
        Seccion(
          titulo: 'Tu oferta',
          child: Builder(
            builder: (_) {
              final activa =
                  mia.estado == EstadoCotizacion.aceptada &&
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
                onResponderReagendado: activa
                    ? (a) => _responderReagendado(mia.id, a)
                    : null,
                onCancelarVisita: activa ? () => _cancelarVisita(mia.id) : null,
              );
            },
          ),
        ),
      ];
    }

    // El cliente ve las ofertas en `_vistaCliente`.
    return const [];
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
    return ListaDePagina(
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
    return ListaDePagina(
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
