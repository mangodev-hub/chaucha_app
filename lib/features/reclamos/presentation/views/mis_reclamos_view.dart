import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/pantalla_secundaria.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/reclamo.dart';
import '../providers/reclamos_provider.dart';
import '../widgets/reclamo_widgets.dart';

class MisReclamosView extends ConsumerWidget {
  const MisReclamosView({super.key, required this.esCliente});

  final bool esCliente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reclamos = ref.watch(misReclamosProvider);
    return PantallaSecundaria(
      titulo: 'Mis reclamos',
      cuerpo: AsyncValueView<List<Reclamo>>(
        value: reclamos,
        onRetry: () => ref.invalidate(misReclamosProvider),
        onData: (context, lista) {
          if (lista.isEmpty) {
            return const EstadoMensaje(
              icono: Icons.verified_user_outlined,
              mensaje:
                  'No tienes reclamos. Si algo falla en un servicio, '
                  'tienes $diasGarantia días para reportarlo.',
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                esperarSinError(ref.refresh(misReclamosProvider.future)),
            child: ListaDePagina(
              padding: const EdgeInsets.all(Espacios.l),
              children: [
                for (final (i, r) in lista.indexed) ...[
                  if (i > 0) const SizedBox(height: Espacios.m),
                  FilaReclamo(
                    reclamo: r,
                    onTap: () => unawaited(
                      context.push(
                        AppRoutes.reclamo(r.id, esCliente: esCliente),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Un reclamo en una lista: código, estado, categoría, servicio y fecha.
/// En el panel del asesor muestra además quién reporta y los días abierto.
class FilaReclamo extends StatelessWidget {
  const FilaReclamo({
    super.key,
    required this.reclamo,
    required this.onTap,
    this.paraAsesor = false,
  });

  final Reclamo reclamo;
  final VoidCallback onTap;
  final bool paraAsesor;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final r = reclamo;
    final dias = r.diasAbierto(DateTime.now());
    final detalle = paraAsesor
        ? '${r.autorNombre ?? 'Usuario'} → ${r.contraNombre ?? 'Sin datos'}'
        : [r.oficio, r.servicio].whereType<String>().join(' · ');
    return TarjetaApp(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(r.codigo, style: textos.titleSmall)),
              PildoraEstadoReclamo(r.estado),
            ],
          ),
          const SizedBox(height: Espacios.xs),
          Text(
            r.categoria.etiqueta,
            style: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            detalle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
          const SizedBox(height: Espacios.xs),
          Text(
            paraAsesor && r.estado.abierto
                ? 'Abierto hace ${dias == 1 ? '1 día' : '$dias días'}'
                : Formatos.fechaCorta(r.creadoEn),
            style: textos.labelSmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}
