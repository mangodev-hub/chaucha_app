import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/mensajes.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../perfil_puntos/presentation/providers/verificacion_provider.dart';
import '../../domain/entities/notificacion.dart';
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

  Future<void> _avisar(List<Notificacion> nuevas) async {
    const recargan = {'sancion', 'sancion_fin', 'verificacion'};
    final verificacion = nuevas.any((n) => n.tipo == 'verificacion');
    if (verificacion) ref.invalidate(verificacionProvider);
    if (nuevas.any((n) => recargan.contains(n.tipo))) {
      try {
        await ref.read(sesionProvider.notifier).recargarUsuario();
      } catch (_) {}
    }
    if (!mounted) return;
    // Cuenta recién verificada: ya sale la celebración, no hace falta el aviso.
    final soloVerificacion = nuevas.every((n) => n.tipo == 'verificacion');
    if (soloVerificacion &&
        (ref.read(usuarioActualProvider)?.verificado ?? false)) {
      return;
    }
    context.mostrarMensaje(nuevas.first.contenido, titulo: 'Novedad');
  }

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
        unawaited(_avisar(nuevas));
      });
    });
    return widget.child;
  }
}
