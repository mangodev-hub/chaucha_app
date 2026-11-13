// Notificaciones push con Firebase Cloud Messaging.
//
// La app solo registra el token del dispositivo en `dispositivos_push`; el
// envío lo hace la Edge Function `enviar-push` cuando se inserta una fila en
// `notificaciones`. Con la app abierta, el aviso en pantalla sigue saliendo
// de Realtime (EscuchaNotificaciones), así que aquí no se muestra nada.
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/firebase_config.dart';

/// Datos que vienen en el push. Los usa la app al tocarlo.
class ToquePush {
  const ToquePush({required this.tipo, this.referenciaId});

  final String tipo;
  final String? referenciaId;
}

class PushService {
  PushService._(this._activo);

  /// Sin Firebase configurado: todas las operaciones son no-op.
  static final desactivado = PushService._(false);

  final bool _activo;
  String? _token;
  StreamSubscription<String>? _refresco;
  ToquePush? _pendiente;
  final _toques = StreamController<ToquePush>.broadcast();

  /// Inicializa Firebase si hay configuración para esta plataforma.
  static Future<PushService> inicializar() async {
    final opciones = FirebaseConfig.opciones;
    if (opciones == null) return desactivado;
    try {
      await Firebase.initializeApp(options: opciones);
    } catch (e) {
      debugPrint('Push desactivado, Firebase no inicializó: $e');
      return desactivado;
    }
    final servicio = PushService._(true);
    servicio._escucharToques();
    return servicio;
  }

  /// Toques sobre un push con la app en segundo plano.
  Stream<ToquePush> get toques => _toques.stream;

  /// Push que abrió la app desde cerrada. Se entrega una sola vez.
  ToquePush? consumirPendiente() {
    final p = _pendiente;
    _pendiente = null;
    return p;
  }

  /// Pide permiso y guarda el token para el usuario conectado.
  Future<void> registrar(SupabaseClient db) async {
    if (!_activo) return;
    try {
      final fcm = FirebaseMessaging.instance;
      final permiso = await fcm.requestPermission();
      if (permiso.authorizationStatus == AuthorizationStatus.denied) return;

      // getToken/onTokenRefresh están deprecados en firebase_messaging 17
      // a favor de register()/onRegistered (que entrega el FID, no el token).
      // La Edge Function usa el token clásico de HTTP v1, así que se mantienen.
      // ignore: deprecated_member_use
      final token = await fcm.getToken(
        vapidKey: kIsWeb ? FirebaseConfig.vapidKey : null,
      );
      if (token == null) return;
      await _guardar(db, token);

      await _refresco?.cancel();
      // ignore: deprecated_member_use
      _refresco = fcm.onTokenRefresh.listen((nuevo) => _guardar(db, nuevo));
    } catch (e) {
      // El push es un extra: si falla (permiso, navegador sin soporte...),
      // la app sigue funcionando con Realtime.
      debugPrint('No se pudo registrar el push: $e');
    }
  }

  /// Borra el token del usuario actual. Llamar ANTES de cerrar sesión (RLS).
  Future<void> olvidar(SupabaseClient db) async {
    if (!_activo) return;
    await _refresco?.cancel();
    _refresco = null;
    final token = _token;
    _token = null;
    if (token == null) return;
    try {
      await db.from('dispositivos_push').delete().eq('token', token);
    } catch (e) {
      debugPrint('No se pudo borrar el token push: $e');
    }
  }

  Future<void> _guardar(SupabaseClient db, String token) async {
    _token = token;
    await db.rpc(
      'registrar_dispositivo_push',
      params: {'p_token': token, 'p_plataforma': FirebaseConfig.plataforma},
    );
  }

  void _escucharToques() {
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      final t = _desdeMensaje(m);
      if (t != null) _toques.add(t);
    });
    unawaited(
      FirebaseMessaging.instance.getInitialMessage().then((m) {
        if (m != null) _pendiente = _desdeMensaje(m);
      }),
    );
  }

  static ToquePush? _desdeMensaje(RemoteMessage m) {
    final tipo = m.data['tipo'] as String?;
    if (tipo == null) return null;
    final ref = m.data['referencia_id'] as String?;
    return ToquePush(
      tipo: tipo,
      referenciaId: (ref == null || ref.isEmpty) ? null : ref,
    );
  }
}
