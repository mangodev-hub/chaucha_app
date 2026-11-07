// Marco común de login y registro: marca, título grande y formulario.
// En escritorio agrega un panel oscuro con la marca a la izquierda.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/marca.dart';
import '../../../../core/widgets/responsive_layout.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.titulo, required this.child});

  static const double _anchoMaximoFormulario = 440;

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _Formulario(titulo: titulo, conMarca: true, child: child),
          desktop: Row(
            children: [
              const Expanded(child: _PanelMarca()),
              Expanded(
                child: _Formulario(titulo: titulo, conMarca: false, child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Formulario extends StatelessWidget {
  const _Formulario({
    required this.titulo,
    required this.conMarca,
    required this.child,
  });

  final String titulo;
  final bool conMarca;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Espacios.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AuthLayout._anchoMaximoFormulario,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (conMarca) ...[
                const Align(alignment: Alignment.centerLeft, child: Marca()),
                const SizedBox(height: Espacios.xxl),
              ],
              Text(titulo, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: Espacios.xl),
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
    final textos = Theme.of(context).textTheme;
    return ColoredBox(
      color: Colores.tinta,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Marca(grande: true, sobreOscuro: true),
              const SizedBox(height: Espacios.xl),
              Text(
                'Técnicos de confianza cerca de ti, en Quito.',
                style: textos.headlineMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
