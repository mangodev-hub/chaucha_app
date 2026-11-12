// Tarjeta de portada del inicio: título grande, subtítulo, un dato en una
// píldora y una ilustración con formas a la derecha. Tiene dos variantes:
// la verde bosque (cliente y admin: el "sol" celeste y el "brote" verde
// asoman por la derecha) y la celeste (técnico: degradado celeste con texto
// oscuro), para que los dos roles se distingan de un vistazo.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class TarjetaPortada extends StatelessWidget {
  const TarjetaPortada({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.dato,
    this.iconoDato,
    this.icono = Icons.handyman_rounded,
    this.celeste = false,
  });

  /// Si termina en un signo (".", "?", "!"), ese signo se pinta de otro color
  /// como acento.
  final String titulo;
  final String? subtitulo;

  /// Texto corto en la píldora ("12 técnicos cerca").
  final String? dato;
  final IconData? iconoDato;

  /// Ícono de la ilustración de la derecha.
  final IconData icono;

  /// Variante celeste con texto oscuro (inicio del técnico).
  final bool celeste;

  /// Con menos de este ancho la ilustración no se muestra.
  static const double _anchoMinimoIlustracion = 300;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final dato = this.dato;
    final subtitulo = this.subtitulo;
    final colorTexto = celeste ? Colores.tinta : Colores.tarjeta;
    final colorSubtitulo = celeste ? Colores.cieloOscuro : Colores.tarjeta;

    return Container(
      decoration: BoxDecoration(
        color: celeste ? null : Colores.primario,
        gradient: celeste ? Degradados.cielo : null,
        borderRadius: BorderRadius.circular(Radios.muyGrande),
        boxShadow: celeste ? Sombras.suave : Sombras.fuerte,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, restricciones) {
          final ancho = restricciones.maxWidth;
          final conIlustracion = ancho >= _anchoMinimoIlustracion;
          final amplia = ancho >= 600;
          final tamanoIlustracion = amplia ? 150.0 : 108.0;

          final texto = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Titulo(
                titulo,
                estilo: (amplia ? textos.headlineMedium : textos.headlineSmall)
                    ?.copyWith(color: colorTexto, height: 1.15),
                acento: celeste ? Colores.primarioVivo : Colores.primarioClaro,
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: Espacios.s),
                Text(
                  subtitulo,
                  style: (amplia ? textos.titleMedium : textos.bodyLarge)
                      ?.copyWith(
                        color: colorSubtitulo,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          );

          return Stack(
            children: [
              // Formas de fondo detrás de la ilustración: el sol celeste y el
              // brote verde (verde), o un círculo blanco translúcido (celeste).
              if (conIlustracion) ...[
                Positioned(
                  right: -tamanoIlustracion * 0.45,
                  top: -tamanoIlustracion * 0.5,
                  child: _Circulo(
                    tamano: tamanoIlustracion * 1.6,
                    color: celeste
                        ? Colores.tarjeta.withValues(alpha: 0.35)
                        : Colores.cieloClaro,
                  ),
                ),
                Positioned(
                  right: tamanoIlustracion * 0.9,
                  bottom: -tamanoIlustracion * 0.35,
                  child: _Circulo(
                    tamano: tamanoIlustracion * 0.6,
                    color: celeste
                        ? Colores.primarioClaro.withValues(alpha: 0.6)
                        : Colores.primarioClaro,
                  ),
                ),
              ],
              Padding(
                padding: EdgeInsets.all(amplia ? Espacios.xxl : Espacios.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: texto),
                        if (conIlustracion) ...[
                          const SizedBox(width: Espacios.l),
                          _Ilustracion(
                            icono: icono,
                            tamano: tamanoIlustracion,
                            celeste: celeste,
                          ),
                        ],
                      ],
                    ),
                    // La píldora va debajo, a todo el ancho: así no compite
                    // con la ilustración y nunca se corta.
                    if (dato != null) ...[
                      const SizedBox(height: Espacios.l),
                      _PildoraDato(texto: dato, icono: iconoDato),
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

/// Título con el signo final de otro color.
class _Titulo extends StatelessWidget {
  const _Titulo(this.titulo, {required this.estilo, required this.acento});

  final String titulo;
  final TextStyle? estilo;
  final Color acento;

  @override
  Widget build(BuildContext context) {
    final signo =
        titulo.isNotEmpty && '.?!'.contains(titulo[titulo.length - 1]);
    if (!signo) return Text(titulo, style: estilo);
    return Text.rich(
      TextSpan(
        text: titulo.substring(0, titulo.length - 1),
        children: [
          TextSpan(
            text: titulo[titulo.length - 1],
            style: TextStyle(color: acento),
          ),
        ],
      ),
      style: estilo,
    );
  }
}

/// Píldora blanca con el dato, en celeste oscuro (es información).
class _PildoraDato extends StatelessWidget {
  const _PildoraDato({required this.texto, this.icono});

  final String texto;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final icono = this.icono;
    final duracion = Movimiento.de(context, Movimiento.normal);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.m + 2,
          vertical: Espacios.s - 1,
        ),
        decoration: BoxDecoration(
          color: Colores.tarjeta,
          borderRadius: BorderRadius.circular(Radios.pildora),
        ),
        // El dato suele llegar después (cuando cargan los datos): el cambio
        // se anima.
        child: AnimatedSize(
          duration: duracion,
          curve: Movimiento.entrada,
          child: AnimatedSwitcher(
            duration: duracion,
            child: Row(
              key: ValueKey(texto),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icono != null) ...[
                  Icon(icono, size: 16, color: Colores.cielo),
                  const SizedBox(width: Espacios.xs + 2),
                ],
                Flexible(
                  child: Text(
                    texto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colores.cieloOscuro,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ilustración hecha con formas: un círculo translúcido con el ícono y una
/// insignia blanca de "verificado". Entra con un pequeño rebote.
class _Ilustracion extends StatelessWidget {
  const _Ilustracion({
    required this.icono,
    required this.tamano,
    required this.celeste,
  });

  final IconData icono;
  final double tamano;
  final bool celeste;

  @override
  Widget build(BuildContext context) {
    final insignia = tamano * 0.34;
    final colorIcono = celeste ? Colores.cieloOscuro : Colores.tarjeta;
    final relleno = celeste
        ? Colores.tarjeta.withValues(alpha: 0.55)
        : Colores.tarjeta.withValues(alpha: 0.16);
    final borde = celeste
        ? Colores.tarjeta.withValues(alpha: 0.9)
        : Colores.tarjeta.withValues(alpha: 0.28);
    return ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1),
        duration: Movimiento.de(context, Movimiento.lento),
        curve: Movimiento.rebote,
        builder: (context, escala, child) =>
            Transform.scale(scale: escala, child: child),
        child: SizedBox.square(
          dimension: tamano,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: relleno,
                  border: Border.all(color: borde, width: 2),
                ),
                alignment: Alignment.center,
                child: Icon(icono, size: tamano * 0.5, color: colorIcono),
              ),
              Positioned(
                right: -tamano * 0.02,
                top: tamano * 0.02,
                child: Container(
                  width: insignia,
                  height: insignia,
                  decoration: const BoxDecoration(
                    color: Colores.tarjeta,
                    shape: BoxShape.circle,
                    boxShadow: Sombras.suave,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    size: insignia * 0.62,
                    color: Colores.acento,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Circulo extends StatelessWidget {
  const _Circulo({required this.tamano, required this.color});

  final double tamano;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
