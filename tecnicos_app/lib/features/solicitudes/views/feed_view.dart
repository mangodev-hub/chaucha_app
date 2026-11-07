// Pestaña "Solicitudes cerca" del técnico.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatos.dart';
import '../../../core/widgets/estado_vacio.dart';
import '../../../core/widgets/seccion.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../models/solicitud.dart';
import '../viewmodels/feed_view_model.dart';
import '../viewmodels/mis_solicitudes_view_model.dart';
import 'widgets/solicitud_widgets.dart';


class FeedView extends StatefulWidget {
  const FeedView({super.key, required this.crearViewModel});

  final FeedViewModel Function() crearViewModel;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late final FeedViewModel _vm = widget.crearViewModel();

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

  Future<void> _abrir(Solicitud solicitud) async {
    await context.push(
      AppRoutes.detalleSolicitud(solicitud.id, esCliente: false),
    );
    await _vm.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<DatosFeed>(
      listenable: _vm,
      onRetry: _vm.cargar,
      onLoaded: (context, datos) {
        if (!datos.perfil.estaCompleto) {
          return const EstadoVacio(
            icono: Icons.person_pin_circle_outlined,
            mensaje: 'Completa tu perfil (oficios y ubicación) en la '
                'pestaña "Perfil" para ver solicitudes cerca de ti.',
          );
        }
        return RefreshIndicator(
          onRefresh: _vm.cargar,
          child: datos.items.isEmpty
              ? ListView(
                  children: [
                    EstadoVacio(
                      icono: Icons.search_off,
                      mensaje: 'No hay solicitudes de tus oficios a menos de '
                          '${Formatos.distancia(datos.perfil.rangoCoberturaM.toDouble())}.'
                          '\nDesliza hacia abajo para actualizar.',
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: datos.items.length,
                  itemBuilder: (context, i) {
                    final item = datos.items[i];
                    return AnchoMaximo(
                      child: SolicitudCard(
                        solicitud: item.solicitud,
                        extra: [
                          'a ${Formatos.distancia(item.distanciaMetros)}',
                          if (item.yaCotice) 'Ya cotizaste',
                        ].join(' · '),
                        onTap: () => _abrir(item.solicitud),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}


class MisTrabajosView extends StatefulWidget {
  const MisTrabajosView({super.key, required this.crearViewModel});

  final MisTrabajosViewModel Function() crearViewModel;

  @override
  State<MisTrabajosView> createState() => _MisTrabajosViewState();
}

class _MisTrabajosViewState extends State<MisTrabajosView> {
  late final MisTrabajosViewModel _vm = widget.crearViewModel();

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

  Future<void> _abrir(Solicitud solicitud) async {
    await context.push(
      AppRoutes.detalleSolicitud(solicitud.id, esCliente: false),
    );
    await _vm.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<List<Solicitud>>(
      listenable: _vm,
      onRetry: _vm.cargar,
      onLoaded: (context, trabajos) => RefreshIndicator(
        onRefresh: _vm.cargar,
        child: trabajos.isEmpty
            ? ListView(
                children: const [
                  EstadoVacio(
                    icono: Icons.work_outline,
                    mensaje: 'Cuando un cliente acepte tu cotización, '
                        'el trabajo aparecerá aquí.',
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trabajos.length,
                itemBuilder: (context, i) => AnchoMaximo(
                  child: SolicitudCard(
                    solicitud: trabajos[i],
                    onTap: () => _abrir(trabajos[i]),
                  ),
                ),
              ),
      ),
    );
  }
}
