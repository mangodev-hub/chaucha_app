import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tecnicos_app/core/seguridad/biometria.dart';

class _Auth extends LocalAuthentication {
  _Auth({this.registradas = const [BiometricType.face], this.resultado});

  final List<BiometricType> registradas;
  final Object? resultado;

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => registradas;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<dynamic> authMessages = const [],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async {
    final r = resultado;
    if (r is LocalAuthException) throw r;
    return r as bool? ?? true;
  }
}

void main() {
  test('con rostro o huella registrada, confirma', () async {
    expect(
      await Biometria(_Auth()).confirmar('x'),
      ResultadoBiometria.confirmada,
    );
  });

  test('sin biometría registrada no está disponible', () async {
    expect(
      await Biometria(_Auth(registradas: const [])).confirmar('x'),
      ResultadoBiometria.noDisponible,
    );
  });

  test('si la persona cancela, se cancela', () async {
    final auth = _Auth(
      resultado: const LocalAuthException(
        code: LocalAuthExceptionCode.userCanceled,
      ),
    );
    expect(await Biometria(auth).confirmar('x'), ResultadoBiometria.cancelada);
  });

  test('bloqueada por intentos: se usa la cámara', () async {
    final auth = _Auth(
      resultado: const LocalAuthException(
        code: LocalAuthExceptionCode.biometricLockout,
      ),
    );
    expect(
      await Biometria(auth).confirmar('x'),
      ResultadoBiometria.noDisponible,
    );
  });
}
