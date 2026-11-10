// Marco común de login y registro: fondo celeste con degradado y una tarjeta
// blanca con la marca, el título y el formulario. En escritorio agrega a la
// izquierda un panel azul con la marca.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.anchoEscritorio = 400,
    this.esRegistro = false,
    this.panelDetallado = false,
  });

  static const double _anchoMaximoTarjeta = 460;

  final String titulo;
  final String? subtitulo;
  final bool tituloCentrado;
  final double anchoEscritorio;

  /// En escritorio: panel azul con beneficios y título alineado a la izquierda.
  final bool esRegistro;
  final bool panelDetallado;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colores.primarioSuave,
                Colores.fondo,
                Colores.superficie,
              ],
            ),
          ),
          child: SafeArea(
            child: _Tarjeta(
              titulo: titulo,
              subtitulo: subtitulo,
              tituloCentrado: tituloCentrado,
              conMarca: true,
              child: child,
            ),
          ),
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _PanelMarca(detallado: esRegistro || panelDetallado),
            ),
            Expanded(
              child: _FormularioEscritorio(
                titulo: titulo,
                subtitulo: subtitulo,
                ancho: anchoEscritorio,
                centrado: !esRegistro,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormularioEscritorio extends StatelessWidget {
  const _FormularioEscritorio({
    required this.titulo,
    required this.subtitulo,
    required this.ancho,
    required this.centrado,
    required this.child,
  });

  final String titulo;
  final String? subtitulo;
  final double ancho;
  final bool centrado;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colores.tarjeta,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Espacios.xxl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ancho),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EncabezadoPantalla(
                  titulo: titulo,
                  subtitulo: subtitulo,
                  centrado: centrado,
                  grande: true,
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
  const _PanelMarca({this.detallado = false});

  final bool detallado;

  static const _beneficios = [
    (
      Icons.verified_user_outlined,
      'Técnicos verificados',
      'Revisamos su identidad antes de activarlos',
    ),
    (
      Icons.local_offer_outlined,
      'Ofertas claras',
      'Precio base y cómo resolverá tu problema',
    ),
    (
      Icons.chat_bubble_outline,
      'Chat directo',
      'Coordina el trabajo desde la app',
    ),
  ];

  Text _titular(TextStyle? estilo) => Text.rich(
    const TextSpan(
      children: [
        TextSpan(text: 'Técnicos de '),
        TextSpan(
          text: 'confianza',
          style: TextStyle(color: Colores.primarioClaro),
        ),
        TextSpan(text: ' a tu puerta en Quito.'),
      ],
    ),
    style: estilo?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
  );

  Widget _beneficio(
    TextTheme textos,
    IconData icono,
    String titulo,
    String texto,
  ) {
    return Container(
      padding: const EdgeInsets.all(Espacios.m),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radios.medio),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: Colors.white, size: 20),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: textos.titleSmall?.copyWith(color: Colors.white),
                ),
                Text(
                  texto,
                  style: textos.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenidoDetallado(TextTheme textos) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _titular(textos.headlineMedium),
            const SizedBox(height: Espacios.m),
            Text(
              'Conectamos hogares con técnicos de oficios de tu zona.',
              style: textos.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: Espacios.xl),
            for (final (icono, titulo, texto) in _beneficios) ...[
              _beneficio(textos, icono, titulo, texto),
              const SizedBox(height: Espacios.m),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colores.primarioProfundo, Colores.primarioVivo],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Marca(grande: true, sobreOscuro: true),
            ),
            Expanded(
              child: Center(
                child: detallado
                    ? _contenidoDetallado(textos)
                    : _titular(textos.displaySmall),
              ),
            ),
              LayoutBuilder(
                builder: (context, c) => SvgPicture.asset(
                  'assets/img/tecnicos.svg',
                  width: c.maxWidth,
                  height: c.maxWidth * 160 / 460,
                  fit: BoxFit.contain,
                ),
              ),
          ],
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
