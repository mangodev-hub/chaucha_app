import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_usuario_repository.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/usuario_repository.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/perfil_puntos/presentation/widgets/celebracion_verificado.dart';

class _Repo implements UsuarioRepository {
  int marcas = 0;

  @override
  Future<void> marcarVerificacionVista() async => marcas++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Usuario _usuario({
  Rol rol = Rol.cliente,
  bool verificado = true,
  bool vista = false,
}) => Usuario(
  id: 'u1',
  rol: rol,
  nombres: 'Ana',
  apellidos: 'Pérez',
  creadoEn: DateTime(2026),
  verificado: verificado,
  verificacionVista: vista,
);

Future<_Repo> _montar(WidgetTester tester, Usuario usuario) async {
  final repo = _Repo();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioActualProvider.overrideWithValue(usuario),
        usuarioRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        home: EscuchaVerificacion(child: Scaffold(body: Text('Inicio'))),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('cliente recién verificado: celebra y marca la cuenta', (
    tester,
  ) async {
    final repo = await _montar(tester, _usuario());

    expect(find.text('¡Identidad verificada!'), findsOneWidget);
    expect(find.textContaining('pedir servicios'), findsOneWidget);
    expect(find.text('Verificado'), findsOneWidget);
    expect(repo.marcas, 1);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('¡Identidad verificada!'), findsNothing);
  });

  testWidgets('el técnico ve su propio mensaje', (tester) async {
    await _montar(tester, _usuario(rol: Rol.tecnico));
    expect(find.textContaining('recibir solicitudes'), findsOneWidget);
  });

  testWidgets('ya vista o sin verificar: no sale', (tester) async {
    final vista = await _montar(tester, _usuario(vista: true));
    expect(find.text('¡Identidad verificada!'), findsNothing);
    expect(vista.marcas, 0);

    final sinVerificar = await _montar(tester, _usuario(verificado: false));
    expect(find.text('¡Identidad verificada!'), findsNothing);
    expect(sinVerificar.marcas, 0);
  });

  testWidgets('el admin no la ve', (tester) async {
    await _montar(tester, _usuario(rol: Rol.admin));
    expect(find.text('¡Identidad verificada!'), findsNothing);
  });
}
