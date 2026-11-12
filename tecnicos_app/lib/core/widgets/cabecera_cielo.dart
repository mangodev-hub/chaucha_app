// Cabecera celeste de las pantallas de detalle y de perfil: degradado
// celeste, título y subtítulo en tinta oscura, una píldora opcional a la
// derecha y, si hay lugar, una animación Lottie (el técnico) abajo a la
// derecha. Regla v2: celeste = contexto, verde = acción.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'animacion_lottie.dart';

class CabeceraCielo extends StatelessWidget {
  const CabeceraCielo({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.pildora,
    this.child,
    this.animacion,
    this.altoAnimacion = 120,
    this.proporcionAnimacion = 0.7,
    this.radio = Radios.muyGrande,
  });

  final String titulo;
  final String? subtitulo;

  /// Estado o dato corto, arriba a la derecha (una `Pildora`).
  final Widget? pildora;

  /// Contenido debajo del subtítulo (datos, chips, avatar...).
  final Widget? child;

  /// Ruta de un Lottie de `assets/lottie/`. Se muestra con 360 px o más.
  final String? animacion;
  final double altoAnimacion;
  final double proporcionAnimacion;
  final double radio;

  /// Con menos de este ancho la animación no se muestra.
  static const double _anchoMinimoAnimacion = 360;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final subtitulo = this.subtitulo;
    final pildora = this.pildora;
    final child = this.child;
    final animacion = this.animacion;

    return Container(
      decoration: BoxDecoration(
        gradient: Degradados.cielo,
        borderRadius: BorderRadius.circular(radio),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, restricciones) {
          final conAnimacion =
              animacion != null &&
              restricciones.maxWidth >= _anchoMinimoAnimacion;
          final anchoAnimacion = altoAnimacion * proporcionAnimacion;
          return Stack(
            children: [
              if (conAnimacion)
                Positioned(
                  right: Espacios.s,
                  bottom: 0,
                  child: AnimacionLottie(
                    ruta: animacion,
                    alto: altoAnimacion,
                    proporcion: proporcionAnimacion,
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Espacios.xl,
                  Espacios.xl,
                  conAnimacion ? anchoAnimacion + Espacios.l : Espacios.xl,
                  Espacios.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            titulo,
                            style: textos.headlineSmall?.copyWith(
                              color: Colores.tinta,
                            ),
                          ),
                        ),
                        if (pildora != null) ...[
                          const SizedBox(width: Espacios.s),
                          pildora,
                        ],
                      ],
                    ),
                    if (subtitulo != null) ...[
                      const SizedBox(height: Espacios.xs),
                      Text(
                        subtitulo,
                        style: textos.bodyMedium?.copyWith(
                          color: Colores.cieloOscuro,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (child != null) ...[
                      const SizedBox(height: Espacios.m),
                      child,
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
