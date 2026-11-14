import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/perfil_cliente_provider.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';
import '../../../solicitudes/presentation/providers/detalle_provider.dart';
import '../../data/repositories/supabase_perfil_repository.dart';
import '../../domain/entities/calificacion_pendiente.dart';
import '../../domain/entities/nueva_resena.dart';
import 'resena_dialog.dart';

/// Pide revisar las calificaciones pendientes ahora (por ejemplo, justo
/// después de que el cliente confirma el trabajo).
final revisarCalificacionesProvider = NotifierProvider<_Revisar, int>(
  _Revisar.new,
);

class _Revisar extends Notifier<int> {
  @override
  int build() => 0;

  void ahora() => state++;
}

class EscuchaCalificaciones extends ConsumerStatefulWidget {
  const EscuchaCalificaciones({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<EscuchaCalificaciones> createState() =>
      _EscuchaCalificacionesState();
}

class _EscuchaCalificacionesState extends ConsumerState<EscuchaCalificaciones> {
  /// Notificaciones de cierre ya vistas (para reaccionar solo a las nuevas).
  final _vistas = <String>{};

  /// Solicitudes a las que se dijo "Ahora no" en esta ejecución.
  final _omitidas = <String>{};
  bool _abierta = false;
  bool _primera = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revisar());
  }

  Future<void> _revisar() async {
    final usuario = ref.read(usuarioActualProvider);
    if (_abierta || usuario == null || usuario.rol == Rol.admin) return;
    _abierta = true;
    try {
      final pendientes = await ref
          .read(perfilRepositoryProvider)
          .calificacionesPendientes();
      for (final p in pendientes) {
        if (!mounted) return;
        if (_omitidas.contains(p.solicitudId)) continue;
        final calificada = await _calificar(p);
        if (!calificada) _omitidas.add(p.solicitudId);
        // De a una, como en las apps de viajes: la siguiente al volver.
        break;
      }
    } catch (_) {
      // Sin conexión: se intentará la próxima vez.
    } finally {
      _abierta = false;
    }
  }

  Future<bool> _calificar(CalificacionPendiente p) async {
    final datos = await mostrarDialogoResena(
      context,
      nombre: p.nombre,
      paraTecnico: p.paraTecnico,
      contexto: p.oficio == null
          ? 'Servicio terminado'
          : 'Servicio de ${p.oficio} terminado',
    );
    if (datos == null || !mounted) return false;
    try {
      await ref
          .read(perfilRepositoryProvider)
          .crearResena(
            NuevaResena(
              solicitudId: p.solicitudId,
              destinatarioId: p.destinatarioId,
              calificacion: datos.estrellas,
              comentario: datos.comentario,
              etiquetas: datos.etiquetas,
            ),
          );
      ref
        ..invalidate(detalleSolicitudProvider(p.solicitudId))
        ..invalidate(historialServiciosProvider);
      if (mounted) {
        context.mostrarMensaje(
          '¡Gracias por tu calificación!',
          tipo: TipoMensaje.exito,
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        context.mostrarMensaje(
          AsyncValueView.mensajeDe(e),
          tipo: TipoMensaje.error,
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // El técnico se entera del cierre por la notificación "cierre".
    ref.listen(notificacionesNoLeidasProvider, (_, next) {
      next.whenData((lista) {
        final nuevas = [
          for (final n in lista)
            if (n.tipo == 'cierre' && !_vistas.contains(n.id)) n,
        ];
        _vistas.addAll(lista.map((n) => n.id));
        if (_primera) {
          _primera = false;
          return;
        }
        if (nuevas.isNotEmpty) unawaited(_revisar());
      });
    });
    // El cliente, al confirmar el trabajo en la app.
    ref.listen(revisarCalificacionesProvider, (_, _) => unawaited(_revisar()));
    return widget.child;
  }
}
