import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../core/widgets/responsive_layout.dart';
import 'menu_cuenta.dart';

class Destino {
  const Destino(
    this.titulo,
    this.icono,
    this.vista, {
    this.iconoActivo,
    this.corto,
  });

  /// Título completo: barra superior y pestañas de escritorio.
  final String titulo;
  final IconData icono;

  /// Versión rellena del ícono para la pestaña elegida.
  final IconData? iconoActivo;

  /// Etiqueta corta para la barra flotante del móvil (si no, [titulo]).
  final String? corto;
  final Widget vista;

  String get etiqueta => corto ?? titulo;
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

  // Solo hay "Mi perfil" para cliente y técnico (el admin no tiene).
  int get _indicePerfil =>
      widget.destinos.indexWhere((d) => d.titulo == 'Mi perfil');

  VoidCallback? get _alPerfil =>
      _indicePerfil < 0 ? null : () => _cambiar(_indicePerfil);

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
            onPerfil: _alPerfil,
            onCerrarSesion: widget.onCerrarSesion,
          ),
          const SizedBox(width: Espacios.s),
        ],
      ),
      body: contenido,
      bottomNavigationBar: _BarraFlotante(
        destinos: destinos,
        indice: _indice,
        onCambio: _cambiar,
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
                  Container(
                    padding: const EdgeInsets.only(left: Espacios.m),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colores.linea)),
                    ),
                    child: MenuCuenta(
                      onPerfil: _alPerfil,
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
    // El fondo y el color del texto cambian con una transición.
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
              style:
                  (Theme.of(context).textTheme.labelLarge ?? const TextStyle())
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

/// Barra de pestañas del móvil: una píldora blanca que flota sobre el fondo
/// celeste, separada de los bordes. El contenido no pasa por detrás, así que
/// ninguna lista queda tapada.
class _BarraFlotante extends StatelessWidget {
  const _BarraFlotante({
    required this.destinos,
    required this.indice,
    required this.onCambio,
  });

  final List<Destino> destinos;
  final int indice;
  final ValueChanged<int> onCambio;

  @override
  Widget build(BuildContext context) {
    // Con textos muy grandes la píldora crecería demasiado: se limita la
    // escala, como hace la barra de Material.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: Espacios.m),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacios.l,
            Espacios.xs,
            Espacios.l,
            0,
          ),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Espacios.s,
                  vertical: Espacios.s - 2,
                ),
                decoration: BoxDecoration(
                  color: Colores.tarjeta,
                  borderRadius: BorderRadius.circular(Radios.pildora),
                  boxShadow: Sombras.suave,
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < destinos.length; i++)
                      Expanded(
                        child: _ItemBarra(
                          destino: destinos[i],
                          activo: i == indice,
                          onTap: () => onCambio(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemBarra extends StatelessWidget {
  const _ItemBarra({
    required this.destino,
    required this.activo,
    required this.onTap,
  });

  final Destino destino;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = activo ? Colores.primario : Colores.tintaSuave;
    return Semantics(
      container: true,
      button: true,
      selected: activo,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Espacios.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activo)
                _IconoActivo(destino.iconoActivo ?? destino.icono, color: color)
              else
                Icon(destino.icono, color: color),
              const SizedBox(height: Espacios.xs),
              AnimatedDefaultTextStyle(
                duration: Movimiento.de(context, Movimiento.normal),
                curve: Movimiento.entrada,
                style:
                    (Theme.of(context).textTheme.labelMedium ??
                            const TextStyle())
                        .copyWith(
                          color: color,
                          fontWeight: activo
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                child: Text(
                  destino.etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconoActivo extends StatelessWidget {
  const _IconoActivo(this.icono, {required this.color});

  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: Movimiento.de(context, Movimiento.normal),
      curve: Movimiento.rebote,
      builder: (context, escala, child) =>
          Transform.scale(scale: escala, child: child),
      child: Icon(icono, color: color),
    );
  }
}