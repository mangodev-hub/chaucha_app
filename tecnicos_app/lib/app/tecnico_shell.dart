// Implementa tecnico_shell para la aplicación.
import 'package:flutter/material.dart';

import '../core/widgets/responsive_layout.dart';


class TecnicoShell extends StatefulWidget {
  const TecnicoShell({
    super.key,
    required this.feed,
    required this.trabajos,
    required this.perfil,
    required this.onCerrarSesion,
  });

  final Widget feed;
  final Widget trabajos;
  final Widget perfil;
  final VoidCallback onCerrarSesion;

  @override
  State<TecnicoShell> createState() => _TecnicoShellState();
}

class _TecnicoShellState extends State<TecnicoShell> {
  static const _titulos = ['Solicitudes cerca', 'Mis trabajos', 'Mi perfil'];
  static const _iconos = [
    Icons.travel_explore,
    Icons.work_outline,
    Icons.person_outline,
  ];

  int _indice = 0;

  void _cambiar(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    final contenido = IndexedStack(
      index: _indice,
      children: [widget.feed, widget.trabajos, widget.perfil],
    );
    final esEscritorio = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_indice]),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: widget.onCerrarSesion,
          ),
        ],
      ),
      body: esEscritorio
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _indice,
                  onDestinationSelected: _cambiar,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (var i = 0; i < _titulos.length; i++)
                      NavigationRailDestination(
                        icon: Icon(_iconos[i]),
                        label: Text(_titulos[i]),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: contenido),
              ],
            )
          : contenido,
      bottomNavigationBar: esEscritorio
          ? null
          : NavigationBar(
              selectedIndex: _indice,
              onDestinationSelected: _cambiar,
              destinations: [
                for (var i = 0; i < _titulos.length; i++)
                  NavigationDestination(
                    icon: Icon(_iconos[i]),
                    label: _titulos[i],
                  ),
              ],
            ),
    );
  }
}
