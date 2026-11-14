import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/filtro_chips.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/presentation/widgets/solicitud_widgets.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../providers/admin_providers.dart';
import '../widgets/admin_widgets.dart';

class AdminSolicitudesView extends ConsumerStatefulWidget {
  const AdminSolicitudesView({super.key});

  @override
  ConsumerState<AdminSolicitudesView> createState() =>
      _AdminSolicitudesViewState();
}

class _AdminSolicitudesViewState extends ConsumerState<AdminSolicitudesView> {
  String _busqueda = '';

  /// null = todas.
  EstadoSolicitud? _estado;

  @override
  Widget build(BuildContext context) {
    final solicitudes = ref.watch(solicitudesAdminProvider);
    return PantallaAdmin(
      titulo: 'Solicitudes',
      subtitulo: 'Todo lo que publicaron los clientes.',
      onRecargar: () =>
          esperarSinError(ref.refresh(solicitudesAdminProvider.future)),
      filtros: [
        BuscadorAdmin(
          hint: 'Buscar por oficio, descripción o cliente',
          onCambio: (texto) => setState(() => _busqueda = texto),
        ),
        FiltroChips<EstadoSolicitud?>(
          opciones: [
            (null, 'Todas'),
            for (final e in EstadoSolicitud.values) (e, e.etiqueta),
          ],
          seleccionado: _estado,
          onCambio: (estado) => setState(() => _estado = estado),
        ),
      ],
      children: [
        AsyncValueView<List<SolicitudAdmin>>(
          value: solicitudes,
          onRetry: () => ref.invalidate(solicitudesAdminProvider),
          onData: (context, lista) {
            final visibles = [
              for (final s in lista)
                if ((_estado == null || s.solicitud.estado == _estado) &&
                    s.coincide(_busqueda))
                  s,
            ];
            if (visibles.isEmpty) {
              return const EstadoMensaje(
                compacto: true,
                icono: Icons.search_off,
                mensaje: 'No hay solicitudes con esos filtros.',
              );
            }
            return CuadriculaAdaptable(
              children: [
                for (final s in visibles)
                  SolicitudCard(
                    solicitud: s.solicitud,
                    onTap: () => unawaited(_verFicha(context, s)),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Ficha de la solicitud en una hoja inferior.
Future<void> _verFicha(BuildContext context, SolicitudAdmin s) {
  final solicitud = s.solicitud;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (hoja) {
      final textos = Theme.of(hoja).textTheme;
      Widget dato(IconData icono, String etiqueta, String valor) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icono, color: Colores.primario),
        title: Text(
          etiqueta,
          style: textos.labelMedium?.copyWith(color: Colores.tintaSuave),
        ),
        subtitle: Text(valor, style: textos.bodyLarge),
      );
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.xl,
            0,
            Espacios.xl,
            Espacios.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      solicitud.oficioNombre,
                      style: textos.titleLarge,
                    ),
                  ),
                  EstadoChip(solicitud.estado),
                ],
              ),
              const SizedBox(height: Espacios.m),
              Text(solicitud.descripcion, style: textos.bodyLarge),
              const SizedBox(height: Espacios.m),
              dato(Icons.person_outline, 'Cliente', s.cliente),
              dato(
                Icons.event_outlined,
                'Publicada',
                Formatos.fecha(solicitud.creadoEn),
              ),
              if (solicitud.direccionReferencia case final direccion?)
                dato(Icons.place_outlined, 'Referencia', direccion),
              dato(Icons.tag, 'Código', solicitud.id),
            ],
          ),
        ),
      );
    },
  );
}
