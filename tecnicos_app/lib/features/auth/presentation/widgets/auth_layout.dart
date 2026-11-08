// Marco común de login y registro: fondo celeste con degradado y una tarjeta
// blanca con la marca, el título y el formulario. En escritorio agrega a la
// izquierda un panel azul con la marca y los beneficios de la app.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/encabezado_pantalla.dart';
import '../../../../core/widgets/marca.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/tarjeta_app.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.titulo,
    required this.child,
    this.subtitulo,
    this.tituloCentrado = false,
  });

  static const double _anchoMaximoTarjeta = 460;

  final String titulo;
  final String? subtitulo;
  final bool tituloCentrado;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget tarjeta({required bool conMarca}) => _Tarjeta(
      titulo: titulo,
      subtitulo: subtitulo,
      tituloCentrado: tituloCentrado,
      conMarca: conMarca,
      child: child,
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colores.primarioSuave, Colores.fondo, Colores.superficie],
          ),
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            mobile: tarjeta(conMarca: true),
            desktop: Row(
              children: [
                const Expanded(child: _PanelMarca()),
                Expanded(child: tarjeta(conMarca: false)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({
    required this.titulo,
    required this.subtitulo,
    required this.tituloCentrado,
    required this.conMarca,
    required this.child,
  });

  final String titulo;
  final String? subtitulo;
  final bool tituloCentrado;
  final bool conMarca;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.l,
          vertical: Espacios.xl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AuthLayout._anchoMaximoTarjeta,
          ),
          child: TarjetaApp(
            radio: Radios.muyGrande,
            padding: const EdgeInsets.fromLTRB(
              Espacios.xl,
              Espacios.xxl,
              Espacios.xl,
              Espacios.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (conMarca) ...[
                  const Marca.vertical(),
                  const SizedBox(height: Espacios.xl),
                ],
                EncabezadoPantalla(
                  titulo: titulo,
                  subtitulo: subtitulo,
                  centrado: tituloCentrado,
                  grande: tituloCentrado,
                ),
                const SizedBox(height: Espacios.xl),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelMarca extends StatelessWidget {
  const _PanelMarca();

  static const _beneficios = [
    (
      Icons.verified_user_outlined,
      'Técnicos verificados',
      'Revisamos la identidad de cada técnico.',
    ),
    (
      Icons.request_quote_outlined,
      'Cotizaciones claras',
      'Compara precios antes de contratar.',
    ),
    (
      Icons.chat_bubble_outline,
      'Chat directo',
      'Coordina todo el trabajo desde la app.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colores.primario, Colores.primarioOscuro],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Marca(grande: true, sobreOscuro: true),
                const SizedBox(height: Espacios.xxl),
                Text(
                  Marca.lema,
                  style: textos.headlineMedium?.copyWith(color: blanco),
                ),
                const SizedBox(height: Espacios.xxl),
                for (final (icono, titulo, texto) in _beneficios)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Espacios.l + 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconoRecuadro(
                          icono: icono,
                          lado: 44,
                          color: blanco,
                          fondo: blanco.withValues(alpha: 0.16),
                        ),
                        const SizedBox(width: Espacios.l),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                style: textos.titleMedium?.copyWith(
                                  color: blanco,
                                ),
                              ),
                              Text(
                                texto,
                                style: textos.bodyMedium?.copyWith(
                                  color: blanco.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
