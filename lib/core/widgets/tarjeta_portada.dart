// Tarjeta de portada del inicio: título grande, subtítulo, un dato en una
// píldora verde oscuro y una ilustración a la derecha, sobre una tarjeta
// bento con onda. Dos variantes para que los roles se distingan de un
// vistazo: verde claro con mancha celeste (cliente y admin) y celeste claro
// con ola verde (técnico). Las dos llevan texto oscuro.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'tarjeta_onda.dart';

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

  /// Variante celeste (inicio del técnico).
  final bool celeste;

  /// Con menos de este ancho la ilustración no se muestra.
  static const double _anchoMinimoIlustracion = 300;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final dato = this.dato;
    final subtitulo = this.subtitulo;

    return Material(
      color: celeste ? Colores.cieloClaro : Colores.primarioClaro,
      borderRadius: BorderRadius.circular(Radios.bento),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: PintorOnda(
          color: celeste
              ? Colores.primarioClaro.withValues(alpha: 0.45)
              : Colores.cieloClaro.withValues(alpha: 0.55),
          forma: celeste ? FormaOnda.inferior : FormaOnda.esquina,
        ),
        child: LayoutBuilder(
          builder: (context, restricciones) {
            final ancho = restricciones.maxWidth;
            final conIlustracion = ancho >= _anchoMinimoIlustracion;
            final amplia = ancho >= 600;
            final tamanoIlustracion = amplia ? 140.0 : 100.0;

            final texto = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Titulo(
                  titulo,
                  estilo:
                      (amplia ? textos.headlineMedium : textos.headlineSmall)
                          ?.copyWith(color: Colores.tinta, height: 1.15),
                  acento: Colores.primario,
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: Espacios.s),
                  Text(
                    subtitulo,
                    style: (amplia ? textos.titleMedium : textos.bodyMedium)
                        ?.copyWith(
                          color: Colores.tinta,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ],
            );

            return Padding(
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
                        IlustracionPortada(
                          icono: icono,
                          tamano: tamanoIlustracion,
                        ),
                      ],
                    ],
                  ),
                  // La píldora va debajo: así no compite con la ilustración
                  // y nunca se corta.
                  if (dato != null) ...[
                    const SizedBox(height: Espacios.l),
                    _PildoraDato(texto: dato, icono: iconoDato),
                  ],
                ],
              ),
            );
          },
        ),
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

/// Píldora verde oscuro con el dato en blanco.
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
          vertical: Espacios.s,
        ),
        decoration: BoxDecoration(
          color: Colores.primario,
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
                  Icon(icono, size: 16, color: Colores.sobreOscuro),
                  const SizedBox(width: Espacios.xs + 2),
                ],
                Flexible(
                  child: Text(
                    texto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colores.sobreOscuro,
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

/// Ilustración hecha con formas: un círculo claro translúcido con el ícono y
/// una insignia de "verificado". Entra con un pequeño rebote.
class IlustracionPortada extends StatelessWidget {
  const IlustracionPortada({
    super.key,
    required this.icono,
    required this.tamano,
  });

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
                  color: Colores.lienzo.withValues(alpha: 0.55),
                  border: Border.all(
                    color: Colores.lienzo.withValues(alpha: 0.9),
                    width: 2.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icono, size: tamano * 0.5, color: Colores.primario),
              ),
              Positioned(
                right: -tamano * 0.02,
                top: tamano * 0.02,
                child: Container(
                  width: insignia,
                  height: insignia,
                  decoration: const BoxDecoration(
                    color: Colores.primario,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    size: insignia * 0.62,
                    color: Colores.sobreOscuro,
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
