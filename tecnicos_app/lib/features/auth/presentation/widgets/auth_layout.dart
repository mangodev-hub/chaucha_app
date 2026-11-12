// Marco común de login y registro: fondo verde bosque con una onda celeste
// suave y una tarjeta clara con la marca, el título y el formulario. En
// escritorio agrega a la izquierda un panel verde con la marca, que termina
// en un borde ondulado (dos curvas que ondulan despacio) sobre el formulario.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/animacion_lottie.dart';
import '../../../../core/widgets/encabezado_pantalla.dart';
import '../../../../core/widgets/marca.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_onda.dart';

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
    this.animacionEscritorio,
    this.animacionMovil,
    this.tramoAnimacion,
  });

  static const double _anchoMaximoTarjeta = 460;

  /// Caja visible (ancho / alto) de `tecnico.json`, el técnico que saluda en
  /// el panel de escritorio: recorta el margen vacío de su lienzo (1200 × 896),
  /// donde el personaje ocupa el centro.
  static const double _proporcionEscritorio = 0.7;

  /// Medidas de `tecnico_login.json`, el técnico de móvil (lienzo de 800 × 594,
  /// con los antebrazos cruzados en el borde inferior). Si se cambia el
  /// dibujo, se ajustan aquí.
  ///
  /// Caja visible: el dibujo ocupa todo el ancho del lienzo.
  static const double _proporcionMovil = 800 / 594;

  /// Alto del personaje en móvil y la fracción de ese alto donde se apoyan sus
  /// antebrazos. La tarjeta empieza ahí, así el personaje queda acodado sobre
  /// su borde superior.
  static const double _altoPersonajeMovil = 150;
  static const double _apoyoPersonaje = 0.96;

  final String titulo;
  final String? subtitulo;
  final bool tituloCentrado;
  final double anchoEscritorio;

  /// En escritorio: panel azul con beneficios y título alineado a la izquierda.
  final bool esRegistro;
  final bool panelDetallado;

  /// Animación Lottie opcional del panel azul de escritorio: ocupa su centro
  /// (en lugar de los beneficios y el dibujo) y se repite entera.
  final String? animacionEscritorio;

  /// Animación Lottie opcional de móvil: el personaje queda apoyado sobre el
  /// borde superior de la tarjeta, con el logo arriba.
  final String? animacionMovil;

  /// Tramo (marcador) de [animacionMovil] que se reproduce, por ejemplo
  /// "email" mientras se escribe el correo. Sin tramo, se repite entera.
  final String? tramoAnimacion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: FondoOnda(
          color: Colores.fondo,
          colorOnda: Colores.cieloClaro.withValues(alpha: 0.14),
          forma: FormaOnda.esquina,
          child: SafeArea(
            child: _Tarjeta(
              titulo: titulo,
              subtitulo: subtitulo,
              tituloCentrado: tituloCentrado,
              conMarca: true,
              animacion: animacionMovil,
              tramoAnimacion: tramoAnimacion,
              child: child,
            ),
          ),
        ),
        desktop: _EscritorioOndulado(
          panel: _PanelMarca(
            detallado: esRegistro || panelDetallado,
            animacion: animacionEscritorio,
          ),
          formulario: _FormularioEscritorio(
            titulo: titulo,
            subtitulo: subtitulo,
            ancho: anchoEscritorio,
            centrado: !esRegistro,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Degradado vertical del panel de la marca. Al ser vertical, la franja
/// ondulada que lo prolonga hacia la derecha empalma sin que se note.
const _degradadoPanel = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Colores.fondo, Colores.primarioVivo],
);

/// Escritorio: las dos mitades de siempre (panel de la marca y formulario),
/// pero el panel no termina en una línea recta: lo prolonga una franja con
/// dos curvas que entra sobre el formulario, con una onda celeste
/// translúcida detrás. Las dos ondulan despacio y desfasadas; con "reducir
/// animaciones" quedan quietas.
class _EscritorioOndulado extends StatefulWidget {
  const _EscritorioOndulado({required this.panel, required this.formulario});

