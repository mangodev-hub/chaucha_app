// Configuración de Firebase (solo para notificaciones push), leída de
// --dart-define-from-file=env.json. Es opcional: si faltan las claves de la
// plataforma actual, la app arranca igual y simplemente no recibe push.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract final class FirebaseConfig {
  static const _proyecto = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _remitente = String.fromEnvironment('FIREBASE_SENDER_ID');

  /// Clave pública VAPID (Firebase > Cloud Messaging > Web Push). Solo web.
  static const vapidKey = String.fromEnvironment('FIREBASE_VAPID_KEY');

  /// Opciones para la plataforma actual, o null si no están configuradas.
  static FirebaseOptions? get opciones {
    final (apiKey, appId) = switch (_plataforma) {
      'web' => (
        const String.fromEnvironment('FIREBASE_WEB_API_KEY'),
        const String.fromEnvironment('FIREBASE_WEB_APP_ID'),
      ),
      'android' => (
        const String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
        const String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
      ),
      'ios' => (
        const String.fromEnvironment('FIREBASE_IOS_API_KEY'),
        const String.fromEnvironment('FIREBASE_IOS_APP_ID'),
      ),
      _ => ('', ''),
    };
    if (apiKey.isEmpty || appId.isEmpty || _proyecto.isEmpty) return null;
    if (_plataforma == 'web' && vapidKey.isEmpty) return null;
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: _remitente,
      projectId: _proyecto,
    );
  }

  /// 'web', 'android', 'ios' u 'otra'. Coincide con `dispositivos_push.plataforma`.
  static String get plataforma => _plataforma;

  static String get _plataforma {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => 'otra',
    };
  }
}
