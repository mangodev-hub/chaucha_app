// Diálogo de calificación de 1 a 5 estrellas, con comentario opcional.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/campos.dart';

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
  static const _etiquetas = [
    'Toca una estrella',
    'Malo',
    'Regular',
    'Bueno',
    'Muy bueno',
    'Excelente',
  ];

  int _estrellas = 0;
  final _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return AlertDialog(
      icon: const Icon(Icons.star_rounded, color: Colores.estrella, size: 36),
      title: Text('Califica a ${widget.nombre}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cada estrella ocupa un quinto del ancho, para que las cinco
            // quepan en cualquier teléfono. (No se usa LayoutBuilder: el
            // AlertDialog mide su contenido de antemano y no lo admite.)
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  Expanded(
                    child: IconButton(
                      tooltip: '$i de 5',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 48,
                      ),
                      onPressed: () => setState(() => _estrellas = i),
                      icon: Icon(
                        i <= _estrellas
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Colores.estrella,
                        size: 34,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              _etiquetas[_estrellas],
              textAlign: TextAlign.center,
              style: textos.titleSmall?.copyWith(
                color: _estrellas == 0 ? Colores.tintaSuave : Colores.tinta,
              ),
            ),
            const SizedBox(height: Espacios.l),
            CampoEtiquetado(
              etiqueta: 'Comentario',
              ayuda: 'Opcional',
              child: TextField(
                controller: _comentario,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '¿Cómo fue tu experiencia?',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
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
