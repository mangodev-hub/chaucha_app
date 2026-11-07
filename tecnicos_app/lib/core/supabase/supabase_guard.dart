// Envuelve una llamada a Supabase y traduce sus excepciones.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/app_failure.dart';

Future<R> supabaseGuard<R>(Future<R> Function() action) async {
  try {
    return await action();
  } on AuthException catch (e) {
    throw AppFailure(_mensajeAuth(e.message), code: e.statusCode, cause: e);
  } on PostgrestException catch (e) {
    throw AppFailure(_mensajePostgrest(e), code: e.code, cause: e);
  } on StorageException catch (e) {
    throw AppFailure(
      'No se pudo subir o leer el archivo. Inténtalo de nuevo.',
      code: e.statusCode,
      cause: e,
    );
  }
}

String _mensajeAuth(String original) {
  final texto = original.toLowerCase();
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
