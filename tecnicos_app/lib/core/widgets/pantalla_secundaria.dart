// Pantalla que se abre encima de las pestañas (detalle, chat, perfil de otra
// persona, agenda, reclamos...).
//
// - En la web del cliente la ruta se dibuja dentro de la estructura web (la
//   barra superior blanca, el menú lateral y el pie; ver `InicioShell`), que
//   la marca con [EstructuraWeb]. Aquí solo va la ruta de navegación
//   "‹ Volver / Título" y el contenido, sobre el mismo fondo claro.
// - En un teléfono: una AppBar clara, sin sombra, con la flecha atrás.
// - En pantallas anchas sin estructura (técnico, asesor): fondo claro y la
//   ruta de navegación arriba.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../theme/tokens.dart';
import 'scroll_pagina.dart';

/// Marca que la pantalla secundaria va dentro de la estructura web.
/// [llena]: la pantalla ocupa el alto visible y maneja su propio scroll
/// (chat, reclamo con su campo de respuesta). Si no, va en el scroll único
/// de la página ([ScrollDePagina]).
class EstructuraWeb extends InheritedWidget {
  const EstructuraWeb({super.key, required this.llena, required super.child});

  final bool llena;

  static EstructuraWeb? de(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EstructuraWeb>();

  @override
  bool updateShouldNotify(EstructuraWeb anterior) => anterior.llena != llena;
}

class PantallaSecundaria extends StatelessWidget {
  const PantallaSecundaria({
    super.key,
    required this.titulo,
    required this.cuerpo,
    this.acciones = const [],
    this.barraInferior,
    this.conMigas = true,
    this.color = Colores.fondoClaro,
  });

  /// Título de la AppBar (móvil) y último tramo de la ruta de navegación.
  final String titulo;

  /// El contenido. Dentro de la estructura web (sin [EstructuraWeb.llena])
  /// no debe tener scroll propio: usar `ListaDePagina` o `ScrollOpcional`.
  final Widget cuerpo;

  /// Botones de la AppBar del móvil.
  final List<Widget> acciones;

  /// Barra fija abajo (botón principal en el móvil).
  final Widget? barraInferior;

  /// Sin ruta de navegación: el contenido trae la suya.
  final bool conMigas;
  final Color color;

  /// Ancho desde el que no hay AppBar sino ruta de navegación (el mismo del
  /// menú lateral del shell).
  static const double anchoWeb = 700;

  @override
  Widget build(BuildContext context) {
    final estructura = EstructuraWeb.de(context);
    final migas = conMigas ? MigasPantalla(titulo: titulo) : null;

    if (estructura != null) {
      if (!estructura.llena) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [?migas, cuerpo, ?barraInferior],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?migas,
          Expanded(child: cuerpo),
          ?barraInferior,
        ],
      );
    }

    if (MediaQuery.sizeOf(context).width >= anchoWeb) {
      return Scaffold(
        backgroundColor: color,
        bottomNavigationBar: barraInferior,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (migas != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Espacios.xl),
                  child: migas,
                ),
              Expanded(child: cuerpo),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: Colores.fondoClaro,
        foregroundColor: Colores.tintaTitulo,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colores.tintaTitulo),
        actionsIconTheme: const IconThemeData(color: Colores.tintaTitulo),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colores.tintaTitulo,
        ),
        title: Text(titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: acciones.isEmpty
            ? null
            : [...acciones, const SizedBox(width: Espacios.xs)],
      ),
      bottomNavigationBar: barraInferior,
      body: cuerpo,
    );
  }
}

/// "‹ Volver / Título": vuelve a la pantalla anterior o, si se entró por un
/// enlace directo, al inicio del rol.
class MigasPantalla extends StatefulWidget {
  const MigasPantalla({super.key, required this.titulo});

  final String titulo;

  @override
  State<MigasPantalla> createState() => _MigasPantallaState();
}

class _MigasPantallaState extends State<MigasPantalla> {
  bool _encima = false;

  void _volver() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final ruta = GoRouterState.of(context).uri.path;
    context.go(
      ruta.startsWith(AppRoutes.tecnicoInicio)
          ? AppRoutes.tecnicoInicio
          : ruta.startsWith(AppRoutes.adminInicio)
          ? AppRoutes.adminInicio
          : AppRoutes.clienteInicio,
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13);
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _encima = true),
            onExit: (_) => setState(() => _encima = false),
            child: Semantics(
              button: true,
              label: 'Volver',
              excludeSemantics: true,
              child: GestureDetector(
                onTap: _volver,
                child: Text(
                  '‹ Volver',
                  style: base?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _encima ? Colores.primario : Colores.tintaGris,
                  ),
                ),
              ),
            ),
          ),
          Text(
            ' / ',
            style: base?.copyWith(
              color: Colores.tintaGris.withValues(alpha: 0.45),
            ),
          ),
          Text(
            widget.titulo,
            style: base?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colores.tintaTitulo,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scroll de una pantalla con contenido fijo (formulario, detalle): un
/// `SingleChildScrollView`, o nada dentro del scroll único de la página.
class ScrollOpcional extends StatelessWidget {
  const ScrollOpcional({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => ScrollDePagina.activo(context)
      ? Padding(padding: padding, child: child)
      : SingleChildScrollView(padding: padding, child: child);
}
