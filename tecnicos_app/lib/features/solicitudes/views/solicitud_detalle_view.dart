// Detalle de una solicitud. La misma pantalla sirve al cliente y al
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/media/selector_fotos.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatos.dart';
import '../../../core/widgets/mapa_ubicacion.dart';
import '../../../core/widgets/mensajes.dart';
import '../../../core/widgets/seccion.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../../cotizaciones/models/cotizacion.dart';
import '../../cotizaciones/views/cotizacion_widgets.dart';
import '../../perfil_puntos/views/resena_dialog.dart';
import '../models/solicitud.dart';
import '../viewmodels/solicitud_detalle_view_model.dart';
import 'widgets/solicitud_widgets.dart';



class SolicitudDetalleView extends StatefulWidget {
  const SolicitudDetalleView({super.key, required this.crearViewModel});

  final SolicitudDetalleViewModel Function() crearViewModel;

  @override
  State<SolicitudDetalleView> createState() => _SolicitudDetalleViewState();
}

class _SolicitudDetalleViewState extends State<SolicitudDetalleView> {
  late final SolicitudDetalleViewModel _vm = widget.crearViewModel();

  @override
  void initState() {
    super.initState();
    _vm.cargar();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }


  Future<void> _resultado(Future<String?> accion, String exito) async {
    final error = await accion;
    if (mounted) context.mostrarMensaje(error ?? exito);
  }

  Future<void> _aceptar(Cotizacion cotizacion) async {
    final ok = await context.confirmar(
      'Aceptar cotización',
      '¿Contratar a ${cotizacion.tecnicoNombre} por '
          '${Formatos.dinero(cotizacion.total)}? Las demás se rechazarán.',
    );
    if (ok) await _resultado(_vm.aceptar(cotizacion), 'Cotización aceptada.');
  }

  Future<void> _confirmarTerminado() async {
    final ok = await context.confirmar(
      'Confirmar trabajo',
      '¿El técnico terminó el trabajo correctamente?',
    );
    if (ok) {
      await _resultado(_vm.confirmarTerminado(), 'Trabajo completado.');
    }
  }

  Future<void> _cancelar() async {
    final ok = await context.confirmar(
      'Cancelar solicitud',
      'Los técnicos ya no podrán cotizarla.',
    );
    if (ok) await _resultado(_vm.cancelar(), 'Solicitud cancelada.');
  }

  Future<void> _cotizar() async {
    final datos = await mostrarFormularioCotizacion(context);
    if (datos == null) return;
    await _resultado(
      _vm.enviarCotizacion(
        manoObra: datos.manoObra,
        materiales: datos.materiales,
        detalle: datos.detalle,
      ),
      'Cotización enviada.',
    );
  }

  Future<void> _marcarTerminada() async {
    final evidencias = await SelectorFotos.elegir(maximo: 3);
    if (evidencias.isEmpty || !mounted) {
      if (mounted) context.mostrarMensaje('Sube al menos una foto del trabajo.');
      return;
    }
    await _resultado(
      _vm.marcarTerminada(evidencias),
      'Listo. El cliente debe confirmar el trabajo.',
    );
  }

  Future<void> _calificar(String destinatarioId, String nombre) async {
    final resena = await mostrarDialogoResena(context, nombre: nombre);
    if (resena == null) return;
    await _resultado(
      _vm.calificar(
        destinatarioId: destinatarioId,
        estrellas: resena.estrellas,
        comentario: resena.comentario,
      ),
      '¡Gracias por tu calificación!',
    );
  }

