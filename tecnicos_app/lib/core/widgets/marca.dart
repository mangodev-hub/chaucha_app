// Marca de la app: logo (llave en un círculo azul), nombre y lema.
//
// PROVISIONAL: el logo es un ícono de Material. Se reemplaza cuando el equipo
// tenga el logo definitivo (ver `docs/DISENO.md`).
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class Marca extends StatelessWidget {
  /// Logo y nombre en una fila (barras superiores, panel de escritorio).
  const Marca({super.key, this.grande = false, this.sobreOscuro = false})
    : vertical = false;

  /// Logo arriba, nombre y lema centrados debajo (login, registro, splash).
  const Marca.vertical({
    super.key,
    this.grande = false,
    this.sobreOscuro = false,
  }) : vertical = true;

  static const String nombre = 'ChauchaApp';
  static const String lema = 'Técnicos de confianza a tu puerta en Quito';

  /// Versión grande (splash, panel de escritorio).
  final bool grande;

  /// Colores invertidos para fondos azules.
  final bool sobreOscuro;

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    final colorNombre = sobreOscuro ? blanco : Colores.primarioOscuro;

    final logo = Container(
      width: grande ? 64 : (vertical ? 56 : 36),
      height: grande ? 64 : (vertical ? 56 : 36),
      decoration: BoxDecoration(
        color: sobreOscuro ? blanco : Colores.primarioVivo,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.build_rounded,
        size: grande ? 32 : (vertical ? 28 : 20),
        color: sobreOscuro ? Colores.primario : blanco,
      ),
    );

    if (vertical) {
      return Semantics(
        label: '$nombre. $lema',
        child: ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo,
              const SizedBox(height: Espacios.m),
              Text(
                nombre,
                textAlign: TextAlign.center,
                style: (grande ? textos.headlineMedium : textos.headlineSmall)
                    ?.copyWith(color: colorNombre),
              ),
              const SizedBox(height: Espacios.xs),
              Text(
                lema,
                textAlign: TextAlign.center,
                style: textos.bodySmall?.copyWith(
                  color: sobreOscuro
                      ? blanco.withValues(alpha: 0.85)
                      : Colores.tintaSuave,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        const SizedBox(width: Espacios.s + 2),
        Flexible(
          child: Text(
            nombre,
            style: (grande ? textos.headlineSmall : textos.titleLarge)
                ?.copyWith(color: colorNombre),
          ),
        ),
      ],
    );
  }
}
