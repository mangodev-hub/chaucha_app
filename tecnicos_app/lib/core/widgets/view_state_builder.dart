// Dibuja la pantalla según el [ViewState] de un store .
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../state/view_state.dart';





class ViewStateBuilder<T> extends StatelessWidget {
  const ViewStateBuilder({
    super.key,
    required this.listenable,
    required this.onLoaded,
    this.onInitial,
    this.onError,
    this.onRetry,
  });

  final ValueListenable<ViewState<T>> listenable;
  final Widget Function(BuildContext context, T data) onLoaded;
  final WidgetBuilder? onInitial;
  final Widget Function(BuildContext context, String message)? onError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ViewState<T>>(
      valueListenable: listenable,
      builder: (context, state, _) => switch (state) {
        ViewInitial<T>() => onInitial?.call(context) ?? const SizedBox.shrink(),
        ViewLoading<T>() => const Center(child: CircularProgressIndicator()),
        ViewLoaded<T>(:final data) => onLoaded(context, data),
        ViewError<T>(:final message) =>
          onError?.call(context, message) ?? _DefaultError(message, onRetry),
      },
    );
  }
}

class _DefaultError extends StatelessWidget {
  const _DefaultError(this.message, this.onRetry);

  final String message;
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
            Text(message, textAlign: TextAlign.center),
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
