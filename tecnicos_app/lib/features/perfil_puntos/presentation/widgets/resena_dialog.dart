// Hoja de calificación: 5 estrellas, etiquetas según la nota y comentario opcional.
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

typedef DatosResena = ({
  int estrellas,
  List<String> etiquetas,
  String? comentario,
});

abstract final class EtiquetasResena {
  static const _tecnicoBien = [
    'Puntual',
    'Trabajo limpio',
    'Buen trato',
    'Buen precio',
    'Resolvió el problema',
    'Buena comunicación',
  ];
  static const _tecnicoMal = [
    'Llegó tarde',
    'Trabajo incompleto',
    'Mala actitud',
    'Dejó sucio',
    'Precio distinto al cotizado',
    'No resolvió el problema',
  ];
  static const _clienteBien = [
    'Amable',
    'Explicó bien el problema',
    'Estuvo disponible',
    'Respetuoso',
    'Acceso fácil',
  ];
  static const _clienteMal = [
    'Tiempo de espera',
    'Actitud',
    'Problema mal descrito',
    'Ubicación difícil',
    'No estuvo disponible',
    'Cambió lo acordado',
  ];

  static List<String> para({
    required bool paraTecnico,
    required int estrellas,
  }) {
    final bien = estrellas >= 4;
    return paraTecnico
        ? (bien ? _tecnicoBien : _tecnicoMal)
        : (bien ? _clienteBien : _clienteMal);
  }
}

Future<DatosResena?> mostrarDialogoResena(
  BuildContext context, {
  required String nombre,
  required bool paraTecnico,
}) {
  return showModalBottomSheet<DatosResena>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _HojaResena(nombre: nombre, paraTecnico: paraTecnico),
  );
}

class _HojaResena extends StatefulWidget {
  const _HojaResena({required this.nombre, required this.paraTecnico});

  final String nombre;
  final bool paraTecnico;

  @override
  State<_HojaResena> createState() => _HojaResenaState();
}

class _HojaResenaState extends State<_HojaResena> {
  int _estrellas = 0;
  final _etiquetas = <String>{};
  final _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  void _elegir(int valor) {
    setState(() {
      if ((_estrellas >= 4) != (valor >= 4)) _etiquetas.clear();
      _estrellas = valor;
    });
  }

  void _enviar() {
    final texto = _comentario.text.trim();
    Navigator.pop<DatosResena>(context, (
      estrellas: _estrellas,
      etiquetas: _etiquetas.toList(),
      comentario: texto.isEmpty ? null : texto,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final opciones = _estrellas == 0
        ? const <String>[]
        : EtiquetasResena.para(
            paraTecnico: widget.paraTecnico,
            estrellas: _estrellas,
          );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.l,
            0,
            Espacios.l,
            Espacios.l,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.paraTecnico
                    ? '¿Cómo calificas al técnico?'
                    : '¿Cómo calificas al cliente?',
                textAlign: TextAlign.center,
                style: textos.titleMedium,
              ),
              const SizedBox(height: Espacios.s),
              Text(
                widget.nombre,
                textAlign: TextAlign.center,
                style: textos.headlineSmall,
              ),
              const SizedBox(height: Espacios.m),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      tooltip: '$i ${i == 1 ? "estrella" : "estrellas"}',
                      onPressed: () => _elegir(i),
                      iconSize: 44,
                      icon: Icon(
                        Icons.star_rounded,
                        color: i <= _estrellas
                            ? Colores.estrella
                            : Colores.linea,
                      ),
                    ),
                ],
              ),
              if (_estrellas > 0) ...[
                const SizedBox(height: Espacios.m),
                Text(
                  _estrellas >= 4 ? '¿Qué fue lo mejor?' : '¿Qué salió mal?',
                  textAlign: TextAlign.center,
                  style: textos.titleSmall,
                ),
                const SizedBox(height: Espacios.m),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: Espacios.s,
                  runSpacing: Espacios.s,
                  children: [
                    for (final e in opciones)
                      FilterChip(
                        label: Text(e),
                        selected: _etiquetas.contains(e),
                        showCheckmark: false,
                        onSelected: (v) => setState(
                          () => v ? _etiquetas.add(e) : _etiquetas.remove(e),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Espacios.m),
                TextField(
                  controller: _comentario,
                  maxLines: 3,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    hintText: 'Comentario (opcional)',
                  ),
                ),
              ],
              const SizedBox(height: Espacios.m),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                onPressed: _estrellas == 0 ? null : _enviar,
                child: Text(
                  widget.paraTecnico
                      ? 'Calificar técnico'
                      : 'Calificar cliente',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
