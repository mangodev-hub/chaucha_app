import 'package:flutter/foundation.dart';

import '../errors/app_failure.dart';

abstract final class Reintento {
  static const int maximo = 3;
  static const Duration esperaInicial = Duration(milliseconds: 400);

  /// Para `ProviderContainer(retry: ...)`: cuánto esperar antes del intento
  /// número [intento] + 1, o null para no reintentar y mostrar el error.
  static Duration? decidir(int intento, Object error) {
    if (intento == 0) _registrar(error);
    // Los Error de Dart son fallas de programación: no se reintentan.
    if (error is AppFailure || error is Error) return null;
    if (intento >= maximo) return null;
    return esperaInicial * (1 << intento);
  }

  static void _registrar(Object error) {
    final causa = error is AppFailure ? error.cause : null;
    debugPrint(
      'Error al cargar datos: $error'
      '${causa == null ? '' : '\n  Causa: $causa'}',
    );
  }
}
