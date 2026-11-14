import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class ControlRadio extends StatelessWidget {
  const ControlRadio({
    super.key,
    required this.km,
    required this.onCambio,
    this.onFin,
  });

  final double km;
  final ValueChanged<double> onCambio;
  final ValueChanged<double>? onFin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.fromLTRB(Espacios.m, 6, Espacios.m, 0),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.medio),
        border: Border.all(color: Colores.linea),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Radio: ${km.round()} km',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Slider(
            value: km,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${km.round()} km',
            onChanged: onCambio,
            onChangeEnd: onFin,
          ),
        ],
      ),
    );
  }
}
