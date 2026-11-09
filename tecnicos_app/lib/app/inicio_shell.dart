import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../core/widgets/responsive_layout.dart';
import 'menu_cuenta.dart';

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
    this.accion,
  });

  final List<Destino> destinos;
  final VoidCallback onCerrarSesion;

  final Widget? accion;

  @override
  ConsumerState<InicioShell> createState() => _InicioShellState();
}

class _InicioShellState extends ConsumerState<InicioShell> {
  int _indice = 0;

  void _cambiar(int indice) => setState(() => _indice = indice);

  void _irAPerfil() => _cambiar(widget.destinos.length - 1);

  @override
  Widget build(BuildContext context) {
    final destinos = widget.destinos;
    final contenido = IndexedStack(
      index: _indice,
      children: [for (final d in destinos) d.vista],
    );

    if (ResponsiveLayout.isDesktop(context)) {
      return Scaffold(
        body: Column(
          children: [
            _barraSuperior(context),
            Expanded(child: contenido),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(destinos[_indice].titulo),
        actions: [
          MenuCuenta(
            compacto: true,
            onPerfil: _irAPerfil,
            onCerrarSesion: widget.onCerrarSesion,
          ),
          const SizedBox(width: Espacios.s),
        ],
      ),
      body: contenido,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _cambiar,
        destinations: [
          for (final d in destinos)
            NavigationDestination(
              icon: Icon(d.icono),
              selectedIcon: _IconoActivo(d.icono),
              label: d.titulo,
            ),
        ],
      ),
    );
  }

  Widget _barraSuperior(BuildContext context) {
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
                  if (widget.accion != null) ...[
                    widget.accion!,
                    const SizedBox(width: Espacios.l),
                  ],
                  Container(
                    padding: const EdgeInsets.only(left: Espacios.m),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colores.linea)),
                    ),
                    child: MenuCuenta(
                      onPerfil: _irAPerfil,
                      onCerrarSesion: widget.onCerrarSesion,
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
    final duracion = Movimiento.de(context, Movimiento.normal);
    final borde = BorderRadius.circular(Radios.pequeno);
    return AnimatedContainer(
      duration: duracion,
      curve: Movimiento.entrada,
      decoration: BoxDecoration(
        color: activa
            ? Colores.primarioSuave
            : Colores.primarioSuave.withValues(alpha: 0),
        borderRadius: borde,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: borde,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Espacios.l,
              vertical: Espacios.s + 2,
            ),
            child: AnimatedDefaultTextStyle(
              duration: duracion,
              style: (Theme.of(context).textTheme.labelLarge ??
                      const TextStyle())
                  .copyWith(
                    color: activa ? Colores.primario : Colores.tintaSuave,
                    fontWeight: FontWeight.w700,
                  ),
              child: Text(titulo),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconoActivo extends StatelessWidget {
  const _IconoActivo(this.icono);

  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: Movimiento.de(context, Movimiento.normal),
      curve: Movimiento.rebote,
      builder: (context, escala, child) =>
          Transform.scale(scale: escala, child: child),
      child: Icon(icono),
    );
  }
}