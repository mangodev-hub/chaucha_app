// Diálogo de calificación de 1 a 5 estrellas.
import 'package:flutter/material.dart';

typedef DatosResena = ({int estrellas, String? comentario});


Future<DatosResena?> mostrarDialogoResena(
  BuildContext context, {
  required String nombre,
}) {
  return showDialog<DatosResena>(
    context: context,
    builder: (context) => _DialogoResena(nombre: nombre),
  );
}

class _DialogoResena extends StatefulWidget {
  const _DialogoResena({required this.nombre});

  final String nombre;

  @override
  State<_DialogoResena> createState() => _DialogoResenaState();
}

class _DialogoResenaState extends State<_DialogoResena> {
  int _estrellas = 0;
  final _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Califica a ${widget.nombre}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _estrellas = i),
                  icon: Icon(
                    i <= _estrellas ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                ),
            ],
          ),
          TextField(
            controller: _comentario,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Comentario (opcional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(

          onPressed: _estrellas == 0
              ? null
              : () {
                  final texto = _comentario.text.trim();
                  Navigator.pop<DatosResena>(context, (
                    estrellas: _estrellas,
                    comentario: texto.isEmpty ? null : texto,
                  ));
                },
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
