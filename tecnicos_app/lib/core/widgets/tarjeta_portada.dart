// Tarjeta de portada del inicio: fondo verde bosque plano con un "sol"
// celeste y un "brote" verde asomando por la derecha, título grande en
// blanco, subtítulo, un dato en una píldora blanca y una ilustración.
// Va arriba del inicio del cliente y del técnico.
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
  });

  /// Si termina en un signo (".", "?", "!"), ese signo se pinta en celeste
  /// como acento.
  final String titulo;
  final String? subtitulo;

  /// Texto corto en la píldora blanca ("12 técnicos cerca · en vivo").
  final String? dato;
  final IconData? iconoDato;

  /// Ícono de la ilustración de la derecha.
  final IconData icono;

  /// Con menos de este ancho la ilustración no se muestra.
  static const double _anchoMinimoIlustracion = 300;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final dato = this.dato;
    final subtitulo = this.subtitulo;

    return Container(
      decoration: BoxDecoration(
        color: Colores.primario,
        borderRadius: BorderRadius.circular(Radios.muyGrande),
        boxShadow: Sombras.fuerte,
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
                    ?.copyWith(color: Colores.tarjeta, height: 1.15),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: Espacios.s),
                Text(
                  subtitulo,
                  style: (amplia ? textos.titleMedium : textos.bodyLarge)
                      ?.copyWith(
                        color: Colores.tarjeta,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          );

          return Stack(
            children: [
              // El sol celeste y el brote verde, detrás de la ilustración.
              if (conIlustracion) ...[
                Positioned(
                  right: -tamanoIlustracion * 0.45,
                  top: -tamanoIlustracion * 0.5,
                  child: _Circulo(
                    tamano: tamanoIlustracion * 1.6,
                    color: Colores.cieloClaro,
                  ),
                ),
                Positioned(
                  right: tamanoIlustracion * 0.9,
                  bottom: -tamanoIlustracion * 0.35,
                  child: _Circulo(
                    tamano: tamanoIlustracion * 0.6,
                    color: Colores.primarioClaro,
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

/// Título con el signo final en verde brote.
class _Titulo extends StatelessWidget {
  const _Titulo(this.titulo, {required this.estilo});

  final String titulo;
  final TextStyle? estilo;

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
            style: const TextStyle(color: Colores.primarioClaro),
          ),
        ],
      ),
      style: estilo,
    );
  }
}

class _PildoraDato extends StatelessWidget {
  const _PildoraDato({required this.texto, this.icono});

  final String texto;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final icono = this.icono;
    final duracion = Movimiento.de(context, Movimiento.normal);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.m + 2,
        vertical: Espacios.s - 1,
      ),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      // El dato suele llegar después (cuando cargan los datos): el cambio se
      // anima.
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
                Icon(icono, size: 16, color: Colores.primario),
                const SizedBox(width: Espacios.xs + 2),
              ],
              Flexible(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colores.primarioOscuro,
                    fontWeight: FontWeight.w700,
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

/// Ilustración hecha con formas: un círculo translúcido con el ícono y una
/// insignia blanca de "verificado". Entra con un pequeño rebote.
class _Ilustracion extends StatelessWidget {
  const _Ilustracion({required this.icono, required this.tamano});

  final IconData icono;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final insignia = tamano * 0.34;
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
                  color: Colores.tarjeta.withValues(alpha: 0.16),
                  border: Border.all(
                    color: Colores.tarjeta.withValues(alpha: 0.28),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icono, size: tamano * 0.5, color: Colores.tarjeta),
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
