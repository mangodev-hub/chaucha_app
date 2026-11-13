// Agenda del cliente y del técnico: calendario (Mes, Semana o Lista) con las
// visitas agendadas y, al lado, la tarjeta "Hoy" y los próximos trabajos.
// En el móvil va todo en una columna. Los datos salen de una consulta por
// rango (`visitasRangoProvider`) y otra desde hoy (`visitasProximasProvider`).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pie_pagina.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../chat/data/repositories/supabase_chat_repository.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/presentation/widgets/selector_franja.dart';
import '../../domain/entities/visita_agenda.dart';
import '../providers/detalle_provider.dart';
import '../providers/visitas_agenda_provider.dart';
import '../widgets/agenda_widgets.dart';

class AgendaView extends ConsumerStatefulWidget {
  const AgendaView({super.key, required this.esCliente, this.ahora});

  final bool esCliente;

  /// Solo para pruebas: fija "hoy".
  final DateTime? ahora;

  /// Desde este ancho, calendario y columna lateral lado a lado.
  static const double anchoWeb = 1000;

  @override
  ConsumerState<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends ConsumerState<AgendaView> {
  late DateTime _foco = DateUtils.dateOnly(_ahora);

  /// Día elegido en el mes del móvil (su lista sale debajo).
  DateTime? _diaMovil;
  String? _procesando;

  DateTime get _ahora => widget.ahora ?? DateTime.now();

  RangoAgenda _rango(VistaAgenda vista) {
    final esCliente = widget.esCliente;
    switch (vista) {
      case VistaAgenda.mes:
        final dias = diasGrillaMes(_foco);
        return (
          desde: dias.first,
          hasta: DateUtils.addDaysToDate(dias.last, 1),
          esCliente: esCliente,
        );
      case VistaAgenda.semana:
        final lunes = lunesDe(_foco);
        return (
          desde: lunes,
          hasta: DateUtils.addDaysToDate(lunes, 7),
          esCliente: esCliente,
        );
      case VistaAgenda.lista:
        return (
          desde: DateTime(_foco.year, _foco.month),
          hasta: DateTime(_foco.year, _foco.month + 1),
          esCliente: esCliente,
        );
    }
  }

  void _mover(VistaAgenda vista, int paso) => setState(() {
    _diaMovil = null;
    _foco = vista == VistaAgenda.semana
        ? DateUtils.addDaysToDate(_foco, 7 * paso)
        : DateTime(_foco.year, _foco.month + paso);
  });

  String _tituloCalendario(VistaAgenda vista, {required bool corto}) {
    if (vista != VistaAgenda.semana) {
      return '${mesesNombre[_foco.month - 1]} ${_foco.year}';
    }
    final lunes = lunesDe(_foco);
    final domingo = DateUtils.addDaysToDate(lunes, 6);
    if (corto) {
      // "9–15 nov" o "30 nov–6 dic" (en el móvil no cabe la versión larga).
      String mes(DateTime d) =>
          mesesNombre[d.month - 1].substring(0, 3).toLowerCase();
      return lunes.month == domingo.month
          ? '${lunes.day}–${domingo.day} ${mes(domingo)}'
          : '${lunes.day} ${mes(lunes)}–${domingo.day} ${mes(domingo)}';
    }
    final mesA = mesesNombre[lunes.month - 1].toLowerCase();
    final mesB = mesesNombre[domingo.month - 1].toLowerCase();
    return lunes.month == domingo.month
        ? '${lunes.day} al ${domingo.day} de $mesB ${domingo.year}'
        : '${lunes.day} de $mesA al ${domingo.day} de $mesB';
  }

  void _recargar() {
    ref
      ..invalidate(visitasRangoProvider)
      ..invalidate(visitasProximasProvider);
  }

  // ---------------------------------------------------------- acciones

  Future<void> _conAccion(
    VisitaAgenda v,
    Future<bool> Function(AccionesSolicitudNotifier a) accion,
    String exito,
  ) async {
    setState(() => _procesando = v.cotizacionId);
    final acciones = accionesSolicitudProvider(v.solicitudId);
    final ok = await accion(ref.read(acciones.notifier));
    if (!mounted) return;
    setState(() => _procesando = null);
    if (ok) {
      _recargar();
      context.mostrarMensaje(exito, tipo: TipoMensaje.exito);
    } else if (ref.read(acciones) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  /// Reagendar u "Otra hora": el selector solo ofrece franjas libres (la base
  /// además impide los choques).
  Future<void> _reagendar(VisitaAgenda v) async {
    final fecha = await elegirFranja(
      context,
      titulo: 'Nueva fecha y hora',
      inicial: v.reagendaInicio ?? v.inicio,
      cargarOcupados: (desde, hasta) => ref
          .read(cotizacionRepositoryProvider)
          .horariosOcupados(v.cotizacionId, desde: desde, hasta: hasta),
    );
    if (fecha == null || !mounted) return;
    await _conAccion(
      v,
      (a) => a.proponerReagendado(v.cotizacionId, fecha),
      widget.esCliente
          ? 'Propuesta enviada. El técnico debe aceptarla.'
          : 'Propuesta enviada. El cliente debe aceptarla.',
    );
  }

  Future<void> _confirmar(VisitaAgenda v) => _conAccion(
    v,
    (a) => a.responderReagendado(v.cotizacionId, true),
    'Listo, la visita quedó en la nueva hora.',
  );

  Future<void> _escribir(VisitaAgenda v) async {
    try {
      final id = await ref
          .read(chatRepositoryProvider)
          .obtenerOCrearConversacion(
            solicitudId: v.solicitudId,
            tecnicoId: v.tecnicoId,
          );
      if (!mounted) return;
      await abrirChat(context, id, esCliente: widget.esCliente);
    } on AppFailure catch (e) {
      if (mounted) context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
    }
  }

  Widget _tarjeta(VisitaAgenda v, {bool conDetalle = true}) => TarjetaTrabajo(
    visita: v,
    ocupado: _procesando == v.cotizacionId,
    onTap: conDetalle ? () => unawaited(_abrirDetalle(v)) : null,
    onReagendar: () => unawaited(_reagendar(v)),
    onEscribir: () => unawaited(_escribir(v)),
    onConfirmar: () => unawaited(_confirmar(v)),
  );

  /// Detalle de una visita (al tocarla en el calendario): su tarjeta con las
  /// acciones y el enlace a la solicitud.
  Future<void> _abrirDetalle(VisitaAgenda v) async {
    final textos = Theme.of(context).textTheme;
    await showDialog<void>(
      context: context,
      builder: (dialogo) => Dialog(
        insetPadding: const EdgeInsets.all(Espacios.l),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(Espacios.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tituloDia(v.inicio),
                        style: textos.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.of(dialogo).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                Text(
                  nombreEstado(v.estado),
                  style: textos.labelMedium?.copyWith(
                    color: coloresVisita(v.estado).$2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: Espacios.m),
                TarjetaTrabajo(
                  visita: v,
                  onReagendar: () {
                    Navigator.of(dialogo).pop();
                    unawaited(_reagendar(v));
                  },
                  onEscribir: () {
                    Navigator.of(dialogo).pop();
                    unawaited(_escribir(v));
                  },
                  onConfirmar: () {
                    Navigator.of(dialogo).pop();
                    unawaited(_confirmar(v));
                  },
                ),
                const SizedBox(height: Espacios.s),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogo).pop();
                    unawaited(
                      context.push(
                        AppRoutes.detalleSolicitud(
                          v.solicitudId,
                          esCliente: widget.esCliente,
                        ),
                      ),
                    );
                  },
                  child: const Text('Ver la solicitud'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------- vista

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width >= AgendaView.anchoWeb;
    final vista =
        ref.watch(vistaAgendaProvider) ??
        (ancho ? VistaAgenda.mes : VistaAgenda.lista);
    final rango = _rango(vista);
    final visitas = ref.watch(visitasRangoProvider(rango));
    final proximas = ref.watch(visitasProximasProvider(widget.esCliente));
    final listaProximas = proximas.value ?? const <VisitaAgenda>[];
    final ahora = _ahora;

    final esteMes = [
      for (final v in listaProximas)
        if (v.inicio.isAfter(ahora) &&
            v.inicio.year == ahora.year &&
            v.inicio.month == ahora.month)
          v,
    ].length;

    final encabezado = _Encabezado(
      subtitulo: esteMes == 0
          ? 'Sin visitas próximas este mes'
          : esteMes == 1
          ? '1 visita próxima este mes'
          : '$esteMes visitas próximas este mes',
      selector: SelectorVistaAgenda<VistaAgenda>(
        opciones: const {
          VistaAgenda.mes: 'Mes',
          VistaAgenda.semana: 'Semana',
          VistaAgenda.lista: 'Lista',
        },
        valor: vista,
        onCambio: (v) {
          setState(() => _diaMovil = null);
          ref.read(vistaAgendaProvider.notifier).elegir(v);
        },
      ),
      ancho: ancho,
    );

    final calendario = _TarjetaBlanca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CabeceraCalendario(
            titulo: _tituloCalendario(vista, corto: !ancho),
            onHoy: () => setState(() {
              _foco = DateUtils.dateOnly(_ahora);
              _diaMovil = null;
            }),
            onAnterior: () => _mover(vista, -1),
            onSiguiente: () => _mover(vista, 1),
          ),
          const SizedBox(height: Espacios.m),
          AsyncValueView<List<VisitaAgenda>>(
            value: visitas,
            onRetry: () => ref.invalidate(visitasRangoProvider(rango)),
            cargando: (_) => const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
            onData: (context, lista) =>
                _contenidoVista(vista: vista, visitas: lista, ancho: ancho),
          ),
        ],
      ),
    );

    final hoy = TarjetaHoyAgenda(proximas: listaProximas, ahora: ahora);
    final siguientes = [
      for (final v in listaProximas)
        if (!v.fin.isBefore(ahora)) v,
    ];
    final proximosTrabajos = _ProximosTrabajos(
      visitas: siguientes.take(3).toList(),
      cargando: proximas.isLoading && !proximas.hasValue,
      esCliente: widget.esCliente,
      tarjeta: _tarjeta,
      onPedir: () => unawaited(context.push(AppRoutes.clienteNuevaSolicitud)),
    );

    final Widget cuerpo;
    if (ancho) {
      cuerpo = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [encabezado, const SizedBox(height: 16), calendario],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [hoy, const SizedBox(height: 16), proximosTrabajos],
            ),
          ),
        ],
      );
    } else {
      cuerpo = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          encabezado,
          const SizedBox(height: Espacios.m),
          hoy,
          const SizedBox(height: Espacios.m),
          Align(alignment: Alignment.centerLeft, child: encabezado.selector),
          const SizedBox(height: Espacios.m),
          calendario,
          const SizedBox(height: Espacios.l),
          proximosTrabajos,
        ],
      );
    }

    final dentroDeWeb = ScrollDePagina.activo(context);
    return ColoredBox(
      color: Colores.fondoClaro,
      child: RefreshIndicator(
        onRefresh: () async {
          _recargar();
          await esperarSinError(
            ref.read(visitasProximasProvider(widget.esCliente).future),
          );
        },
        child: ListaDePagina(
          padding: dentroDeWeb
              ? const EdgeInsets.only(top: Espacios.s)
              : EdgeInsets.all(ancho ? Espacios.xl : Espacios.l),
          children: [
            cuerpo,
            const SizedBox(height: Espacios.xxl),
            const PiePagina(),
          ],
        ),
      ),
    );
  }

  Widget _contenidoVista({
    required VistaAgenda vista,
    required List<VisitaAgenda> visitas,
    required bool ancho,
  }) {
    final textos = Theme.of(context).textTheme;
    void abrir(VisitaAgenda v) => unawaited(_abrirDetalle(v));
    switch (vista) {
      case VistaAgenda.mes:
        final mes = VistaMesAgenda(
          mes: _foco,
          visitas: visitas,
          onVisita: abrir,
          compacta: !ancho,
          diaElegido: _diaMovil,
          onDia: (d) => setState(() => _diaMovil = _diaMovil == d ? null : d),
          hoy: _ahora,
        );
        final dia = _diaMovil;
        if (ancho || dia == null) return mes;
        final delDia = porDia(visitas)[dia] ?? const <VisitaAgenda>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            mes,
            const SizedBox(height: Espacios.m),
            Text(
              tituloDia(dia),
              style: textos.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: Espacios.s),
            if (delDia.isEmpty)
              Text(
                'Sin visitas ese día.',
                style: textos.bodySmall?.copyWith(color: Colores.tintaGris),
              )
            else
              for (final v in delDia)
                Padding(
                  padding: const EdgeInsets.only(bottom: Espacios.s),
                  child: _tarjeta(v),
                ),
          ],
        );
      case VistaAgenda.semana:
        return VistaSemanaAgenda(
          lunes: lunesDe(_foco),
          visitas: visitas,
          onVisita: abrir,
          diasVisibles: ancho ? 7 : 3,
          ahora: _ahora,
        );
      case VistaAgenda.lista:
        if (visitas.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Espacios.xl),
            child: Text(
              'No tienes visitas en '
              '${mesesNombre[_foco.month - 1].toLowerCase()}.',
              textAlign: TextAlign.center,
              style: textos.bodyMedium?.copyWith(color: Colores.tintaGris),
            ),
          );
        }
        final mapa = porDia(visitas);
        final dias = mapa.keys.toList()..sort();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final d in dias) ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: Espacios.s,
                  bottom: Espacios.s,
                ),
                child: Text(
                  tituloDia(d),
                  style: textos.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colores.tintaTitulo,
                  ),
                ),
              ),
              for (final v in mapa[d]!)
                Padding(
                  padding: const EdgeInsets.only(bottom: Espacios.s),
                  child: _tarjeta(v),
                ),
            ],
          ],
        );
    }
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({
    required this.subtitulo,
    required this.selector,
    required this.ancho,
  });

  final String subtitulo;
  final Widget selector;
  final bool ancho;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final titulo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agenda',
          style: textos.headlineSmall?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colores.tintaTitulo,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitulo,
          style: textos.bodySmall?.copyWith(
            fontSize: 12,
            color: Colores.tintaGris,
          ),
        ),
      ],
    );
    if (!ancho) return titulo;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: titulo),
        selector,
      ],
    );
  }
}

