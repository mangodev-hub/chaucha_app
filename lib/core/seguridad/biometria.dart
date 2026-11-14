import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

enum ResultadoBiometria { confirmada, cancelada, noDisponible }

/// Face ID o huella del celular. La biometría no sale del dispositivo: solo
/// se sabe si quien lo usa es su dueño.
class Biometria {
  Biometria([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<ResultadoBiometria> confirmar(String motivo) async {
    if (kIsWeb) return ResultadoBiometria.noDisponible;
    try {
      final soportada = await _auth.isDeviceSupported();
      final registradas = soportada
          ? await _auth.getAvailableBiometrics()
          : const <BiometricType>[];
      if (registradas.isEmpty) return ResultadoBiometria.noDisponible;
      final ok = await _auth.authenticate(
        localizedReason: motivo,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      return ok ? ResultadoBiometria.confirmada : ResultadoBiometria.cancelada;
    } on LocalAuthException catch (e) {
      return switch (e.code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.timeout => ResultadoBiometria.cancelada,
        // Sin huella/rostro registrado, bloqueada o con error: se usa la cámara.
        _ => ResultadoBiometria.noDisponible,
      };
    } catch (_) {
      return ResultadoBiometria.noDisponible;
    }
  }
}

final biometriaProvider = Provider<Biometria>((ref) => Biometria());
