// A dónde vuelve el usuario después de confirmar su correo.
import 'package:flutter/foundation.dart';








abstract final class AuthRedirect {
  static const String esquemaMovil = 'com.eagledev.tecnicosapp';
  static const String hostCallback = 'login-callback';

  static String get url =>
      kIsWeb ? Uri.base.origin : '$esquemaMovil://$hostCallback';
}
