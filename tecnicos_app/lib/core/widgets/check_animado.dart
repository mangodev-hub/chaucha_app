// Check de verificación animado: un círculo verde que aparece con rebote y
// un tilde que se dibuja encima. Se reproduce una sola vez al mostrarse.
// Para momentos de éxito (solicitud creada, correo enviado, código
// verificado); respeta "reducir animaciones" (aparece ya dibujado).
import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class CheckAnimado extends StatefulWidget {
  const CheckAnimado({
    super.key,
    this.tamano = 24,
    this.color = Colores.acento,
    this.colorTilde = Colores.tarjeta,
    this.etiqueta,
  });

  /// Diámetro del círculo.
  final double tamano;
  final Color color;
  final Color colorTilde;

  /// Texto para lectores de pantalla. Si es null, el check es decorativo.
  final String? etiqueta;

  @override
  State<CheckAnimado> createState() => _CheckAnimadoState();
}

class _CheckAnimadoState extends State<CheckAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
  );
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // MediaQuery no se puede leer en initState: se arranca aquí, una vez.
    if (!_iniciado) {
      _iniciado = true;
      _controlador.duration = Movimiento.de(context, Movimiento.lento);
      unawaited(_controlador.forward());
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final etiqueta = widget.etiqueta;
    final dibujo = SizedBox.square(
      dimension: widget.tamano,
      child: CustomPaint(
        painter: _PintorCheck(
          progreso: _controlador,
          color: widget.color,
          colorTilde: widget.colorTilde,
        ),
      ),
    );
    if (etiqueta == null) return ExcludeSemantics(child: dibujo);
    return Semantics(label: etiqueta, image: true, child: dibujo);
  }
}

class _PintorCheck extends CustomPainter {
  _PintorCheck({
    required this.progreso,
    required this.color,
    required this.colorTilde,
  }) : super(repaint: progreso);

  final Animation<double> progreso;
  final Color color;
  final Color colorTilde;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progreso.value;
    final lado = size.shortestSide;
    final centro = size.center(Offset.zero);

    // Círculo: primera mitad, con rebote.
    final tCirculo = Movimiento.rebote.transform((t / 0.55).clamp(0.0, 1.0));
    canvas.drawCircle(centro, lado / 2 * tCirculo, Paint()..color = color);

    // Tilde: se dibuja desde el 40 % hasta el final.
    final tTilde = Movimiento.entrada.transform(
      ((t - 0.4) / 0.6).clamp(0.0, 1.0),
    );
    if (tTilde == 0) return;
    final origen = centro - Offset(lado / 2, lado / 2);
    final ruta = Path()
      ..moveTo(origen.dx + lado * 0.28, origen.dy + lado * 0.52)
      ..lineTo(origen.dx + lado * 0.44, origen.dy + lado * 0.67)
      ..lineTo(origen.dx + lado * 0.72, origen.dy + lado * 0.36);
    final metrica = ruta.computeMetrics().first;
    canvas.drawPath(
      metrica.extractPath(0, metrica.length * tTilde),
      Paint()
        ..color = colorTilde
        ..style = PaintingStyle.stroke
        ..strokeWidth = lado * 0.09
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PintorCheck anterior) =>
      anterior.color != color ||
      anterior.colorTilde != colorTilde ||
      anterior.progreso != progreso;
}
