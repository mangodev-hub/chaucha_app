import 'package:flutter/foundation.dart';

abstract final class AuthRedirect {
  static const String esquemaMovil = 'com.eagledev.tecnicosapp';
  static const String hostCallback = 'login-callback';

  static String get url =>
      kIsWeb ? Uri.base.origin : '$esquemaMovil://$hostCallback';

  static bool vieneDeConfirmacion = false;

  static void detectar() {
    if (!kIsWeb) return;
    vieneDeConfirmacion = Uri.base.queryParameters.containsKey('code');
  }
}
