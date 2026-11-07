// Inicio del cliente: sus solicitudes y el botón para crear una nueva.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/widgets/estado_vacio.dart';
import '../../../core/widgets/seccion.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../models/solicitud.dart';
import '../viewmodels/mis_solicitudes_view_model.dart';
import 'widgets/solicitud_widgets.dart';





class MisSolicitudesView extends StatefulWidget {
  const MisSolicitudesView({
    super.key,
    required this.crearViewModel,
    required this.onCerrarSesion,
  });

  final MisSolicitudesViewModel Function() crearViewModel;
  final VoidCallback onCerrarSesion;

  @override
  State<MisSolicitudesView> createState() => _MisSolicitudesViewState();
}

class _MisSolicitudesViewState extends State<MisSolicitudesView> {
  late final MisSolicitudesViewModel _vm = widget.crearViewModel();

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

  Future<void> _nueva() async {
    final creada = await context.push<String>(AppRoutes.clienteNuevaSolicitud);
    if (creada != null) await _vm.cargar();
  }

  Future<void> _abrir(Solicitud solicitud) async {
    await context.push(
      AppRoutes.detalleSolicitud(solicitud.id, esCliente: true),
    );
    await _vm.cargar(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: widget.onCerrarSesion,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nueva,
        icon: const Icon(Icons.add),
        label: const Text('Nueva solicitud'),
      ),
      body: ViewStateBuilder<List<Solicitud>>(
        listenable: _vm,
        onRetry: _vm.cargar,
        onLoaded: (context, solicitudes) => RefreshIndicator(
          onRefresh: _vm.cargar,
          child: solicitudes.isEmpty
              ? ListView(
                  children: const [
                    EstadoVacio(
                      icono: Icons.handyman_outlined,
                      mensaje: 'Aún no tienes solicitudes.\n'
                          'Toca "Nueva solicitud" para pedir un técnico.',
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: solicitudes.length,
                  itemBuilder: (context, i) => AnchoMaximo(
                    child: SolicitudCard(
                      solicitud: solicitudes[i],
                      onTap: () => _abrir(solicitudes[i]),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