  Future<void> _chat(String tecnicoId) async {
    final resultado = await _vm.abrirChat(tecnicoId);
    if (!mounted) return;
    final id = resultado.conversacionId;
    if (id == null) {
      context.mostrarMensaje(resultado.error ?? 'No se pudo abrir el chat.');
      return;
    }
    await context.push(
      AppRoutes.chat(id, esCliente: _vm.usuario.id != tecnicoId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la solicitud')),
      body: ViewStateBuilder<DetalleSolicitud>(
        listenable: _vm,
        onRetry: _vm.cargar,
        onLoaded: (context, detalle) => RefreshIndicator(
          onRefresh: _vm.cargar,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AnchoMaximo(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Encabezado(solicitud: detalle.solicitud),
                    ..._contenido(detalle),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _vm.procesando,
                      builder: (context, procesando, _) => procesando
                          ? const LinearProgressIndicator()
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    ..._acciones(detalle),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _contenido(DetalleSolicitud detalle) {
    final ubicacion = detalle.solicitud.ubicacion;
    final evidencias = detalle.fotosDe(TipoArchivo.evidencia);
    return [
      if (ubicacion != null)
        Seccion(
          titulo: 'Ubicación',
          child: MapaUbicacion(punto: ubicacion, altura: 220),
        ),
      Seccion(
        titulo: 'Fotos del problema',
        child: GaleriaFotos(
          urls: [for (final f in detalle.fotosDe(TipoArchivo.problema)) f.url],
        ),
      ),
      if (evidencias.isNotEmpty)
        Seccion(
          titulo: 'Evidencia del trabajo',
          child: GaleriaFotos(urls: [for (final f in evidencias) f.url]),
        ),
      ..._cotizaciones(detalle),
    ];
  }

  List<Widget> _cotizaciones(DetalleSolicitud detalle) {
    if (detalle.soyCliente) {
      final puedeAceptar = detalle.estado.recibeCotizaciones;
      return [
        Seccion(
          titulo: 'Cotizaciones (${detalle.cotizaciones.length})',
          child: detalle.cotizaciones.isEmpty
              ? const Text('Aún no hay cotizaciones. Te avisaremos.')
              : Column(
                  children: [
                    for (final c in detalle.cotizaciones)
                      CotizacionCard(
                        cotizacion: c,
                        onAceptar: puedeAceptar &&
                                c.estado == EstadoCotizacion.pendiente
                            ? () => _aceptar(c)
                            : null,
                        onChat: () => _chat(c.tecnicoId),
                      ),
                  ],
                ),
        ),
      ];
    }
    final mia = detalle.miCotizacion;
    if (mia == null) return const [];
    return [
      Seccion(
        titulo: 'Tu cotización',
        child: CotizacionCard(
          cotizacion: mia,
          onChat: () => _chat(mia.tecnicoId),
        ),
      ),
    ];
  }

  List<Widget> _acciones(DetalleSolicitud detalle) {
    final estado = detalle.estado;
    if (detalle.soyCliente) {
      final aceptada = detalle.cotizacionAceptada;
      return [
        if (estado == EstadoSolicitud.porConfirmar)
          FilledButton.icon(
            onPressed: _confirmarTerminado,
            icon: const Icon(Icons.verified_outlined),
            label: const Text('Confirmar trabajo terminado'),
          ),
        if (estado == EstadoSolicitud.completada && aceptada != null)
          FilledButton.tonalIcon(
            onPressed: () =>
                _calificar(aceptada.tecnicoId, aceptada.tecnicoNombre),
            icon: const Icon(Icons.star_outline),
            label: const Text('Calificar al técnico'),
          ),
        if (estado.recibeCotizaciones)
          TextButton.icon(
            onPressed: _cancelar,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancelar solicitud'),
          ),
      ];
    }
    return [
      if (estado.recibeCotizaciones && detalle.miCotizacion == null)
        FilledButton.icon(
          onPressed: _cotizar,
          icon: const Icon(Icons.request_quote_outlined),
          label: const Text('Enviar cotización'),
        ),
      if (detalle.soyTecnicoAsignado && estado == EstadoSolicitud.aceptada)
        FilledButton.icon(
          onPressed: _marcarTerminada,
          icon: const Icon(Icons.task_alt),
          label: const Text('Marcar como terminado (subir fotos)'),
        ),
      if (detalle.soyTecnicoAsignado && estado == EstadoSolicitud.completada)
        FilledButton.tonalIcon(
          onPressed: () => _calificar(detalle.solicitud.clienteId, 'el cliente'),
          icon: const Icon(Icons.star_outline),
          label: const Text('Calificar al cliente'),
        ),
    ];
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.solicitud});

  final Solicitud solicitud;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final direccion = solicitud.direccionReferencia;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(solicitud.oficioNombre, style: textos.headlineSmall),
            ),
            EstadoChip(solicitud.estado),
          ],
        ),
        const SizedBox(height: 4),
        Text(Formatos.fecha(solicitud.creadoEn), style: textos.bodySmall),
        const SizedBox(height: 12),
        Text(solicitud.descripcion, style: textos.bodyLarge),
        if (direccion != null) ...[
          const SizedBox(height: 8),
          Text('Referencia: $direccion'),
        ],
      ],
    );
  }
}
