import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/catalogo/domain/entities/oficio.dart';
import 'package:tecnicos_app/features/catalogo/presentation/providers/oficios_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/certificacion.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/nivel.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_publico.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_tecnico.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/certificaciones_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/perfil_publico_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/perfil_tecnico_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/views/perfil_tecnico_view.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/resumen_tecnico.dart';
import 'package:tecnicos_app/features/solicitudes/presentation/providers/inicio_tecnico_provider.dart';

final _usuario = Usuario(
  id: 't1',
  rol: Rol.tecnico,
  nombres: 'Carlos Daniel',
  apellidos: 'Puente Castro',
  creadoEn: DateTime(2026),
  verificado: true,
);

const _perfil = PerfilTecnico(
  usuarioId: 't1',
  tarifaBase: 15,
  rangoCoberturaM: 5000,
  puntos: 120,
  calificacionPromedio: 4.5,
  totalResenas: 3,
  verificado: true,
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
        resumenTecnicoProvider.overrideWith(
          (ref) async => const ResumenTecnico(
            ofertasPendientes: 2,
            ticketsPorConfirmar: 1,
            trabajosEnCurso: [],
            completados: 7,
            ganadoEsteMes: 135.5,
          ),
        ),
        nivelesProvider.overrideWith(
          (ref) async => const [
            Nivel(nombre: 'Bronce', puntosMinimos: 0),
            Nivel(nombre: 'Plata', puntosMinimos: 500),
            Nivel(nombre: 'Oro', puntosMinimos: 1500),
          ],
        ),
        perfilPublicoProvider.overrideWith(
          (ref, id) async => PerfilPublico(
            tecnicoId: id,
            nombre: 'Carlos Puente',
            verificado: true,
            nivelNombre: 'Bronce',
            calificacionPromedio: 4.5,
            totalResenas: 1,
            oficios: const ['Plomería'],
            resenas: [
              ResenaPublica(
                autor: 'Ana P.',
                calificacion: 5,
                creadoEn: DateTime.now(),
                comentario: 'Muy puntual y ordenado.',
                etiquetas: const ['Puntual'],
              ),
            ],
          ),
        ),
        oficiosProvider.overrideWith(
          (ref) async => const [
            Oficio(id: 1, nombre: 'Plomería'),
            Oficio(id: 2, nombre: 'Electricidad'),
          ],
        ),
        misCertificacionesProvider.overrideWith(
          (ref) async => const <Certificacion>[],
        ),
        certificacionesAprobadasProvider.overrideWith(
          (ref, id) async => const <Certificacion>[],
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: PerfilTecnicoView())),
    ),
  );
  // Deja cargar los futuros sin esperar a las animaciones infinitas.
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Desmonta la vista y deja vencer los temporizadores del mapa (las teselas
/// reintentan descargarse; en los tests la red siempre responde 400).
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
      expect(find.text('Carlos Daniel Puente Castro'), findsOneWidget);
      expect(find.text('Quito, Ecuador'), findsOneWidget);
      expect(find.text('Datos de trabajo'), findsOneWidget);
      expect(find.text('Zona de trabajo'), findsOneWidget);
      expect(find.text('Lo que dicen los clientes'), findsOneWidget);

      await _desmontar(tester);
    });
  }
}
