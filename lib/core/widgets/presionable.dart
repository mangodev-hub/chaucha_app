// Encoge un poco a [child] mientras se mantiene presionado, para que botones y
// tarjetas se sientan "físicos". No compite con los gestos del hijo: solo
// escucha el puntero. Si el dedo se arrastra (scroll), se suelta.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class Presionable extends StatefulWidget {
  const Presionable({
    super.key,
    required this.child,
    this.activo = true,
    this.escala = 0.97,
  });

  final Widget child;

  /// Si es false no reacciona (botón desactivado o cargando). Se mantiene el
  /// mismo árbol para no reiniciar el estado del hijo.
  final bool activo;

  /// Tamaño mientras está presionado (1 = sin cambio).
  final double escala;

  @override
  State<Presionable> createState() => _PresionableState();
}

class _PresionableState extends State<Presionable> {
  bool _presionado = false;
  Offset? _inicio;

  void _cambiar(bool valor) {
    if (_presionado != valor) setState(() => _presionado = valor);
  }

  void _soltar() {
    _inicio = null;
    _cambiar(false);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (evento) {
        if (!widget.activo) return;
        _inicio = evento.position;
        _cambiar(true);
      },
      onPointerMove: (evento) {
        final inicio = _inicio;
        if (inicio != null &&
            (evento.position - inicio).distance > kTouchSlop) {
          _soltar();
        }
      },
      onPointerUp: (_) => _soltar(),
      onPointerCancel: (_) => _soltar(),
      child: AnimatedScale(
        scale: _presionado && widget.activo ? widget.escala : 1,
        duration: Movimiento.de(context, Movimiento.rapido),
        curve: Movimiento.entrada,
        child: widget.child,
      ),
    );
  }
}
