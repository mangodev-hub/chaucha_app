// Atajos para avisos rápidos  desde cualquier vista.
import 'package:flutter/material.dart';


extension Mensajes on BuildContext {
  void mostrarMensaje(String texto) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<bool> confirmar(String titulo, String mensaje) async {
    final respuesta = await showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    return respuesta ?? false;
  }
}
