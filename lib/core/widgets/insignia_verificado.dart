import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'pildora.dart';

/// Píldora "Verificado", para cabeceras y fichas de perfil.
class InsigniaVerificado extends StatelessWidget {
  const InsigniaVerificado({super.key});

  @override
  Widget build(BuildContext context) => const Pildora(
    texto: 'Verificado',
    icono: Icons.verified,
    color: Colores.acento,
  );
}

/// Solo el ícono, junto a un nombre o sobre una foto en listas compactas.
class IconoVerificado extends StatelessWidget {
  const IconoVerificado({super.key, this.tamano = 16, this.conBorde = false});

  final double tamano;

  /// Círculo blanco alrededor, para montarlo sobre una foto.
  final bool conBorde;

  @override
  Widget build(BuildContext context) {
    const icono = Icons.verified;
    final dibujo = Icon(icono, size: tamano, color: Colores.acento);
    return Semantics(
      label: 'Verificado',
      child: Tooltip(
        message: 'Identidad verificada',
        child: conBorde
            ? Container(
                decoration: const BoxDecoration(
                  color: Colores.tarjeta,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(tamano * 0.08),
                child: dibujo,
              )
            : dibujo,
      ),
    );
  }
}

/// [hijo] (una foto) con el ícono de verificado en la esquina inferior
/// derecha, si [verificado].
class ConIconoVerificado extends StatelessWidget {
  const ConIconoVerificado({
    super.key,
    required this.verificado,
    required this.hijo,
    this.tamano = 18,
  });

  final bool verificado;
  final Widget hijo;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    if (!verificado) return hijo;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        hijo,
        Positioned(
          right: -tamano * 0.15,
          bottom: -tamano * 0.15,
          child: IconoVerificado(tamano: tamano, conBorde: true),
        ),
      ],
    );
  }
}
