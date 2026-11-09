import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../core/widgets/responsive_layout.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';

class Destino {
  const Destino(this.titulo, this.icono, this.vista);

  final String titulo;
  final IconData icono;
  final Widget vista;
}

class InicioShell extends ConsumerStatefulWidget {
  const InicioShell({
    super.key,
    required this.destinos,
    required this.onCerrarSesion,
  });

  final List<Destino> destinos;
  final VoidCallback onCerrarSesion;

  @override
  ConsumerState<InicioShell> createState() => _InicioShellState();
}

class _InicioShellState extends ConsumerState<InicioShell> {
  int _indice = 0;

  void _cambiar(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    final destinos = widget.destinos;
    final contenido = IndexedStack(
      index: _indice,
      children: [for (final d in destinos) d.vista],
    );

    if (ResponsiveLayout.isDesktop(context)) {
      final nombre = ref.watch(usuarioActualProvider)?.nombres;
      return Scaffold(
        body: Column(
          children: [
            _barraSuperior(context, nombre),
            Expanded(child: contenido),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(destinos[_indice].titulo),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: widget.onCerrarSesion,
          ),
        ],
      ),
      body: contenido,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _cambiar,
        destinations: [
          for (final d in destinos)
            NavigationDestination(icon: Icon(d.icono), label: d.titulo),
        ],
      ),
    );
  }

  Widget _barraSuperior(BuildContext context, String? nombre) {
    final textos = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Colores.tarjeta,
        border: Border(bottom: BorderSide(color: Colores.linea)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Espacios.xl),
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colores.primario,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.build_rounded,
                      size: 20,
                      color: Colores.tarjeta,
                    ),
                  ),
                  const SizedBox(width: Espacios.s + 2),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ChauchaApp', style: textos.titleMedium),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colores.primario,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Quito, EC',
                            style: textos.labelSmall?.copyWith(
                              color: Colores.info,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: Espacios.xl),
                  for (var i = 0; i < widget.destinos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: Espacios.xs),
                      child: _Pestana(
                        titulo: widget.destinos[i].titulo,
                        activa: i == _indice,
                        onTap: () => _cambiar(i),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(left: Espacios.m),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colores.linea)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colores.primario,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 18,
                            color: Colores.tarjeta,
                          ),
                        ),
                        if (nombre != null) ...[
                          const SizedBox(width: Espacios.s + 2),
                          Text(
                            nombre,
                            style: textos.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        IconButton(
                          tooltip: 'Cerrar sesión',
                          icon: const Icon(Icons.logout, size: 20),
                          onPressed: widget.onCerrarSesion,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pestana extends StatelessWidget {
  const _Pestana({
    required this.titulo,
    required this.activa,
    required this.onTap,
  });

  final String titulo;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activa ? Colores.primarioSuave : Colors.transparent,
      borderRadius: BorderRadius.circular(Radios.pequeno),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.pequeno),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.l,
            vertical: Espacios.s + 2,
          ),
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: activa ? Colores.primario : Colores.tintaSuave,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}