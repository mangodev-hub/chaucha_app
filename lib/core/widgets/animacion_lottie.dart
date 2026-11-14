import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimacionLottie extends StatelessWidget {
  const AnimacionLottie({
    super.key,
    required this.ruta,
    required this.alto,
    this.proporcion = 1,
    this.tramo,
  });

  final String ruta;
  final double alto;
  final double proporcion;
  final String? tramo;

  @override
  Widget build(BuildContext context) {
    final reducir = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final tramo = this.tramo;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox(
          width: alto * proporcion,
          height: alto,
          child: ClipRect(
            child: tramo == null
                ? Lottie.asset(
                    ruta,
                    animate: !reducir,
                    fit: BoxFit.cover,
                    frameRate: FrameRate.composition,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  )
                : _LottiePorTramos(ruta: ruta, tramo: tramo),
          ),
        ),
      ),
    );
  }
}

class _LottiePorTramos extends StatefulWidget {
  const _LottiePorTramos({required this.ruta, required this.tramo});

  final String ruta;
  final String tramo;

  @override
  State<_LottiePorTramos> createState() => _LottiePorTramosState();
}

class _LottiePorTramosState extends State<_LottiePorTramos>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
  );
  LottieComposition? _composicion;

  /// Sube con cada cambio de tramo: una transición que termina tarde no
  /// arranca el bucle de un tramo que ya no corresponde.
  int _version = 0;

  @override
  void didUpdateWidget(covariant _LottiePorTramos anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.tramo != widget.tramo) unawaited(_irA(widget.tramo));
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  /// Inicio y fin del marcador en progreso (0–1). El fin del último tramo
  /// puede pasarse apenas de 1 por redondeo, y el controlador no lo acepta.
  (double, double) _rango(Marker marcador) =>
      (marcador.start.clamp(0.0, 1.0), marcador.end.clamp(0.0, 1.0));

  Duration _duracion(LottieComposition composicion, (double, double) rango) =>
      composicion.duration * (rango.$2 - rango.$1);

  Future<void> _irA(String tramo) async {
    final composicion = _composicion;
    final marcador = composicion?.getMarker(tramo);
    if (composicion == null || marcador == null) return;
    final destino = _rango(marcador);
    final version = ++_version;
    _controlador.stop();

    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _controlador.value = destino.$1;
      return;
    }

    final marcadorEntrada = composicion.getMarker('${tramo}_in');
    if (marcadorEntrada != null) {
      final entrada = _rango(marcadorEntrada);
      _controlador.value = entrada.$1;
      try {
        await _controlador
            .animateTo(entrada.$2, duration: _duracion(composicion, entrada))
            .orCancel;
      } on TickerCanceled {
        return; // Otro tramo la interrumpió.
      }
      if (!mounted || version != _version) return;
    } else {
      _controlador.value = destino.$1;
    }
    unawaited(
      _controlador.repeat(
        min: destino.$1,
        max: destino.$2,
        period: _duracion(composicion, destino),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.ruta,
      controller: _controlador,
      fit: BoxFit.cover,
      frameRate: FrameRate.composition,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
      onLoaded: (composicion) {
        _composicion = composicion;
        unawaited(_irA(widget.tramo));
      },
    );
  }
}
