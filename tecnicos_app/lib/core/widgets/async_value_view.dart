// Dibuja la pantalla según un [AsyncValue] de Riverpod. Equivalente de
// [ViewStateBuilder] para las features ya migradas.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_failure.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.onData,
    this.onError,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) onData;
  final Widget Function(BuildContext context, String message)? onError;
  final VoidCallback? onRetry;

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
      loading: () => const Center(child: CircularProgressIndicator()),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}
