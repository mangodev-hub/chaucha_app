// "Mi perfil" del cliente y el perfil del técnico que ve el cliente:
// sin desbordes a 1440 y 390 px, con y sin reseñas, y sin elementos que el
// diseño quitó ("Editar perfil", botón de cámara, "[Técnico]").
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tecnicos_app/app/inicio_shell.dart';
import 'package:tecnicos_app/core/presence/presencia_service.dart';
import 'package:tecnicos_app/core/providers/core_providers.dart';
import 'package:tecnicos_app/core/widgets/etiqueta_sector.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/inicio_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/perfil_cliente_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/resenas_cliente_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/views/perfil_cliente_view.dart';
import 'package:tecnicos_app/features/notificaciones/presentation/providers/notificaciones_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/certificacion.dart';
import 'package:tecnicos_app/features/perfil_puntos/domain/entities/perfil_publico.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/certificaciones_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/providers/perfil_publico_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/views/perfil_publico_view.dart';
import 'package:tecnicos_app/features/publicidad/domain/entities/anuncio.dart';
import 'package:tecnicos_app/features/publicidad/presentation/providers/anuncios_provider.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/servicio_completado.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';

final _cliente = Usuario(
  id: 'c1',
  rol: Rol.cliente,
  nombres: 'José Eduardo',
  apellidos: 'Cevallos Díaz',
  creadoEn: DateTime(2026, 3, 4),
  verificado: true,
  ciudad: 'Quito',
  ubicacionRegistro: const LatLng(-0.18, -78.48),
);

final _resenas = [
  for (var i = 0; i < 5; i++)
    ResenaPublica(
      autor: 'Ana P.',
      calificacion: 5 - i % 2,
      comentario: 'Muy puntual y amable, todo quedó funcionando.',
      etiquetas: const ['Puntual', 'Amable'],
      creadoEn: DateTime(2026, 10, 20 - i),
    ),
];

PerfilPublico _tecnico({required bool conResenas}) => PerfilPublico(
  tecnicoId: 't1',
  nombre: 'Marco Antonio Vinueza Paredes',
  verificado: true,
  selfieValidada: true,
  nivelNombre: conResenas ? 'Plata' : 'Bronce',
  calificacionPromedio: conResenas ? 4.6 : 0,
  totalResenas: conResenas ? _resenas.length : 0,
  oficios: const ['Electricidad', 'Plomería', 'Cerrajería'],
  resenas: conResenas ? _resenas : const [],
  miembroDesde: DateTime(2026, 5),
);

final _hoy = DateTime.now();

final _activas = <SolicitudActiva>[
  (
    solicitud: Solicitud(
      id: 's1',
      clienteId: 'c1',
      oficioId: 1,
      oficioNombre: 'Plomería',
      descripcion: 'Fuga bajo el lavaplatos de la cocina',
      estado: EstadoSolicitud.cotizada,
      creadoEn: _hoy.subtract(const Duration(hours: 5)),
    ),
    ofertas: 3,
  ),
  (
    solicitud: Solicitud(
      id: 's2',
      clienteId: 'c1',
      oficioId: 2,
      oficioNombre: 'Electricidad',
      descripcion: 'Cambiar el tablero de breakers',
      estado: EstadoSolicitud.aceptada,
      creadoEn: _hoy.subtract(const Duration(days: 2)),
    ),
    ofertas: 2,
  ),
];

ServicioCompletado _servicio(
  int i, {
  required String tecnico,
  required String nombre,
  required int hace,
  int? estrellas = 5,
}) => ServicioCompletado(
  solicitudId: 'h$i',
  descripcion: 'Arreglo número $i en el departamento',
  oficioNombre: i.isEven ? 'Plomería' : 'Electricidad',
  completadaEn: _hoy.subtract(Duration(days: hace)),
  precioVisita: 15.0 + i,
  tecnicoId: tecnico,
  tecnicoNombre: nombre,
  tecnicoCalificacion: 4.7,
  tecnicoTotalResenas: tecnico == 't3' ? 0 : 12,
  miCalificacion: estrellas,
);

// 5 servicios: uno sin calificar, uno con la garantía vencida y dos
// técnicos repetidos.
final _historial = [
  _servicio(
    1,
    tecnico: 't1',
    nombre: 'Marco Antonio Vinueza Paredes',
    hace: 3,
    estrellas: null,
  ),
  _servicio(2, tecnico: 't2', nombre: 'Ana Lucía Paredes Mora', hace: 10),
  _servicio(
    3,
    tecnico: 't1',
    nombre: 'Marco Antonio Vinueza Paredes',
    hace: 18,
    estrellas: 4,
  ),
  _servicio(4, tecnico: 't3', nombre: 'Luis Tapia', hace: 35),
  _servicio(5, tecnico: 't2', nombre: 'Ana Lucía Paredes Mora', hace: 45),
];

