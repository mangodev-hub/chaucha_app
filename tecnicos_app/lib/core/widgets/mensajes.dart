// Atajos para avisos rápidos (snackbars) y confirmaciones desde cualquier vista.
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum TipoMensaje { info, exito, error }

extension Mensajes on BuildContext {
  /// Aviso inferior. Éxito en verde oscuro y error en rojo oscuro, con ícono.
  void mostrarMensaje(String texto, {TipoMensaje tipo = TipoMensaje.info}) {
    final (fondo, icono) = switch (tipo) {
      TipoMensaje.info => (Colores.tinta, Icons.info_outline),
      TipoMensaje.exito => (Colores.acentoOscuro, Icons.check_circle_outline),
      TipoMensaje.error => (Colores.errorOscuro, Icons.error_outline),
    };
    final blanco = Theme.of(this).colorScheme.onPrimary;
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: fondo,
          content: Row(
            children: [
              Icon(icono, color: blanco, size: 20),
              const SizedBox(width: Espacios.m),
              Expanded(child: Text(texto)),
            ],
          ),
        ),
      );
  }

  /// Pide confirmación. Con [destructivo], el botón de confirmar usa el color
  /// de error (para cancelar, borrar...). Conviene que [textoConfirmar] diga
  /// la acción ("Sí, cancelar") y no un genérico "Aceptar".
  Future<bool> confirmar(
    String titulo,
    String mensaje, {
    String textoConfirmar = 'Aceptar',
    String textoCancelar = 'Cancelar',
    bool destructivo = false,
    IconData? icono,
  }) async {
    final respuesta = await showDialog<bool>(
      context: this,
      builder: (context) {
        final colores = Theme.of(context).colorScheme;
        return AlertDialog(
          icon: icono == null
              ? null
              : Icon(icono, color: destructivo ? colores.error : null),
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(textoCancelar),
            ),
            FilledButton(
              style: destructivo
                  ? FilledButton.styleFrom(
                      backgroundColor: colores.error,
                      foregroundColor: colores.onError,
                      minimumSize: const Size(0, 44),
                    )
                  : FilledButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => Navigator.pop(context, true),
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
    return respuesta ?? false;
  }
}
