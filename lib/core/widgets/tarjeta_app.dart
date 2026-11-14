import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'presionable.dart';

class TarjetaApp extends StatelessWidget {
  const TarjetaApp({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Espacios.l),
    this.margin = EdgeInsets.zero,
    this.color = Colores.tarjeta,
    this.colorBorde,
    this.radio = Radios.subtarjeta,
    this.conBorde = true,
  });

  final Widget child;

  /// Si no es null, la tarjeta entera se puede tocar.
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;

  /// Borde de color para resaltar (elegida, aceptada, activa).
  final Color? colorBorde;
  final double radio;

  /// Borde fino gris verdoso cuando no hay [colorBorde]. Se apaga en las
  /// tarjetas que ya se distinguen por su color.
  final bool conBorde;

  @override
  Widget build(BuildContext context) {
    final borde = BorderRadius.circular(radio);
    final colorBorde = this.colorBorde;
    final tarjeta = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borde,
        border: colorBorde != null
            ? Border.all(color: colorBorde, width: 1.5)
            : conBorde
            ? Border.all(color: Colores.linea)
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: borde,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    // Las tarjetas que se pueden tocar se encogen apenas al presionarlas.
    if (onTap == null) return tarjeta;
    return Presionable(escala: 0.98, child: tarjeta);
  }
}

/// Tarjeta con encabezado: número de paso opcional, título y subtítulo.
class BloqueTarjeta extends StatelessWidget {
  const BloqueTarjeta({
    super.key,
    required this.titulo,
    required this.child,
    this.subtitulo,
    this.numero,
    this.icono,
    this.margin = const EdgeInsets.only(bottom: Espacios.l),
  });

  final String titulo;
  final String? subtitulo;

  /// Número de paso en un círculo verde (formularios por bloques).
  final int? numero;

  /// Ícono en un recuadro celeste, si no hay número.
  final IconData? icono;
  final Widget child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final subtitulo = this.subtitulo;
    final numero = this.numero;
    final icono = this.icono;
    return TarjetaApp(
      margin: margin,
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (numero != null)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colores.primario,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Text(
                    '$numero',
                    style: textos.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
              else if (icono != null)
                IconoRecuadro(icono: icono),
              if (numero != null || icono != null)
                const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: textos.titleMedium),
                    if (subtitulo != null)
                      Text(
                        subtitulo,
                        style: textos.bodySmall?.copyWith(
                          color: Colores.tintaSuave,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.l),
          child,
        ],
      ),
    );
  }
}

/// Ícono celeste oscuro en un círculo celeste suave (los íconos de sección
/// son contexto; el verde queda para la acción).
class IconoRecuadro extends StatelessWidget {
  const IconoRecuadro({
    super.key,
    required this.icono,
    this.lado = 40,
    this.color = Colores.cieloOscuro,
    this.fondo = Colores.cieloSuave,
  });

  final IconData icono;
  final double lado;
  final Color color;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lado,
      height: lado,
      decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
      child: Icon(icono, color: color, size: lado * 0.5),
    );
  }
}
