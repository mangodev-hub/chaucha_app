import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'check_animado.dart';
import 'tarjeta_app.dart';

enum TipoEstado { neutro, error, exito }

extension on TipoEstado {
  Color get color => switch (this) {
    TipoEstado.neutro => Colores.primario,
    TipoEstado.error => Colores.error,
    TipoEstado.exito => Colores.acento,
  };

  Color get fondo => switch (this) {
    TipoEstado.neutro => Colores.primarioSuave,
    TipoEstado.error => Colores.errorSuave,
    TipoEstado.exito => Colores.acentoSuave,
  };
}

class EstadoMensaje extends StatelessWidget {
  const EstadoMensaje({
    super.key,
    required this.icono,
    required this.mensaje,
    this.titulo,
    this.tipo = TipoEstado.neutro,
    this.compacto = false,
    this.textoAccion,
    this.onAccion,
    this.textoAccionSecundaria,
    this.onAccionSecundaria,
  });

  final IconData icono;
  final String mensaje;
  final String? titulo;
  final TipoEstado tipo;

  /// Versión en una fila, sin centrar, para un hueco dentro de una pantalla.
  final bool compacto;
  final String? textoAccion;
  final VoidCallback? onAccion;

  /// Botón de texto debajo del principal. Solo en la versión grande.
  final String? textoAccionSecundaria;
  final VoidCallback? onAccionSecundaria;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final titulo = this.titulo;
    final textoAccion = this.textoAccion;
    final hayAccion = textoAccion != null && onAccion != null;
    final textoSecundario = textoAccionSecundaria;
    final haySecundaria = textoSecundario != null && onAccionSecundaria != null;
    final exito = tipo == TipoEstado.exito;

    if (compacto) {
      return TarjetaApp(
        child: Row(
          children: [
            _Aparecer(
              activo: exito,
              child: IconoRecuadro(
                icono: icono,
                color: tipo.color,
                fondo: tipo.fondo,
              ),
            ),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titulo != null) Text(titulo, style: textos.titleSmall),
                  Text(
                    mensaje,
                    style: textos.bodyMedium?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                  if (hayAccion)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                      ),
                      onPressed: onAccion,
                      child: Text(textoAccion),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espacios.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Aparecer(
                activo: exito,
                child: SizedBox.square(
                  dimension: 88,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: tipo.fondo,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(icono, size: 40, color: tipo.color),
                      ),
                      if (exito)
                        Positioned(
                          right: -2,
                          bottom: -2,
                          // Aro blanco para separar el check del círculo.
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colores.tarjeta,
                              shape: BoxShape.circle,
                            ),
                            child: const CheckAnimado(tamano: 30),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Espacios.l),
              if (titulo != null) ...[
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: textos.titleLarge,
                ),
                const SizedBox(height: Espacios.xs),
              ],
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
              ),
              if (hayAccion) ...[
                const SizedBox(height: Espacios.xl),
                FilledButton(onPressed: onAccion, child: Text(textoAccion)),
              ],
              if (haySecundaria) ...[
                SizedBox(height: hayAccion ? Espacios.s : Espacios.xl),
                TextButton(
                  onPressed: onAccionSecundaria,
                  child: Text(textoSecundario),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Si [activo], [child] aparece una vez con fundido y un rebote de escala.
class _Aparecer extends StatelessWidget {
  const _Aparecer({required this.activo, required this.child});

  final bool activo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!activo) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Movimiento.de(context, Movimiento.lento),
      builder: (context, t, child) => Opacity(
        opacity: Curves.easeOut.transform(t),
        child: Transform.scale(
          scale: 0.6 + 0.4 * Movimiento.rebote.transform(t),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
