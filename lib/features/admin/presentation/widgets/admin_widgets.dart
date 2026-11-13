// Piezas comunes de las pantallas del panel de administrador.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/encabezado_pantalla.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/seccion.dart';

/// Pantalla del panel: título, acción opcional, filtros y contenido, con
/// "deslizar para recargar" y ancho máximo en escritorio.
class PantallaAdmin extends StatelessWidget {
  const PantallaAdmin({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.onRecargar,
    required this.children,
    this.accion,
    this.filtros = const [],
  });

  final String titulo;
  final String subtitulo;
  final Future<void> Function() onRecargar;

  /// Botón a la derecha del título (por ejemplo "Nuevo usuario").
  final Widget? accion;

  /// Buscador y filtros, debajo del título.
  final List<Widget> filtros;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final escritorio = ResponsiveLayout.isDesktop(context);
    final accion = this.accion;
    final encabezado = EncabezadoPantalla(titulo: titulo, subtitulo: subtitulo);
    // En la web clara la página ya tiene scroll: aquí va sin el suyo.
    final dentroDeWeb = ScrollDePagina.activo(context);
    return RefreshIndicator(
      onRefresh: onRecargar,
      child: ListaDePagina(
        padding: dentroDeWeb
            ? EdgeInsets.zero
            : EdgeInsets.all(escritorio ? Espacios.xl : Espacios.l),
        children: [
          AnchoMaximo(
            ancho: 1100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (accion == null)
                  encabezado
                else
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: Espacios.l,
                    runSpacing: Espacios.m,
                    children: [encabezado, accion],
                  ),
                for (final filtro in filtros) ...[
                  const SizedBox(height: Espacios.m),
                  filtro,
                ],
                const SizedBox(height: Espacios.l),
                ...children,
                const SizedBox(height: Espacios.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo de búsqueda con lupa.
class BuscadorAdmin extends StatelessWidget {
  const BuscadorAdmin({super.key, required this.hint, required this.onCambio});

  final String hint;
  final ValueChanged<String> onCambio;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onCambio,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
