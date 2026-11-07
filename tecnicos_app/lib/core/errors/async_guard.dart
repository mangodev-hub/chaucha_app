// `AsyncValue.guard` que además registra en consola los errores que no son
// [AppFailure] (los inesperados), para no perder su rastro.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_failure.dart';

Future<AsyncValue<T>> asyncGuard<T>(Future<T> Function() accion) async {
  final resultado = await AsyncValue.guard(accion);
  if (resultado case AsyncError(:final error, :final stackTrace)
      when error is! AppFailure) {
    debugPrint('Error inesperado: $error\n$stackTrace');
  }
  return resultado;
}
