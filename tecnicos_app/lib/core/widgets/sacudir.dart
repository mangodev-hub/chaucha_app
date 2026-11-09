// Sacude [child] de lado a lado cada vez que cambia [senal]. Para avisar que
// un envío falló (validación del formulario o respuesta del servidor), junto
// con el mensaje de error. Con "reducir animaciones" no se mueve.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class Sacudir extends StatefulWidget {
  const Sacudir({super.key, required this.senal, required this.child});

  /// Cada cambio de valor produce una sacudida (por ejemplo, un contador de
  /// intentos fallidos).
  final int senal;
  final Widget child;

  @override
  State<Sacudir> createState() => _SacudirState();
}

class _SacudirState extends State<Sacudir> with SingleTickerProviderStateMixin {
  static const _duracion = Duration(milliseconds: 420);

  /// Desplazamiento máximo, en píxeles.
  static const _amplitud = 8.0;

  late final AnimationController _controlador = AnimationController(
    vsync: this,
  );

  @override
  void didUpdateWidget(Sacudir anterior) {
    super.didUpdateWidget(anterior);
    if (widget.senal != anterior.senal) {
      _controlador.duration = Movimiento.de(context, _duracion);
      unawaited(_controlador.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controlador,
      // Dos vaivenes que se van apagando.
      builder: (context, child) {
        final t = _controlador.value;
        final dx = math.sin(t * math.pi * 4) * _amplitud * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}
