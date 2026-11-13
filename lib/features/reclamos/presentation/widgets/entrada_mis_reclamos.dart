// Acceso a "Mis reclamos" desde Mi perfil (cliente y técnico).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/reclamo.dart';

class EntradaMisReclamos extends StatelessWidget {
  const EntradaMisReclamos({super.key, required this.esCliente});

  final bool esCliente;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      onTap: () =>
          unawaited(context.push(AppRoutes.misReclamos(esCliente: esCliente))),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colores.primarioSuave,
              borderRadius: BorderRadius.circular(Radios.pequeno),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Colores.primarioVivo,
            ),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mis reclamos', style: textos.titleSmall),
                Text(
                  'Garantía de $diasGarantia días en cada servicio.',
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colores.tintaSuave),
        ],
      ),
    );
  }
}
