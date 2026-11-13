// Envuelve una llamada a Supabase y traduce sus excepciones.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/app_failure.dart';

Future<R> supabaseGuard<R>(Future<R> Function() action) async {
  try {
    return await action();
  } on AuthException catch (e) {
    throw AppFailure(_mensajeAuth(e), code: e.statusCode, cause: e);
  } on PostgrestException catch (e) {
    throw AppFailure(_mensajePostgrest(e), code: e.code, cause: e);
  } on StorageException catch (e) {
    throw AppFailure(
      'No se pudo subir o leer el archivo. Inténtalo de nuevo.',
      code: e.statusCode,
      cause: e,
    );
  } on FunctionException catch (e) {
    throw AppFailure(mensajeFuncion(e), code: '${e.status}', cause: e);
  }
}

/// Error de una Edge Function. 429: el límite de uso (Redis) se superó y la
/// función dice cuántos segundos esperar.
String mensajeFuncion(FunctionException e) {
  final detalles = e.details;
  if (e.status == 429) {
    final segundos = detalles is Map ? detalles['reintentar_en'] : null;
    return segundos is num && segundos > 0
        ? 'Hiciste muchos intentos seguidos. Espera ${segundos.ceil()} s '
              'e inténtalo de nuevo.'
        : 'Hiciste muchos intentos seguidos. Espera un momento e inténtalo '
              'de nuevo.';
  }
  final texto = detalles is Map ? detalles['error'] : null;
  return texto is String && texto.trim().isNotEmpty
      ? texto
      : 'No se pudo completar la operación. Inténtalo de nuevo.';
}

String _mensajeAuth(AuthException e) {
  // Primero por código (más estable que el texto en inglés de Supabase).
  switch (e.code) {
    case 'same_password':
      return 'La nueva contraseña debe ser distinta de la anterior.';
    case 'weak_password':
      return 'La contraseña es muy débil. Usa una más segura.';
    case 'session_not_found' || 'session_expired':
      return 'Tu enlace o tu sesión expiró. Pide un enlace nuevo.';
  }
  final texto = e.message.toLowerCase();
  if (texto.contains('invalid login credentials')) {
    return 'Correo o contraseña incorrectos.';
  }
  if (texto.contains('email not confirmed')) {
    return 'Debes confirmar tu correo antes de iniciar sesión.';
  }
  if (texto.contains('already registered')) {
    return 'Ya existe una cuenta con ese correo.';
  }

  if (texto.contains('database error saving new user')) {
    return 'No se pudo crear la cuenta. Verifica tu cédula: '
        'puede que ya esté registrada.';
  }
  return 'No se pudo completar la autenticación.';
}

String _mensajePostgrest(PostgrestException e) {
  return switch (e.code) {
    '42501' => 'No tienes permiso para realizar esta acción.',
    '23505' => 'Este registro ya existe.',
    '23503' => 'El registro relacionado no existe.',
    '23514' => 'Los datos no cumplen las reglas permitidas.',
    'P0001' => e.message,
    _ => 'No se pudo completar la operación. Inténtalo de nuevo.',
  };
}
