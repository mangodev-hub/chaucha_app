import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/core/supabase/supabase_guard.dart';

/// El mensaje del [AppFailure] que lanza el guard ante [error].
Future<String> _mensajePara(Exception error) async {
  try {
    await supabaseGuard<void>(() async => throw error);
  } on AppFailure catch (fallo) {
    return fallo.message;
  }
  fail('supabaseGuard no lanzó AppFailure');
}

void main() {
  group('errores de autenticación por código', () {
    test('same_password: la contraseña nueva es igual a la anterior', () async {
      expect(
        await _mensajePara(
          const AuthException(
            'New password should be different from the old password.',
            statusCode: '422',
            code: 'same_password',
          ),
        ),
        'La nueva contraseña debe ser distinta de la anterior.',
      );
    });

    test('weak_password: la contraseña es muy débil', () async {
      expect(
        await _mensajePara(
          const AuthException(
            'Password should be at least 6 characters.',
            statusCode: '422',
            code: 'weak_password',
          ),
        ),
        'La contraseña es muy débil. Usa una más segura.',
      );
    });

    test('session_not_found: el enlace expiró', () async {
      expect(
        await _mensajePara(
          const AuthException(
            'Session not found',
            statusCode: '403',
            code: 'session_not_found',
          ),
        ),
        'Tu enlace o tu sesión expiró. Pide un enlace nuevo.',
      );
    });
  });

  test('sin código, se reconoce por el texto', () async {
    expect(
      await _mensajePara(const AuthException('Invalid login credentials')),
      'Correo o contraseña incorrectos.',
    );
  });

  test('un error desconocido da el mensaje genérico', () async {
    expect(
      await _mensajePara(
        const AuthException('Algo raro', code: 'unexpected_failure'),
      ),
      'No se pudo completar la autenticación.',
    );
  });

  group('Edge Functions', () {
    test('429 del límite de uso: dice cuánto esperar', () async {
      expect(
        await _mensajePara(
          const FunctionException(
            status: 429,
            details: {'error': 'Demasiados', 'reintentar_en': 42},
          ),
        ),
        'Hiciste muchos intentos seguidos. Espera 42 s e inténtalo de nuevo.',
      );
    });

    test('429 sin segundos', () async {
      expect(
        await _mensajePara(const FunctionException(status: 429)),
        'Hiciste muchos intentos seguidos. Espera un momento e inténtalo '
        'de nuevo.',
      );
    });

    test('otro error usa el texto de la función', () async {
      expect(
        await _mensajePara(
          const FunctionException(
            status: 400,
            details: {'error': 'Primero sube tu foto de perfil.'},
          ),
        ),
        'Primero sube tu foto de perfil.',
      );
    });
  });
}
