import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/mensajes.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../providers/notificaciones_provider.dart';

/// Muestra un aviso cuando llega una notificación nueva con la app abierta.
class EscuchaNotificaciones extends ConsumerStatefulWidget {
  const EscuchaNotificaciones({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<EscuchaNotificaciones> createState() => _EstadoEscucha();
}

class _EstadoEscucha extends ConsumerState<EscuchaNotificaciones> {
  final _vistas = <String>{};
  bool _primera = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(notificacionesNoLeidasProvider, (_, next) {
      next.whenData((lista) {
        final nuevas = lista.where((n) => !_vistas.contains(n.id)).toList();
        _vistas.addAll(lista.map((n) => n.id));
        if (_primera) {
          _primera = false;
          return;
        }
        if (nuevas.isEmpty || !mounted) return;
        // Sanción nueva o terminada: recarga el usuario para mostrar/quitar
        // el banner sin cerrar sesión.
        if (nuevas.any((n) => n.tipo == 'sancion' || n.tipo == 'sancion_fin')) {
          ref.read(sesionProvider.notifier).recargarUsuario();
        }
        context.mostrarMensaje(nuevas.first.contenido, titulo: 'Novedad');
      });
    });
    return widget.child;
  }
}
