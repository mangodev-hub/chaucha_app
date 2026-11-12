import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/chat/data/repositories/supabase_chat_repository.dart';
import 'package:tecnicos_app/features/chat/domain/entities/contexto_chat.dart';
import 'package:tecnicos_app/features/chat/presentation/providers/tarifa_chat_provider.dart';
import 'package:tecnicos_app/features/cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/tarifa.dart';

import '../solicitudes/falsos.dart';
import 'falsos.dart';

void main() {
  late ChatFalso chat;
  late CotizacionesFalsas cotizaciones;

  ProviderContainer contenedor(ContextoChat contexto) {
    final container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        chatRepositoryProvider.overrideWithValue(chat),
        cotizacionRepositoryProvider.overrideWithValue(cotizaciones),
        contextoChatProvider.overrideWith((ref, id) => contexto),
      ],
    );
    container.listen(accionesTarifaProvider('k1'), (_, _) {});
    return container;
  }

  AccionesTarifaNotifier acciones(ProviderContainer c) =>
      c.read(accionesTarifaProvider('k1').notifier);

  String? errorDe(ProviderContainer c) =>
      (c.read(accionesTarifaProvider('k1')).error as AppFailure?)?.message;

  setUp(() {
    chat = ChatFalso();
    cotizaciones = CotizacionesFalsas();
  });

  group('enviar', () {
    test('envía el ticket sobre la oferta y avisa al cliente', () async {
      final c = contenedor(contextoDePrueba());

      final ok = await acciones(c).enviar(const NuevaTarifa(precioAcordado: 40));

      expect(ok, isTrue);
      final (cotizacionId, tarifa) = cotizaciones.tarifasEnviadas.single;
      expect(cotizacionId, 'q1');
      expect(tarifa.precioAcordado, 40);
      expect(chat.enviados, isEmpty);
    });

    test('con precio 0 no envía', () async {
      final c = contenedor(contextoDePrueba());

      final ok = await acciones(c).enviar(const NuevaTarifa(precioAcordado: 0));

      expect(ok, isFalse);
      expect(cotizaciones.tarifasEnviadas, isEmpty);
      expect(errorDe(c), contains('mayor que 0'));
    });

    test('con un ticket esperando respuesta no envía otro', () async {
      final c = contenedor(contextoDePrueba(tarifa: tarifaDePrueba));

      final ok = await acciones(c)
          .enviar(const NuevaTarifa(precioAcordado: 40));

      expect(ok, isFalse);
      expect(cotizaciones.tarifasEnviadas, isEmpty);
      expect(chat.enviados, isEmpty);
    });

    test('si falla el aviso en el chat, el ticket igual queda', () async {
      chat.fallaAlEnviar = const AppFailure('Sin conexión.');
      final c = contenedor(contextoDePrueba());

      final ok = await acciones(c)
          .enviar(const NuevaTarifa(precioAcordado: 40));

      expect(ok, isTrue);
      expect(cotizaciones.tarifasEnviadas, hasLength(1));
    });

    test('si la base lo impide, deja el error', () async {
      cotizaciones.fallaAlEnviarTarifa = const AppFailure('Permiso denegado.');
      final c = contenedor(contextoDePrueba());

      final ok = await acciones(c)
          .enviar(const NuevaTarifa(precioAcordado: 40));

      expect(ok, isFalse);
      expect(errorDe(c), 'Permiso denegado.');
      expect(chat.enviados, isEmpty);
    });
  });

  group('confirmar', () {
    test('acepta la oferta con su ticket y avisa al técnico', () async {
      final c = contenedor(contextoDePrueba(tarifa: tarifaDePrueba));

      final ok = await acciones(c).confirmar();

      expect(ok, isTrue);
      expect(cotizaciones.aceptadas, ['q1']);
      expect(chat.enviados, isEmpty);
    });

    test('sin ticket pendiente no confirma', () async {
      final c = contenedor(contextoDePrueba());

      expect(await acciones(c).confirmar(), isFalse);
      expect(cotizaciones.aceptadas, isEmpty);
    });

    test('si la base rechaza la aceptación, deja el error', () async {
      cotizaciones.fallaAlAceptar = const AppFailure(
        'Esta solicitud ya no acepta cotizaciones.',
      );
      final c = contenedor(contextoDePrueba(tarifa: tarifaDePrueba));

      expect(await acciones(c).confirmar(), isFalse);
      expect(errorDe(c), 'Esta solicitud ya no acepta cotizaciones.');
      expect(chat.enviados, isEmpty);
    });
  });

  group('rechazar', () {
    test('desmarca el ticket sin escribir en el chat', () async {
      final c = contenedor(contextoDePrueba(tarifa: tarifaDePrueba));

      final ok = await acciones(c).rechazar();

      expect(ok, isTrue);
      expect(cotizaciones.tarifasRechazadas, ['q1']);
      expect(chat.enviados, isEmpty);
    });

    test('un ticket ya aceptado no se rechaza', () async {
      final c = contenedor(
        contextoDePrueba(
          tarifa: tarifaDePrueba,
          estadoOferta: EstadoCotizacion.aceptada,
        ),
      );

      expect(await acciones(c).rechazar(), isFalse);
      expect(cotizaciones.tarifasRechazadas, isEmpty);
    });
  });
}