Future<void> _montar(
  WidgetTester tester,
  Size tamano,
  Widget vista, {
  bool conResenas = true,
}) async {
  tester.view
    ..physicalSize = tamano
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        usuarioActualProvider.overrideWithValue(_cliente),
        supabaseClientProvider.overrideWithValue(
          SupabaseClient(
            'http://localhost',
            'anon',
            authOptions: const AuthClientOptions(autoRefreshToken: false),
          ),
        ),
        solicitudesActivasProvider.overrideWith(
          (ref) async => conResenas ? _activas : const [],
        ),
        historialServiciosProvider.overrideWith(
          (ref) async => conResenas ? _historial : const [],
        ),
        notificacionesNoLeidasProvider.overrideWith(
          (ref) => Stream.value(const []),
        ),
        ubicacionInicioProvider.overrideWith(
          (ref) async => const LatLng(-0.18, -78.48),
        ),
        resenasRecibidasProvider.overrideWith(
          (ref) async => ResumenResenas(conResenas ? _resenas : const []),
        ),
        sectorProvider.overrideWith((ref, clave) async => 'La Carolina'),
        anunciosProvider.overrideWith((ref, u) async => const <Anuncio>[]),
        perfilPublicoProvider.overrideWith(
          (ref, id) async => _tecnico(conResenas: conResenas),
        ),
        estadoPresenciaProvider.overrideWith(
          (ref, id) async => EstadoPresencia(enLinea: conResenas),
        ),
        certificacionesAprobadasProvider.overrideWith(
          (ref, id) async => const <Certificacion>[],
        ),
      ],
      child: MaterialApp(home: vista),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void _sinElementosQuitados() {
  expect(find.text('Editar perfil'), findsNothing);
  expect(find.byIcon(Icons.photo_camera_outlined), findsNothing);
  expect(find.byIcon(Icons.camera_alt_outlined), findsNothing);
  expect(find.textContaining('[Técnico]'), findsNothing);
}

void main() {
  for (final tamano in const [Size(1440, 1100), Size(390, 844)]) {
    final w = tamano.width.toInt();
    for (final conResenas in [true, false]) {
      final caso = conResenas ? 'con reseñas' : 'sin reseñas';

      testWidgets('Mi perfil a $w px $caso', (tester) async {
        await _montar(
          tester,
          tamano,
          const Scaffold(body: PerfilClienteView()),
          conResenas: conResenas,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('José Eduardo Cevallos Díaz'), findsOneWidget);
        expect(find.text('Lo que dicen los técnicos'), findsOneWidget);
        expect(find.text('Mis solicitudes activas'), findsOneWidget);
        expect(find.text('Historial de servicios'), findsOneWidget);
        if (conResenas) {
          expect(find.text('Ver las 5 reseñas'), findsOneWidget);
          expect(find.text('Con ofertas · 3'), findsOneWidget);
          expect(find.text('En curso'), findsOneWidget);
          expect(find.text('5 completados'), findsOneWidget);
          expect(find.text('Calificar'), findsOneWidget);
          expect(find.text('Ver todo el historial'), findsOneWidget);
          expect(find.text('Técnicos con los que trabajaste'), findsOneWidget);
          expect(find.text('2 servicios contigo'), findsNWidgets(2));
          expect(find.text('Garantía vencida'), findsOneWidget);
          expect(find.textContaining('Garantía: '), findsNWidgets(3));
          expect(find.text('Marco Vinueza'), findsOneWidget);
        } else {
          expect(find.text('No tienes solicitudes activas'), findsOneWidget);
          expect(find.text('+ Publicar solicitud'), findsOneWidget);
          expect(
            find.text(
              'Cuando completes tu primer servicio aparecerá aquí con su '
              'garantía de 30 días.',
            ),
            findsOneWidget,
          );
          expect(find.text('Técnicos con los que trabajaste'), findsNothing);
          expect(
            find.text(
              'Aún no tienes reseñas. Aparecerán cuando completes tu '
              'primer servicio.',
            ),
            findsOneWidget,
          );
        }
        _sinElementosQuitados();
      });

      testWidgets('Perfil del técnico a $w px $caso', (tester) async {
        await _montar(
          tester,
          tamano,
          const PerfilPublicoView(tecnicoId: 't1'),
          conResenas: conResenas,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Escribir al técnico'), findsOneWidget);
        expect(find.text('Verificado'), findsOneWidget);
        expect(find.text('Cédula verificada'), findsOneWidget);
        expect(find.text('Electricidad'), findsOneWidget);
        if (conResenas) {
          expect(find.text('Nivel Plata'), findsOneWidget);
          expect(find.text('En línea'), findsOneWidget);
          expect(find.text('Técnico nuevo'), findsNothing);
          expect(find.text('4,6'), findsWidgets);
        } else {
          expect(find.text('Técnico nuevo'), findsOneWidget);
          expect(find.text('En línea'), findsNothing);
          expect(find.text('Nuevo'), findsOneWidget);
          expect(find.text('Marco es nuevo en ChauchaApp'), findsOneWidget);
        }
        // Nada de puntos, faltas ni sanciones.
        expect(find.textContaining('puntos'), findsNothing);
        expect(find.textContaining('falta'), findsNothing);
        _sinElementosQuitados();
      });
    }
  }

  group('dentro de la estructura web', () {
    Widget enShell(Widget pagina) => InicioShell(
      claro: true,
      onCerrarSesion: () {},
      pagina: pagina,
      destinos: const [
        Destino('Inicio', Icons.home_outlined, SizedBox()),
        Destino('Mi perfil', Icons.person_outline, SizedBox()),
      ],
    );

    testWidgets('perfil del técnico a 1440 px: menú, migas y sin AppBar', (
      tester,
    ) async {
      await _montar(
        tester,
        const Size(1440, 1100),
        enShell(const PerfilPublicoView(tecnicoId: 't1')),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text('‹ Volver'), findsOneWidget);
      expect(find.text('Perfil del técnico'), findsOneWidget);
      expect(find.text('Inicio'), findsWidgets);
    });

    testWidgets('perfil del técnico a 390 px: AppBar clara sin migas', (
      tester,
    ) async {
      await _montar(
        tester,
        const Size(390, 844),
        enShell(const PerfilPublicoView(tecnicoId: 't1')),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('‹ Volver'), findsNothing);
      final barra = tester.widget<AppBar>(find.byType(AppBar));
      expect(barra.backgroundColor, const Color(0xFFF4F9F4));
    });
  });
}
