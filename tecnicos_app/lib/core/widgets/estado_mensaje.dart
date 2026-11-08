// Mensaje de estado para huecos de la pantalla: lista vacía, error o éxito.
// Centrado y grande, o [compacto] (en una fila) para usarlo dentro de una
// sección. Con botón de acción opcional.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
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
  });

  final IconData icono;
  final String mensaje;
  final String? titulo;
  final TipoEstado tipo;

  /// Versión en una fila, sin centrar, para un hueco dentro de una pantalla.
  final bool compacto;
  final String? textoAccion;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final titulo = this.titulo;
    final textoAccion = this.textoAccion;
    final hayAccion = textoAccion != null && onAccion != null;

    if (compacto) {
      return TarjetaApp(
        child: Row(
          children: [
            IconoRecuadro(icono: icono, color: tipo.color, fondo: tipo.fondo),
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
                ],
              ),
            ),
            if (hayAccion) ...[
              const SizedBox(width: Espacios.s),
              TextButton(onPressed: onAccion, child: Text(textoAccion)),
            ],
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
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: tipo.fondo,
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 40, color: tipo.color),
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
            ],
          ),
        ),
      ),
    );
  }
}
