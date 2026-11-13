import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/chat/data/repositories/supabase_chat_repository.dart';
import 'package:tecnicos_app/features/chat/domain/entities/conversacion.dart';
import 'package:tecnicos_app/features/chat/domain/entities/conversacion_pendiente.dart';
import 'package:tecnicos_app/features/chat/domain/entities/mensaje.dart';
import 'package:tecnicos_app/features/chat/domain/entities/resumen_chat.dart';
import 'package:tecnicos_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:tecnicos_app/features/chat/presentation/providers/enviar_mensaje_provider.dart';
import 'package:tecnicos_app/features/chat/presentation/providers/mensajes_provider.dart';

class _ChatFalso implements ChatRepository {
  final flujo = StreamController<List<Mensaje>>.broadcast();
  final enviados = <({String conversacionId, String texto})>[];

  /// Si no es null, `enviar` espera a que se complete.
  Completer<void>? envioPendiente;
  AppFailure? fallaAlEnviar;

  Future<void> cerrar() => flujo.close();

  @override
  Stream<List<Mensaje>> mensajes(String conversacionId) => flujo.stream;

  @override
  Future<List<ConversacionPendiente>> porResponder() async => const [];

  @override
  Future<Conversacion> conversacion(String conversacionId) async =>
      Conversacion(id: conversacionId, solicitudId: 's1', tecnicoId: 't1');

  @override
  Future<void> enviar({
    required String conversacionId,
    required String texto,
  }) async {
    enviados.add((conversacionId: conversacionId, texto: texto));
    final pendiente = envioPendiente;
    if (pendiente != null) await pendiente.future;
    final falla = fallaAlEnviar;
    if (falla != null) throw falla;
  }

  @override
  Future<String> obtenerOCrearConversacion({
    required String solicitudId,
    required String tecnicoId,
  }) async => 'c1';

  @override
  Future<List<ResumenChat>> misChats() async => const [];
}

Mensaje _mensaje(String id) => Mensaje(
  id: id,
  conversacionId: 'c1',
  autorId: 'u1',
  contenido: 'Hola $id',
  enviadoEn: DateTime(2026),
);

Future<void> _esperar() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _ChatFalso chat;
  late ProviderContainer container;

  setUp(() {
    chat = _ChatFalso();
    container = ProviderContainer.test(
      // Sin reintentos automáticos: los tests deben ser deterministas.
      retry: (_, _) => null,
      overrides: [chatRepositoryProvider.overrideWithValue(chat)],
    );
  });

  tearDown(() => chat.cerrar());

  group('mensajesProvider', () {
    test('emite los mensajes del stream', () async {
      container.listen(mensajesProvider('c1'), (_, _) {});
      expect(container.read(mensajesProvider('c1')).isLoading, isTrue);

      chat.flujo.add([_mensaje('m1'), _mensaje('m2')]);
      await _esperar();

      final mensajes = container.read(mensajesProvider('c1')).value;
      expect(mensajes?.map((m) => m.id), ['m1', 'm2']);
    });

    test('expone el AppFailure cuando el stream falla', () async {
      container.listen(mensajesProvider('c1'), (_, _) {});

      chat.flujo.addError(
        const AppFailure('No se pudo conectar al chat. Revisa tu conexión.'),
      );
      await _esperar();

      final error = container.read(mensajesProvider('c1')).error;
      expect(error, isA<AppFailure>());
      expect((error! as AppFailure).message, contains('conectar al chat'));
    });
  });

  group('enviarMensajeProvider', () {
    EnviarMensajeNotifier notifier() =>
        container.read(enviarMensajeProvider('c1').notifier);

    setUp(() => container.listen(enviarMensajeProvider('c1'), (_, _) {}));

    test('ignora textos vacíos', () async {
      expect(await notifier().enviar('   '), isFalse);
      expect(chat.enviados, isEmpty);
    });

    test('envía a la conversación correcta', () async {
      expect(await notifier().enviar('Hola'), isTrue);
      expect(chat.enviados.single, (conversacionId: 'c1', texto: 'Hola'));
      expect(container.read(enviarMensajeProvider('c1')).hasError, isFalse);
    });

    test('si falla devuelve false y deja el error en el estado', () async {
      chat.fallaAlEnviar = const AppFailure('No tienes permiso.');

      expect(await notifier().enviar('Hola'), isFalse);

      final error = container.read(enviarMensajeProvider('c1')).error;
      expect((error! as AppFailure).message, 'No tienes permiso.');
    });

    test(
      'ignora un segundo envío mientras el primero sigue en curso',
      () async {
        chat.envioPendiente = Completer<void>();

        final primero = notifier().enviar('uno');
        expect(container.read(enviarMensajeProvider('c1')).isLoading, isTrue);
        expect(await notifier().enviar('dos'), isFalse);

        chat.envioPendiente!.complete();
        expect(await primero, isTrue);
        expect(chat.enviados.map((e) => e.texto), ['uno']);
      },
    );
  });
}
