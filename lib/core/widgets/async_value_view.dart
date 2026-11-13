// Dibuja la pantalla según un [AsyncValue] de Riverpod: carga, error (con
// botón de reintentar) o datos. La carga es un spinner, salvo que la pantalla
// pase su propio [cargando] (por ejemplo un `EsqueletoCarga`).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_failure.dart';
import 'estado_mensaje.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.onData,
    this.onError,
    this.onRetry,
    this.cargando,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context, String message)? onError;
  final VoidCallback? onRetry;

  /// Lo que se ve mientras carga. Si es null, un spinner centrado.
  final WidgetBuilder? cargando;

  /// Mensaje para el usuario: el de [AppFailure] o uno genérico.
  static String mensajeDe(Object error) => error is AppFailure
      ? error.message
      : 'Ocurrió un error inesperado. Inténtalo de nuevo.';

  @override
  Widget build(BuildContext context) {
    return value.when(
      // Al reintentar tras un error se muestra la carga; al refrescar datos
      // que ya se ven, se mantienen en pantalla.
      skipLoadingOnRefresh: !value.hasError,
      data: (data) => onData(context, data),
      loading: () =>
          cargando?.call(context) ??
          const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        final mensaje = mensajeDe(error);
        return onError?.call(context, mensaje) ??
            _ErrorPorDefecto(mensaje, onRetry);
      },
    );
  }
}

class _ErrorPorDefecto extends StatelessWidget {
  const _ErrorPorDefecto(this.mensaje, this.onRetry);

  final String mensaje;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EstadoMensaje(
      icono: Icons.cloud_off_outlined,
      tipo: TipoEstado.error,
      titulo: 'Algo salió mal',
      mensaje: mensaje,
      textoAccion: onRetry == null ? null : 'Reintentar',
      onAccion: onRetry,
    );
  }
}
