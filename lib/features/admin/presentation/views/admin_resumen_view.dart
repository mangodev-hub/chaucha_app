import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_portada.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/resumen_admin.dart';
import '../providers/admin_providers.dart';
import '../widgets/admin_widgets.dart';

class AdminResumenView extends ConsumerWidget {
  const AdminResumenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumen = ref.watch(resumenAdminProvider);
    final nombre = ref.watch(usuarioActualProvider)?.nombres;
    final pendientes = resumen.value?.verificacionesPendientes;

    return PantallaAdmin(
      titulo: 'Panel de administración',
      subtitulo: 'Solicitudes, usuarios y verificaciones de ChauchaApp.',
      onRecargar: () =>
          esperarSinError(ref.refresh(resumenAdminProvider.future)),
      children: [
        TarjetaPortada(
          titulo: nombre == null ? 'Hola.' : 'Hola, $nombre.',
          subtitulo: 'Así va la plataforma hoy.',
          icono: Icons.admin_panel_settings_rounded,
          dato: switch (pendientes) {
            null => null,
            0 => 'Sin verificaciones pendientes',
            1 => '1 técnico por verificar',
            final n => '$n técnicos por verificar',
          },
          iconoDato: pendientes == 0
              ? Icons.task_alt_rounded
              : Icons.badge_outlined,
        ),
        if (pendientes != null && pendientes > 0) ...[
          const SizedBox(height: Espacios.l),
          const AvisoBanner(
            tipo: TipoAviso.aviso,
            titulo: 'Hay cédulas por revisar',
            mensaje:
                'Revísalas en la pestaña "Verificaciones" para que esos '
                'técnicos puedan recibir solicitudes.',
          ),
        ],
        Seccion(
          titulo: 'Cifras',
          child: AsyncValueView<ResumenAdmin>(
            value: resumen,
            onRetry: () => ref.invalidate(resumenAdminProvider),
            onData: (context, r) => CuadriculaAdaptable(
              anchoMinimo: 0,
              children: [
                _Cifra(
                  icono: Icons.person_outline,
                  color: Colores.primario,
                  valor: r.clientes,
                  etiqueta: 'Clientes',
                ),
                _Cifra(
                  icono: Icons.engineering_outlined,
                  color: Colores.info,
                  valor: r.tecnicos,
                  etiqueta: 'Técnicos',
                ),
                _Cifra(
                  icono: Icons.verified_outlined,
                  color: Colores.acento,
                  valor: r.tecnicosVerificados,
                  etiqueta: 'Técnicos verificados',
                ),
                _Cifra(
                  icono: Icons.badge_outlined,
                  color: Colores.aviso,
                  valor: r.verificacionesPendientes,
                  etiqueta: 'Verificaciones pendientes',
                ),
                _Cifra(
                  icono: Icons.pending_actions_outlined,
                  color: Colores.info,
                  valor: r.solicitudesAbiertas,
                  etiqueta: 'Solicitudes esperando técnico',
                ),
                _Cifra(
                  icono: Icons.assignment_outlined,
                  color: Colores.primario,
                  valor: r.solicitudes,
                  etiqueta: 'Solicitudes en total',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Cifra extends StatelessWidget {
  const _Cifra({
    required this.icono,
    required this.color,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final Color color;
  final int valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      child: Row(
        children: [
          IconoRecuadro(
            icono: icono,
            color: color,
            fondo: color.withValues(alpha: 0.12),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$valor', style: textos.headlineSmall),
                Text(
                  etiqueta,
                  maxLines: 2,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
