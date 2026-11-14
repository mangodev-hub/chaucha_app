import 'package:flutter/material.dart';

class ScrollDePagina extends InheritedWidget {
  const ScrollDePagina({super.key, required super.child});

  static bool activo(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollDePagina>() != null;

  @override
  bool updateShouldNotify(ScrollDePagina anterior) => false;
}

/// Lista de una pestaña: un `ListView` (con deslizar para recargar si hay
/// [onRefresh]) o, dentro de [ScrollDePagina], una columna sin scroll.
class ListaDePagina extends StatelessWidget {
  const ListaDePagina({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.onRefresh,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (ScrollDePagina.activo(context)) {
      return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
    }
    final lista = ListView(padding: padding, children: children);
    final onRefresh = this.onRefresh;
    return onRefresh == null
        ? lista
        : RefreshIndicator(onRefresh: onRefresh, child: lista);
  }
}