class _TarjetaBlanca extends StatelessWidget {
  const _TarjetaBlanca({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(Espacios.l),
    decoration: BoxDecoration(
      color: Colores.tarjeta,
      borderRadius: BorderRadius.circular(Radios.tarjeta),
      boxShadow: Sombras.tarjeta,
    ),
    child: child,
  );
}

class _ProximosTrabajos extends StatelessWidget {
  const _ProximosTrabajos({
    required this.visitas,
    required this.cargando,
    required this.esCliente,
    required this.tarjeta,
    required this.onPedir,
  });

  final List<VisitaAgenda> visitas;
  final bool cargando;
  final bool esCliente;
  final Widget Function(VisitaAgenda v) tarjeta;
  final VoidCallback onPedir;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return _TarjetaBlanca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Próximos trabajos',
                  style: textos.titleSmall?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colores.tintaTitulo,
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colores.divisor,
                  borderRadius: BorderRadius.circular(Radios.pildora),
                ),
                child: Text(
                  '${visitas.length}',
                  style: textos.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colores.tintaTitulo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.m),
          if (cargando)
            const Padding(
              padding: EdgeInsets.all(Espacios.l),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (visitas.isEmpty) ...[
            Text(
              'No tienes trabajos agendados.',
              style: textos.bodyMedium?.copyWith(color: Colores.tintaGris),
            ),
            if (esCliente) ...[
              const SizedBox(height: Espacios.m),
              FilledButton.icon(
                onPressed: onPedir,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radios.pequeno),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Pedir un técnico'),
              ),
            ],
          ] else
            for (final (i, v) in visitas.indexed) ...[
              if (i > 0) const SizedBox(height: Espacios.s),
              tarjeta(v),
            ],
        ],
      ),
    );
  }
}
