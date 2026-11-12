// Marca de la app: el logo (una C que es una llave, con una tuerca celeste en
// la boca), el nombre y el lema.
//
// El logo se dibuja con un `CustomPainter`, sin assets, así se ve nítido a
// cualquier tamaño y toma los colores de los tokens.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Logo de ChauchaApp: una C verde con el brazo abierto, como una llave de
/// boca, y una tuerca celeste en la boca. Con [sobreOscuro], la C es blanca y
/// la tuerca celeste clara (para el panel verde de escritorio).
class LogoChaucha extends StatelessWidget {
  const LogoChaucha({
    super.key,
    this.tamano = 36,
    this.sobreOscuro = false,
    this.fondo,
  });

  final double tamano;
  final bool sobreOscuro;

  /// Color que se ve por el agujero de la tuerca: el fondo donde está el
  /// logo. Por defecto, blanco o el verde de la marca si va sobre oscuro.
  final Color? fondo;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(tamano),
        painter: _PintorLogo(
          llave: sobreOscuro ? Colores.tarjeta : Colores.primarioVivo,
          tuerca: sobreOscuro ? Colores.cieloClaro : Colores.cielo,
          agujero: fondo ?? (sobreOscuro ? Colores.primario : Colores.tarjeta),
        ),
      ),
    );
  }
}

class _PintorLogo extends CustomPainter {
  const _PintorLogo({
    required this.llave,
    required this.tuerca,
    required this.agujero,
  });

  final Color llave;
  final Color tuerca;
  final Color agujero;

  // El dibujo está pensado en un lienzo de 64 × 64.
  static const double _lienzo = 64;

  @override
  void paint(Canvas canvas, Size size) {
    final escala = size.shortestSide / _lienzo;
    canvas.scale(escala);

    // La C: un arco abierto hacia la derecha (de 40° a 320°).
    final trazo = Paint()
      ..color = llave
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(32, 32), radius: 22),
      _radianes(40),
      _radianes(280),
      false,
      trazo,
    );

    // La tuerca: un hexágono con la punta arriba, en la boca de la llave.
    const centro = Offset(53, 32);
    const radio = 7.0;
    final hexagono = Path();
    for (var i = 0; i < 6; i++) {
      final angulo = _radianes(-90.0 + 60 * i);
      final punto = Offset(
        centro.dx + radio * math.cos(angulo),
        centro.dy + radio * math.sin(angulo),
      );
      if (i == 0) {
        hexagono.moveTo(punto.dx, punto.dy);
      } else {
        hexagono.lineTo(punto.dx, punto.dy);
      }
    }
    hexagono.close();
    canvas.drawPath(hexagono, Paint()..color = tuerca);
    canvas.drawCircle(centro, 2.6, Paint()..color = agujero);
  }

  static double _radianes(double grados) => grados * math.pi / 180;

  @override
  bool shouldRepaint(_PintorLogo anterior) =>
      anterior.llave != llave ||
      anterior.tuerca != tuerca ||
      anterior.agujero != agujero;
}

class Marca extends StatelessWidget {
  /// Logo y nombre en una fila (barras superiores, panel de escritorio).
  const Marca({super.key, this.grande = false, this.sobreOscuro = false})
    : vertical = false;

  /// Logo arriba, nombre y lema centrados debajo (login, registro, splash).
  const Marca.vertical({
    super.key,
    this.grande = false,
    this.sobreOscuro = false,
  }) : vertical = true;

  static const String nombre = 'ChauchaApp';
  static const String lema = 'Técnicos de confianza a tu puerta en Quito';

  /// Versión grande (splash, panel de escritorio).
  final bool grande;

  /// Colores invertidos para fondos verdes.
  final bool sobreOscuro;

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    final colorNombre = sobreOscuro ? blanco : Colores.primario;

    final logo = LogoChaucha(
      tamano: grande ? 64 : (vertical ? 64 : 32),
      sobreOscuro: sobreOscuro,
      // En las pantallas de acceso el logo va sobre el fondo verde suave.
      fondo: sobreOscuro ? null : (vertical ? Colores.fondo : null),
    );

    TextStyle? nombreEstilo(TextStyle? base) => base?.copyWith(
      color: colorNombre,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
    );

    if (vertical) {
      return Semantics(
        label: '$nombre. $lema',
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo,
              const SizedBox(height: Espacios.m),
              Text(
                nombre,
                textAlign: TextAlign.center,
                style: nombreEstilo(
                  grande ? textos.headlineMedium : textos.headlineSmall,
                ),
              ),
              const SizedBox(height: Espacios.xs),
              Text(
                lema,
                textAlign: TextAlign.center,
                style: textos.bodySmall?.copyWith(
                  color: sobreOscuro
                      ? blanco.withValues(alpha: 0.85)
                      : Colores.tintaSuave,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label: nombre,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo,
            const SizedBox(width: Espacios.s + 2),
            Flexible(
              child: Text(
                nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: nombreEstilo(
                  grande ? textos.headlineSmall : textos.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
