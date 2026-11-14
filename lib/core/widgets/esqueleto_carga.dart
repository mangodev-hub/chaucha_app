import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class EsqueletoCarga extends StatefulWidget {
  const EsqueletoCarga({
    super.key,
    required this.child,
    this.etiqueta = 'Cargando',
  });

  /// La forma de la pantalla, armada con [BloqueEsqueleto] (y tarjetas).
  final Widget child;

  /// Lo que anuncian los lectores de pantalla.
  final String etiqueta;

  /// Un ciclo completo del latido (va y vuelve).
  static const Duration ciclo = Duration(milliseconds: 1800);

  @override
  State<EsqueletoCarga> createState() => _EsqueletoCargaState();
}

class _EsqueletoCargaState extends State<EsqueletoCarga>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
    duration: EsqueletoCarga.ciclo ~/ 2,
  );
  late final Animation<double> _opacidad = Tween<double>(
    begin: 1,
    end: 0.45,
  ).animate(CurvedAnimation(parent: _controlador, curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final quieto = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (quieto) {
      _controlador
        ..stop()
        ..value = 0;
    } else if (!_controlador.isAnimating) {
      // Se repite hasta que se desmonta el widget.
      unawaited(_controlador.repeat(reverse: true));
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.etiqueta,
      liveRegion: true,
      child: ExcludeSemantics(
        child: FadeTransition(opacity: _opacidad, child: widget.child),
      ),
    );
  }
}

/// Un bloque del esqueleto: una línea de texto, una foto, un mapa…
class BloqueEsqueleto extends StatelessWidget {
  const BloqueEsqueleto({
    super.key,
    this.alto = 14,
    this.ancho,
    this.radio = Radios.pequeno,
  });

  /// Bloque redondo (avatar, ícono).
  const BloqueEsqueleto.circulo({super.key, required double tamano})
    : alto = tamano,
      ancho = tamano,
      radio = Radios.pildora;

  final double alto;

  /// Si es null, ocupa todo el ancho disponible.
  final double? ancho;
  final double radio;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      width: ancho ?? double.infinity,
      decoration: BoxDecoration(
        color: Colores.superficieFuerte,
        borderRadius: BorderRadius.circular(radio),
      ),
    );
  }
}
