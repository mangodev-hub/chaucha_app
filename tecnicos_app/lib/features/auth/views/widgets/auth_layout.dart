// Marco común de login y registro 
import 'package:flutter/material.dart';

import '../../../../core/widgets/responsive_layout.dart';



class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.titulo, required this.child});

  static const double _anchoMaximoFormulario = 440;

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final formulario = _Formulario(titulo: titulo, child: child);
    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: formulario,
          desktop: Row(
            children: [
              const Expanded(child: _PanelMarca()),
              Expanded(child: formulario),
            ],
          ),
        ),
      ),
    );
  }
}

class _Formulario extends StatelessWidget {
  const _Formulario({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AuthLayout._anchoMaximoFormulario,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(titulo, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelMarca extends StatelessWidget {
  const _PanelMarca();

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colores.primary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Text(
            'Técnicos a domicilio en Quito',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: colores.onPrimary),
          ),
        ),
      ),
    );
  }
}
