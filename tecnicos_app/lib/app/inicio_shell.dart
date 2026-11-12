// Shell del inicio: pestañas fijas abajo en móvil (como Facebook: siempre
// visibles, con insignias y una acción principal al centro) y pestañas en
// la barra superior en escritorio. Las vistas se mantienen montadas en un
// IndexedStack.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/core_providers.dart';
import '../core/providers/sincronizacion_provider.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/hoja_clara.dart';
import '../core/widgets/marca.dart';
import '../core/widgets/responsive_layout.dart';
import '../features/notificaciones/presentation/providers/notificaciones_provider.dart';
import '../features/notificaciones/presentation/widgets/escucha_notificaciones.dart';
import '../features/notificaciones/presentation/widgets/punto_no_leidas.dart';
import 'encabezado_saludo.dart';
import 'menu_cuenta.dart';
import 'pestana_solicitada.dart';

class Destino {
  const Destino(
    this.titulo,
    this.icono,
    this.vista, {
    this.iconoActivo,
    this.corto,
    this.tiposNotificacion = const [],
    this.marcaAlEntrar = true,
    this.saludo,
  });

  /// Título completo: barra superior y pestañas de escritorio.
  final String titulo;

  /// Línea bajo "Hola, Nombre". Si no es null, en móvil la pestaña lleva el
  /// saludo (`EncabezadoSaludo`, con el menú de la cuenta en el avatar) en
  /// lugar de la barra superior.
  final String? saludo;
  final IconData icono;

  /// Versión rellena del ícono para la pestaña elegida.
  final IconData? iconoActivo;

  /// Etiqueta corta para la barra inferior del móvil (si no, [titulo]).
  final String? corto;
  final List<String> tiposNotificacion;
  final Widget vista;
  final bool marcaAlEntrar;

  String get etiqueta => corto ?? titulo;
}

/// Acción principal del shell ("Pedir un técnico"): en móvil es el botón
/// redondo al centro de la barra inferior; en escritorio, un botón en la
/// barra superior. Abre [ruta].
class AccionCentral {
  const AccionCentral({
    required this.etiqueta,
    required this.icono,
    required this.ruta,
    this.corto,
  });

  final String etiqueta;

  /// Etiqueta corta bajo el botón redondo (si no, [etiqueta]).
  final String? corto;
  final IconData icono;
  final String ruta;

  String get etiquetaCorta => corto ?? etiqueta;
}

class InicioShell extends ConsumerStatefulWidget {
  const InicioShell({
    super.key,
    required this.destinos,
    required this.onCerrarSesion,
    this.accionCentral,
    this.rutaAgenda,
  });

  final List<Destino> destinos;
  final VoidCallback onCerrarSesion;
  final AccionCentral? accionCentral;

  /// Si la agenda no es una pestaña (cliente), se abre desde el menú de la
  /// cuenta con esta ruta.
  final String? rutaAgenda;

  @override
  ConsumerState<InicioShell> createState() => _InicioShellState();
}

class _InicioShellState extends ConsumerState<InicioShell> {
  int _indice = 0;

  void _cambiar(int indice) {
    setState(() => _indice = indice);
    final destino = widget.destinos[indice];
    if (destino.tiposNotificacion.isEmpty || !destino.marcaAlEntrar) return;
    final tipos = destino.tiposNotificacion;
    final uid = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (uid == null) return;
    unawaited(
      ref.read(notificacionesRepoProvider).marcarLeidas(uid, tipos: tipos),
    );
  }

  // Solo hay "Mi perfil" para cliente y técnico (el admin no tiene).
  int get _indicePerfil =>
      widget.destinos.indexWhere((d) => d.titulo == 'Mi perfil');

  VoidCallback? get _alPerfil =>
      _indicePerfil < 0 ? null : () => _cambiar(_indicePerfil);

  VoidCallback? get _aLaAgenda {
    final ruta = widget.rutaAgenda;
    return ruta == null ? null : () => context.push(ruta);
  }

