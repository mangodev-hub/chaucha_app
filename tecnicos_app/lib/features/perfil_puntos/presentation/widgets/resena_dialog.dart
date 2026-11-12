// Diálogo de calificación de 3 niveles (excelente, neutro, malo), con comentario opcional.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/campos.dart';

typedef DatosResena = ({int estrellas, String? comentario});

Future<DatosResena?> mostrarDialogoResena(
  BuildContext context, {
  required String nombre,
  required bool paraTecnico,
}) {
  return showDialog<DatosResena>(
    context: context,
    builder: (context) =>
        _DialogoResena(nombre: nombre, paraTecnico: paraTecnico),
  );
}

class _DialogoResena extends StatefulWidget {
  const _DialogoResena({required this.nombre, required this.paraTecnico});

  final String nombre;
  final bool paraTecnico;

  @override
  State<_DialogoResena> createState() => _DialogoResenaState();
}

class _DialogoResenaState extends State<_DialogoResena> {
  static const _opciones = [
    (valor: 5, icono: Icons.sentiment_very_satisfied_rounded),
    (valor: 3, icono: Icons.thumb_up_alt_outlined),
    (valor: 1, icono: Icons.sentiment_very_dissatisfied_rounded),
  ];

  int _estrellas = 0;
  final _comentario = TextEditingController();

  String _texto(int v) => widget.paraTecnico
      ? switch (v) {
          5 => 'Excelente servicio, lo recomiendo',
          3 => 'Trabajo realizado',
          _ => 'El técnico fue grosero',
        }
      : switch (v) {
          5 => 'Fue muy amable',
          3 => 'Trabajo cumplido',
          _ => 'El cliente fue grosero',
        };

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final o in _opciones)
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _estrellas = o.valor),
                      child: Padding(
                        padding: const EdgeInsets.all(Espacios.s),
                        child: Column(
                          children: [
                            Icon(
                              o.icono,
                              size: 40,
                              color: _estrellas == o.valor
                                  ? Colores.estrella
                                  : Colores.tintaSuave,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _texto(o.valor),
                              textAlign: TextAlign.center,
                              style: textos.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
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