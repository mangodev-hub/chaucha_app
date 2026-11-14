import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Dónde se dibuja la onda.
enum FormaOnda {
  /// Una mancha redondeada que entra por la esquina superior derecha.
  esquina,

  /// Una ola que ocupa la parte inferior.
  inferior,
}

class TarjetaOnda extends StatelessWidget {
  const TarjetaOnda({
    super.key,
    required this.child,
    this.color = Colores.primarioClaro,
    this.colorOnda = const Color(0x8C41B6EF),
    this.titulo,
    this.accion,
    this.colorTexto = Colores.tinta,
    this.forma = FormaOnda.esquina,
    this.padding = const EdgeInsets.all(Espacios.xl),
    this.radio = Radios.bento,
    this.onTap,
  });

  /// Dúo verde claro con onda celeste (la variante por defecto).
  const TarjetaOnda.verde({
    super.key,
    required this.child,
    this.titulo,
    this.accion,
    this.forma = FormaOnda.esquina,
    this.padding = const EdgeInsets.all(Espacios.xl),
    this.radio = Radios.bento,
    this.onTap,
  }) : color = Colores.primarioClaro,
       colorOnda = const Color(0x8C41B6EF),
       colorTexto = Colores.tinta;

  /// Dúo celeste claro con ola verde.
  const TarjetaOnda.celeste({
    super.key,
    required this.child,
    this.titulo,
    this.accion,
    this.forma = FormaOnda.inferior,
    this.padding = const EdgeInsets.all(Espacios.xl),
    this.radio = Radios.bento,
    this.onTap,
  }) : color = Colores.cieloClaro,
       colorOnda = const Color(0x735CCB5F),
       colorTexto = Colores.tinta;

  /// Superficie clara con una onda celeste muy suave: secciones con
  /// sub-tarjetas, listas o formularios sobre el fondo oscuro.
  const TarjetaOnda.clara({
    super.key,
    required this.child,
    this.titulo,
    this.accion,
    this.forma = FormaOnda.esquina,
    this.padding = const EdgeInsets.all(Espacios.xl),
    this.radio = Radios.bento,
    this.onTap,
  }) : color = Colores.lienzo,
       colorOnda = Colores.cieloSuave,
       colorTexto = Colores.tinta;

  final Color color;
  final Color colorOnda;

  /// Título de la sección, arriba a la izquierda.
  final String? titulo;

  /// Enlace o botón a la derecha del título ("Ver todos").
  final Widget? accion;
  final Color colorTexto;
  final FormaOnda forma;
  final EdgeInsetsGeometry padding;
  final double radio;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final titulo = this.titulo;
    final accion = this.accion;
    final radio = BorderRadius.circular(this.radio);
    return Material(
      color: color,
      borderRadius: radio,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radio,
        child: CustomPaint(
          painter: PintorOnda(color: colorOnda, forma: forma),
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (titulo != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          titulo,
                          style: textos.titleLarge?.copyWith(color: colorTexto),
                        ),
                      ),
                      if (accion != null) ...[
                        const SizedBox(width: Espacios.s),
                        accion,
                      ],
                    ],
                  ),
                  const SizedBox(height: Espacios.l),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pinta una onda orgánica de [color]: una mancha por la esquina superior
/// derecha ([FormaOnda.esquina]) o una ola abajo ([FormaOnda.inferior]).
class PintorOnda extends CustomPainter {
  const PintorOnda({required this.color, this.forma = FormaOnda.esquina});

  final Color color;
  final FormaOnda forma;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;
    final ruta = Path();
    switch (forma) {
      case FormaOnda.esquina:
        ruta
          ..moveTo(w * 0.42, 0)
          ..cubicTo(w * 0.40, h * 0.28, w * 0.58, h * 0.40, w * 0.72, h * 0.36)
          ..cubicTo(w * 0.86, h * 0.32, w * 0.88, h * 0.62, w, h * 0.66)
          ..lineTo(w, 0)
          ..close();
      case FormaOnda.inferior:
        ruta
          ..moveTo(0, h * 0.70)
          ..cubicTo(w * 0.22, h * 0.52, w * 0.42, h * 0.86, w * 0.64, h * 0.74)
          ..cubicTo(w * 0.80, h * 0.65, w * 0.90, h * 0.58, w, h * 0.62)
          ..lineTo(w, h)
          ..lineTo(0, h)
          ..close();
    }
    canvas.drawPath(ruta, Paint()..color = color);
  }

  @override
  bool shouldRepaint(PintorOnda anterior) =>
      anterior.color != color || anterior.forma != forma;
}

/// Solo el fondo: color con su onda, para franjas y cabeceras que arman su
/// propio recorte (la portada del perfil con el avatar encima).
class FondoOnda extends StatelessWidget {
  const FondoOnda({
    super.key,
    this.color = Colores.cieloClaro,
    this.colorOnda = const Color(0x735CCB5F),
    this.forma = FormaOnda.inferior,
    this.child,
  });

  final Color color;
  final Color colorOnda;
  final FormaOnda forma;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: CustomPaint(
        painter: PintorOnda(color: colorOnda, forma: forma),
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}