  final Widget panel;
  final Widget formulario;

  /// Cuánto entra la onda verde sobre la mitad del formulario.
  static const double entrada = 48;

  /// Cuánto entra la onda celeste (asoma detrás de la verde).
  static const double entradaCeleste = 76;

  /// Una vuelta completa de la ondulación.
  static const Duration ciclo = Duration(seconds: 8);

  @override
  State<_EscritorioOndulado> createState() => _EscritorioOnduladoState();
}

class _EscritorioOnduladoState extends State<_EscritorioOndulado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ondula = AnimationController(
    vsync: this,
    duration: _EscritorioOndulado.ciclo,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respeta "reducir animaciones": la onda queda quieta.
    final quieta = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (quieta) {
      _ondula.stop();
    } else if (!_ondula.isAnimating) {
      _ondula.repeat();
    }
  }

  @override
  void dispose() {
    _ondula.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const entrada = _EscritorioOndulado.entrada;
    const entradaCeleste = _EscritorioOndulado.entradaCeleste;
    return LayoutBuilder(
      builder: (context, restricciones) {
        final mitad = restricciones.maxWidth / 2;
        return Stack(
          children: [
            // El formulario, con margen a la izquierda para que la onda no
            // tape los campos.
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: mitad,
              // Fondo blanco en toda la mitad: las ondas entran sobre blanco.
              child: ColoredBox(
                color: Colores.tarjeta,
                child: Padding(
                  padding: const EdgeInsets.only(left: entradaCeleste - 16),
                  child: widget.formulario,
                ),
              ),
            ),
            // Onda celeste translúcida, detrás de la verde y desfasada.
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: mitad + entradaCeleste,
              child: ClipPath(
                clipper: _RecorteOndulado(
                  ondula: _ondula,
                  entrada: entradaCeleste,
                  fase: math.pi * 0.6,
                ),
                child: ColoredBox(
                  color: Colores.cieloClaro.withValues(alpha: 0.35),
                ),
              ),
            ),
            // El panel verde con su borde ondulado. El panel conserva su
            // ancho (la mitad); la franja que entra repite su degradado.
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: mitad + entrada,
              child: ClipPath(
                clipper: _RecorteOndulado(ondula: _ondula, entrada: entrada),
                child: DecoratedBox(
                  decoration: const BoxDecoration(gradient: _degradadoPanel),
                  child: Padding(
                    padding: const EdgeInsets.only(right: entrada),
                    child: widget.panel,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Recorta el borde derecho como una onda: una curva que sale y otra que
/// vuelve a lo alto de la pantalla (un período de seno), desplazándose con
/// [ondula]. El borde se mueve entre `ancho - entrada` y `ancho`.
class _RecorteOndulado extends CustomClipper<Path> {
  _RecorteOndulado({required this.ondula, required this.entrada, this.fase = 0})
    : super(reclip: ondula);

  final Animation<double> ondula;
  final double entrada;
  final double fase;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final desfase = fase + ondula.value * 2 * math.pi;
    double borde(double y) =>
        w -
        entrada / 2 +
        (entrada / 2) * math.sin(2 * math.pi * y / h + desfase);

    final ruta = Path()
      ..moveTo(0, 0)
      ..lineTo(borde(0), 0);
    const paso = 6.0;
    for (var y = paso; y < h; y += paso) {
      ruta.lineTo(borde(y), y);
    }
    return ruta
      ..lineTo(borde(h), h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldReclip(_RecorteOndulado anterior) =>
      anterior.entrada != entrada ||
      anterior.fase != fase ||
      anterior.ondula != ondula;
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
  const _PanelMarca({this.detallado = false, this.animacion});

  final bool detallado;
  final String? animacion;

  static const _beneficios = [
    (
      Icons.verified_user_outlined,
      'Técnicos verificados',
      'Revisamos su identidad antes de activarlos',
    ),
    (
      Icons.local_offer_outlined,
      'Ofertas claras',
      'Precio de la visita y cómo resolverá tu problema',
    ),
    (
      Icons.chat_bubble_outline,
      'Chat directo',
      'Coordina el trabajo desde la app',
    ),
  ];

  Text _titular(TextStyle? estilo, {TextAlign? alineacion}) => Text.rich(
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
    textAlign: alineacion,
    style: estilo?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
  );

  /// Animación grande al centro del panel con el titular debajo. El tamaño se
  /// adapta al panel (deja lugar para el titular, no se sale por los lados) y
  /// no pasa de 440 de alto.
  Widget _contenidoAnimado(TextTheme textos, String ruta) {
    return LayoutBuilder(
      builder: (context, c) {
        final alto = [
          c.maxHeight - 140,
          c.maxWidth / AuthLayout._proporcionEscritorio,
          440.0,
        ].reduce((a, b) => a < b ? a : b);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (alto >= 120)
              AnimacionLottie(
                ruta: ruta,
                alto: alto,
                proporcion: AuthLayout._proporcionEscritorio,
              ),
            const SizedBox(height: Espacios.xl),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _titular(
                textos.headlineSmall,
                alineacion: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

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
        borderRadius: BorderRadius.circular(Radios.subtarjeta),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
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
    final animacion = this.animacion;
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: _degradadoPanel),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Marca(grande: true, sobreOscuro: true),
            ),
            Expanded(
              child: animacion != null
                  ? _contenidoAnimado(textos, animacion)
                  : Center(
                      child: detallado
                          ? _contenidoDetallado(textos)
                          : _titular(textos.displaySmall),
                    ),
            ),
            if (animacion == null)
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
    required this.animacion,
    required this.tramoAnimacion,
    required this.child,
  });

  final String? tramoAnimacion;
  final String titulo;
  final String? subtitulo;
  final bool tituloCentrado;
  final bool conMarca;
  final String? animacion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animacion = this.animacion;
    final formulario = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (conMarca && animacion == null) ...[
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
    );

    if (animacion == null) {
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
              radio: Radios.bento,
              color: Colores.lienzo,
              conBorde: false,
              padding: const EdgeInsets.fromLTRB(
                Espacios.xl,
                Espacios.xxl,
                Espacios.xl,
                Espacios.xl,
              ),
              child: formulario,
            ),
          ),
        ),
      );
    }

    // Con animación: logo arriba, el personaje apoyado sobre el borde superior
    // de la tarjeta (superpuesto con un Stack) y el formulario dentro. Si no
    // alcanza el alto (pantalla baja o teclado abierto), se baja con scroll.
    const alto = AuthLayout._altoPersonajeMovil;
    const bordeTarjeta = alto * AuthLayout._apoyoPersonaje;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Espacios.l),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AuthLayout._anchoMaximoTarjeta,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (conMarca) ...[
                const Center(child: Marca(sobreOscuro: true)),
                const SizedBox(height: Espacios.s),
              ],
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: bordeTarjeta),
                    child: TarjetaApp(
                      radio: Radios.bento,
                      color: Colores.lienzo,
                      conBorde: false,
                      // Arriba suma lo que el personaje entra en la tarjeta,
                      // para que el título no quede pegado a sus pies.
                      padding: const EdgeInsets.fromLTRB(
                        Espacios.l,
                        Espacios.l + (alto - bordeTarjeta),
                        Espacios.l,
                        Espacios.l,
                      ),
                      child: formulario,
                    ),
                  ),
                  // Va después de la tarjeta para dibujarse encima de su borde.
                  AnimacionLottie(
                    ruta: animacion,
                    alto: alto,
                    proporcion: AuthLayout._proporcionMovil,
                    tramo: tramoAnimacion,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
