import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/reclamo.dart';
import '../providers/reclamos_provider.dart';
import 'formulario_reclamo.dart';
import 'reclamo_widgets.dart';

class TarjetaGarantia extends ConsumerWidget {
  const TarjetaGarantia({
    super.key,
    required this.solicitudId,
    required this.completadaEn,
    required this.esCliente,
    this.ahora,
  });

  final String solicitudId;
  final DateTime completadaEn;
  final bool esCliente;

  /// Solo para pruebas.
  final DateTime? ahora;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final garantia = Garantia(completadaEn: completadaEn);
    final hoy = ahora ?? DateTime.now();
    final vigente = garantia.vigente(hoy);
    final abierto = ref.watch(reclamoAbiertoProvider(solicitudId)).value;
    final dias = garantia.diasRestantes(hoy);

    final Widget accion;
    if (abierto != null) {
      accion = _FilaReclamo(
        reclamo: abierto,
        onTap: () => unawaited(
          context.push(AppRoutes.reclamo(abierto.id, esCliente: esCliente)),
        ),
      );
    } else if (vigente) {
      accion = OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radios.pequeno),
          ),
        ),
        onPressed: () => unawaited(
          reportarProblema(
            context,
            solicitudId: solicitudId,
            esCliente: esCliente,
          ),
        ),
        icon: const Icon(Icons.report_gmailerrorred_outlined),
        label: const Text('Reportar un problema'),
      );
    } else {
      accion = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Espacios.l),
      child: TarjetaApp(
        color: vigente ? Colores.tarjeta : Colores.superficie,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: vigente ? Colores.primarioVivo : Colores.tintaSuave,
                ),
                const SizedBox(width: Espacios.s),
                Expanded(
                  child: Text(
                    'Garantía ChauchaApp',
                    style: textos.titleSmall?.copyWith(
                      color: vigente ? Colores.tinta : Colores.tintaSuave,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacios.s),
            Text(
              vigente
                  ? (dias == 1
                        ? 'Te queda 1 día de garantía'
                        : 'Te quedan $dias días de garantía')
                  : 'La garantía terminó el ${Formatos.fechaCorta(garantia.vence)}',
              style: textos.bodyMedium?.copyWith(
                color: vigente ? Colores.tinta : Colores.tintaSuave,
              ),
            ),
            if (vigente) ...[
              const SizedBox(height: Espacios.s),
              ClipRRect(
                borderRadius: BorderRadius.circular(Radios.pildora),
                child: LinearProgressIndicator(
                  value: garantia.fraccionRestante(hoy),
                  minHeight: 4,
                  color: Colores.primarioVivo,
                  backgroundColor: Colores.linea,
                  semanticsLabel: 'Garantía restante',
                ),
              ),
            ],
            if (abierto != null || vigente) ...[
              const SizedBox(height: Espacios.m),
              accion,
            ],
          ],
        ),
      ),
    );
  }
}

class _FilaReclamo extends StatelessWidget {
  const _FilaReclamo({required this.reclamo, required this.onTap});

  final Reclamo reclamo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colores.superficie,
      borderRadius: BorderRadius.circular(Radios.pequeno),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.pequeno),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.m,
            vertical: Espacios.s + 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Reclamo ${reclamo.codigo}',
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              PildoraEstadoReclamo(reclamo.estado),
              const SizedBox(width: Espacios.xs),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
