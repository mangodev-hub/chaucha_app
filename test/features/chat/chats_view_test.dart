import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/chat/data/repositories/supabase_chat_repository.dart';
import 'package:tecnicos_app/features/chat/domain/entities/resumen_chat.dart';
import 'package:tecnicos_app/features/chat/presentation/views/chats_view.dart';
import 'package:tecnicos_app/features/notificaciones/domain/entities/notificacion.dart';
import 'package:tecnicos_app/features/notificaciones/presentation/providers/notificaciones_provider.dart';

import 'falsos.dart';

class _ChatsFalso extends ChatFalso {
  List<ResumenChat> chats = const [];

  @override
  Future<List<ResumenChat>> misChats() async => chats;
}

final _chats = [
  ResumenChat(
    conversacionId: 'k1',
    otroNombre: 'Marco Vinueza',
    otroId: 't1',
    oficio: 'Plomería',
    ultimoMensaje: '¿El edificio tiene parqueadero?',
    enviadoEn: DateTime.now(),
    esMio: false,
  ),
  ResumenChat(
    conversacionId: 'k2',
    otroNombre: 'Ana Paredes',
    otroId: 't2',
    oficio: 'Electricidad',
    ultimoMensaje: 'Gracias por la calificación.',
    enviadoEn: DateTime(2026, 11, 3),
    esMio: true,
  ),
];

final _sinLeer = [
  Notificacion(
    id: 'n1',
    tipo: 'mensaje',
    referenciaId: 'k1',
    contenido: 'Marco te escribió',
    creadaEn: DateTime.now(),
  ),
  Notificacion(
    id: 'n2',
    tipo: 'chat',
    referenciaId: 'k1',
    contenido: 'Marco te escribió',
    creadaEn: DateTime.now(),
  ),
];

Future<void> _montar(
  WidgetTester tester, {
  List<ResumenChat> chats = const [],
  List<Notificacion> sinLeer = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(null),
        chatRepositoryProvider.overrideWithValue(_ChatsFalso()..chats = chats),
        notificacionesNoLeidasProvider.overrideWith(
          (ref) => Stream.value(sinLeer),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: ChatsView(esCliente: true)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sin chats muestra el estado vacío', (tester) async {
    await _montar(tester);

    expect(find.text('Sin conversaciones'), findsOneWidget);
    expect(find.text('sin leer', skipOffstage: false), findsNothing);
  });

  testWidgets('lista los chats con oficio, último mensaje e insignia', (
    tester,
  ) async {
    await _montar(tester, chats: _chats, sinLeer: _sinLeer);

    expect(find.text('Marco Vinueza'), findsOneWidget);
    expect(find.text('Ana Paredes'), findsOneWidget);
    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('Tú: Gracias por la calificación.'), findsOneWidget);
    expect(find.text('2 sin leer'), findsOneWidget);
    // La insignia del chat de Marco cuenta sus dos avisos.
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('"Sin leer" y la búsqueda filtran la lista', (tester) async {
    await _montar(tester, chats: _chats, sinLeer: _sinLeer);

    await tester.tap(find.text('Sin leer'));
    await tester.pumpAndSettle();
    expect(find.text('Marco Vinueza'), findsOneWidget);
    expect(find.text('Ana Paredes'), findsNothing);

    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'electri');
    await tester.pumpAndSettle();
    expect(find.text('Ana Paredes'), findsOneWidget);
    expect(find.text('Marco Vinueza'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.textContaining('Ningún chat coincide'), findsOneWidget);
  });
}
