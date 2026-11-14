import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/filtro_chips.dart';
import '../../../reclamos/domain/entities/reclamo.dart';
import '../../../reclamos/presentation/providers/reclamos_provider.dart';
import '../../../reclamos/presentation/views/mis_reclamos_view.dart';
import '../widgets/admin_widgets.dart';

class AdminReclamosView extends ConsumerStatefulWidget {
  const AdminReclamosView({super.key});

  @override
  ConsumerState<AdminReclamosView> createState() => _AdminReclamosViewState();
}

class _AdminReclamosViewState extends ConsumerState<AdminReclamosView> {
  FiltroReclamos _filtro = FiltroReclamos.abiertos;

  @override
  Widget build(BuildContext context) {
    final reclamos = ref.watch(reclamosAdminProvider(_filtro));
    return PantallaAdmin(
      titulo: 'Reclamos',
      subtitulo: 'Garantía de 30 días: el más antiguo primero.',
      onRecargar: () async {
        ref.invalidate(reclamosRecibidosProvider);
        await esperarSinError(
          ref.refresh(reclamosAdminProvider(_filtro).future),
        );
      },
      filtros: [
        FiltroChips<FiltroReclamos>(
          opciones: [for (final f in FiltroReclamos.values) (f, f.etiqueta)],
          seleccionado: _filtro,
          onCambio: (f) => setState(() => _filtro = f),
        ),
      ],
      children: [
        AsyncValueView<List<Reclamo>>(
          value: reclamos,
          onRetry: () => ref.invalidate(reclamosAdminProvider(_filtro)),
          onData: (context, lista) {
            if (lista.isEmpty) {
              return const EstadoMensaje(
                compacto: true,
                icono: Icons.verified_user_outlined,
                mensaje: 'No hay reclamos con ese filtro.',
              );
            }
            return CuadriculaAdaptable(
              children: [
                for (final r in lista)
                  FilaReclamo(
                    reclamo: r,
                    paraAsesor: true,
                    onTap: () async {
                      await context.push(
                        AppRoutes.reclamo(r.id, esAdmin: true),
                      );
                      ref
                        ..invalidate(reclamosAdminProvider(_filtro))
                        ..invalidate(reclamosRecibidosProvider);
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