  void _accion() {
    final accion = widget.accionCentral;
    if (accion != null) context.push(accion.ruta);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sincronizacionProvider);
    ref.listen(pestanaSolicitadaProvider, (_, titulo) {
      if (titulo == null) return;
      final i = widget.destinos.indexWhere((d) => d.titulo == titulo);
      if (i >= 0) _cambiar(i);
      ref.read(pestanaSolicitadaProvider.notifier).limpiar();
    });
    return EscuchaNotificaciones(child: _contenido(context));
  }

  Widget _contenido(BuildContext context) {
    final destinos = widget.destinos;
    final escritorio = ResponsiveLayout.isDesktop(context);
    // Sobre el fondo oscuro nada va suelto: cada pestaña vive en la gran
    // hoja clara.
    final contenido = IndexedStack(
      index: _indice,
      children: [
        for (final d in destinos) _Pagina(destino: d, escritorio: escritorio),
      ],
    );

    if (escritorio) {
      return Scaffold(
        body: Column(
          children: [
            _barraSuperior(context),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Padding(
                    padding: const EdgeInsets.only(top: Espacios.s),
                    child: contenido,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final actual = destinos[_indice];
    return Scaffold(
      appBar: actual.saludo != null
          ? null
          : AppBar(
              title: Text(actual.titulo),
              actions: [
                MenuCuenta(
                  compacto: true,
                  onPerfil: _alPerfil,
                  onAgenda: _aLaAgenda,
                  onCerrarSesion: widget.onCerrarSesion,
                ),
                const SizedBox(width: Espacios.s),
              ],
            ),
      body: SafeArea(
        bottom: false,
        child: AccionesShell(
          onCerrarSesion: widget.onCerrarSesion,
          onPerfil: _alPerfil,
          onAgenda: _aLaAgenda,
          child: contenido,
        ),
      ),
      bottomNavigationBar: _BarraInferior(
        destinos: destinos,
        indice: _indice,
        onCambio: _cambiar,
        accion: widget.accionCentral,
        onAccion: _accion,
      ),
    );
  }

  Widget _barraSuperior(BuildContext context) {
    final accion = widget.accionCentral;
    return ColoredBox(
      color: Colores.fondo,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Espacios.xl),
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  const Marca(sobreOscuro: true),
                  const SizedBox(width: Espacios.xl),
                  for (var i = 0; i < widget.destinos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: Espacios.xs),
                      child: _Pestana(
                        titulo: widget.destinos[i].titulo,
                        tipos: widget.destinos[i].tiposNotificacion,
                        activa: i == _indice,
                        onTap: () => _cambiar(i),
                      ),
                    ),
                  const Spacer(),
                  if (accion != null) ...[
                    FilledButton.icon(
                      onPressed: _accion,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 44),
                      ),
                      icon: Icon(accion.icono),
                      label: Text(accion.etiqueta),
                    ),
                    const SizedBox(width: Espacios.m),
                  ],
                  Container(
                    padding: const EdgeInsets.only(left: Espacios.m),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colores.sobreOscuro.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: MenuCuenta(
                      sobreOscuro: true,
                      onPerfil: _alPerfil,
                      onAgenda: _aLaAgenda,
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
    required this.tipos,
    required this.activa,
    required this.onTap,
  });

  final String titulo;
  final List<String> tipos;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duracion = Movimiento.de(context, Movimiento.normal);
    final borde = BorderRadius.circular(Radios.pildora);
    // El fondo y el color del texto cambian con una transición.
    return AnimatedContainer(
      duration: duracion,
      curve: Movimiento.entrada,
      decoration: BoxDecoration(
        color: activa ? Colores.lienzo : Colores.lienzo.withValues(alpha: 0),
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
                        color: activa
                            ? Colores.primario
                            : Colores.sobreOscuro.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w700,
                      ),
              child: PuntoNoLeidas(tipos: tipos, child: Text(titulo)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Barra de pestañas del móvil: superficie clara con las esquinas de arriba
/// muy redondeadas y una onda celeste suave. Si hay [accion], va como botón
/// redondo verde al centro, un poco por encima de la barra.
class _BarraInferior extends StatelessWidget {
  const _BarraInferior({
    required this.destinos,
    required this.indice,
    required this.onCambio,
    required this.accion,
    required this.onAccion,
  });

  final List<Destino> destinos;
  final int indice;
  final ValueChanged<int> onCambio;
  final AccionCentral? accion;
  final VoidCallback onAccion;

  @override
  Widget build(BuildContext context) {
    final accion = this.accion;
    final mitad = destinos.length ~/ 2;
    final items = <Widget>[
      for (var i = 0; i < destinos.length; i++) ...[
        if (accion != null && i == mitad)
          _BotonCentral(accion: accion, onTap: onAccion),
        Expanded(
          child: _ItemBarra(
            destino: destinos[i],
            activo: i == indice,
            onTap: () => onCambio(i),
          ),
        ),
      ],
    ];

    // Con textos muy grandes la barra crecería demasiado: se limita la
    // escala, como hace la barra de Material.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: CustomPaint(
        // La forma se pinta (no se recorta) para que el botón central pueda
        // sobresalir por arriba.
        painter: const _FondoBarra(),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Espacios.s,
              Espacios.xs,
              Espacios.s,
              Espacios.xs,
            ),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fondo de la barra inferior: superficie clara con las esquinas de arriba
/// redondeadas y una onda celeste suave que entra por la derecha.
class _FondoBarra extends CustomPainter {
  const _FondoBarra();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final forma = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: const Radius.circular(Radios.hoja),
      topRight: const Radius.circular(Radios.hoja),
    );
    canvas
      ..drawRRect(forma, Paint()..color = Colores.lienzo)
      ..save()
      ..clipRRect(forma);
    final onda = Path()
      ..moveTo(w * 0.38, h)
      ..cubicTo(w * 0.55, h * 0.55, w * 0.72, h * 0.95, w * 0.86, h * 0.35)
      ..cubicTo(w * 0.92, h * 0.12, w * 0.97, h * 0.1, w, h * 0.12)
      ..lineTo(w, h)
      ..close();
    canvas
      ..drawPath(
        onda,
        Paint()..color = Colores.cieloClaro.withValues(alpha: 0.18),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_FondoBarra anterior) => false;
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
    // Activo en verde oscuro; inactivos con el ícono celeste.
    final colorIcono = activo
        ? Colores.primario
        : Colores.cielo.withValues(alpha: 0.7);
    final colorTexto = activo ? Colores.primario : Colores.tintaSuave;
    return Semantics(
      container: true,
      button: true,
      selected: activo,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.subtarjeta),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Espacios.s + 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PuntoNoLeidas(
                tipos: destino.tiposNotificacion,
                child: activo
                    ? _IconoActivo(
                        destino.iconoActivo ?? destino.icono,
                        color: colorIcono,
                      )
                    : Icon(destino.icono, color: colorIcono),
              ),
              const SizedBox(height: Espacios.xs),
              AnimatedDefaultTextStyle(
                duration: Movimiento.de(context, Movimiento.normal),
                curve: Movimiento.entrada,
                style:
                    (Theme.of(context).textTheme.labelMedium ??
                            const TextStyle())
                        .copyWith(
                          color: colorTexto,
                          fontWeight: activo
                              ? FontWeight.w800
                              : FontWeight.w600,
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

/// Botón redondo verde al centro de la barra, con su etiqueta debajo. Sube
/// un poco por encima del borde de la barra.
class _BotonCentral extends StatelessWidget {
  const _BotonCentral({required this.accion, required this.onTap});

  final AccionCentral accion;
  final VoidCallback onTap;

  static const double _lado = 58;

  @override
  Widget build(BuildContext context) {
    // El InkWell aporta las acciones (tocar, foco) al nodo semántico; el
    // texto de adentro se excluye porque la etiqueta ya lo dice.
    return Semantics(
      container: true,
      button: true,
      label: accion.etiqueta,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.medio),
        child: ExcludeSemantics(
          child: SizedBox(
            width: 76,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -Espacios.m),
                  child: Container(
                    width: _lado,
                    height: _lado,
                    // Aro claro para separarlo del fondo oscuro cuando
                    // sobresale de la barra.
                    decoration: BoxDecoration(
                      color: Colores.primario,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colores.lienzo, width: 4),
                    ),
                    child: Icon(
                      accion.icono,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -Espacios.s),
                  child: Text(
                    accion.etiquetaCorta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colores.primario,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
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

/// Una pestaña del shell. Con [Destino.saludo], en móvil va el saludo arriba
/// sobre el fondo oscuro; el contenido siempre va en la hoja clara.
class _Pagina extends StatelessWidget {
  const _Pagina({required this.destino, required this.escritorio});

  final Destino destino;
  final bool escritorio;

  @override
  Widget build(BuildContext context) {
    final saludo = destino.saludo;
    final hoja = HojaClara(child: destino.vista);
    if (saludo == null || escritorio) return hoja;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacios.l,
            Espacios.m,
            Espacios.l,
            Espacios.m,
          ),
          child: EncabezadoSaludo(subtitulo: saludo),
        ),
        Expanded(child: hoja),
      ],
    );
  }
}
