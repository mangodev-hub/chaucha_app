// El inicio del técnico se arma sin errores de layout en teléfonos angostos y
// en escritorio, con todas sus secciones a la vista.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/chat/domain/entities/conversacion_pendiente.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_tecnico.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/feed.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/resumen_tecnico.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/feed_provider.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/inicio_tecnico_provider.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/views/inicio_tecnico_view.dart';

import 'falsos.dart';

final _usuario = Usuario(
  id: 't1',
  rol: Rol.tecnico,
  nombres: 'Carlos Daniel',
  apellidos: 'Puente Castro',
  creadoEn: DateTime(2026),
);

// Sin verificar: así aparece "Para empezar a trabajar" con sus botones.
const _perfil = PerfilTecnico(
  usuarioId: 't1',
  tarifaBase: 15,
  rangoCoberturaM: 5000,
  puntos: 120,
  calificacionPromedio: 4.5,
  totalResenas: 3,
  verificado: false,
  nivelNombre: 'Bronce',
  comisionPorcentaje: 10,
  oficioIds: [1],
  ubicacionActual: LatLng(-0.18, -78.48),
);

Future<void> _montar(WidgetTester tester, Size tamano) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        usuarioActualProvider.overrideWithValue(_usuario),
        perfilTecnicoProvider.overrideWith((ref) async => _perfil),
        chatsPendientesProvider.overrideWithValue(
          AsyncData([
            ConversacionPendiente(
              conversacionId: 'k1',
              solicitudId: 's1',
              oficio: 'Plomería',
              ultimoMensaje: '¿Puedes venir mañana a las 10 de la mañana?',
              enviadoEn: DateTime.now(),
            ),
          ]),
        ),
        resumenTecnicoProvider.overrideWith(
          (ref) async => ResumenTecnico(
            ofertasPendientes: 2,
            ticketsPorConfirmar: 1,
            trabajosEnCurso: [
              solicitudDePrueba(id: 's2', estado: EstadoSolicitud.aceptada),
            ],
            completados: 7,
            ganadoEsteMes: 135.5,
          ),
        ),
        feedProvider.overrideWith(
          (ref) async => DatosFeed(
            perfil: _perfil,
            items: [
              ItemFeed(
                solicitud: solicitudDePrueba(id: 's3'),
                distanciaMetros: 850,
                yaCotice: false,
              ),
            ],
          ),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: InicioTecnicoView())),
    ),
  );
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Desmonta la vista y deja vencer los temporizadores (mapa y carrusel).
Future<void> _desmontar(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 30));
}

void main() {
  for (final (nombre, tamano) in [
    ('un teléfono de 320 px', const Size(320, 700)),
    ('un teléfono de 360 px', const Size(360, 800)),
    ('escritorio', const Size(1280, 900)),
  ]) {
    testWidgets('en $nombre se arma sin errores de layout', (tester) async {
      await _montar(tester, tamano);

      expect(tester.takeException(), isNull);
      expect(find.text('Tu resumen de hoy.'), findsOneWidget);
      expect(find.text('Para empezar a trabajar'), findsOneWidget);

      // Baja hasta el final por si algo de abajo se rompe al aparecer.
      await tester.drag(find.byType(ListView).first, const Offset(0, -3000));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      await _desmontar(tester);
    });
  }
}
