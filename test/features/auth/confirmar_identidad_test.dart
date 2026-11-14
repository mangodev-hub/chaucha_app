import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_usuario_repository.dart';
import 'package:tecnicos_app/features/auth/domain/entities/resultado_rostro.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/usuario_repository.dart';
import 'package:tecnicos_app/features/auth/presentation/widgets/confirmar_identidad.dart';

class _Repo implements UsuarioRepository {
  _Repo(this.respuestas);

  /// Una por intento, en orden.
  final List<ResultadoRostro> respuestas;
  int comparaciones = 0;

  @override
  Future<ResultadoRostro> verificarRostroPostulacion(Uint8List foto) async =>
      respuestas[comparaciones++];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _coincide = ResultadoRostro(verificado: true);
const _noCoincide = ResultadoRostro(
  verificado: false,
  motivo: 'Tu rostro no coincide con tu foto de perfil.',
);

/// Toca "Ofrecer" y devuelve cómo leer el resultado cuando termine. En
/// testWidgets el tiempo es simulado: Hilos agota su espera y prepara la foto
/// en el hilo principal.
Future<bool? Function()> _ofrecer(
  WidgetTester tester,
  _Repo repo, {
  bool cierraLaCamara = false,
}) async {
  bool? confirmado;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usuarioRepositoryProvider.overrideWithValue(repo),
        capturaRostroProvider.overrideWithValue(
          (_) async => cierraLaCamara ? null : Uint8List.fromList([1, 2, 3]),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () async => confirmado =
                  await confirmarIdentidadParaOfertar(context, ref),
              child: const Text('Ofrecer'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Ofrecer'));
  await tester.pumpAndSettle();
  return () => confirmado;
}

void main() {
  testWidgets('si el rostro coincide, deja ofertar', (tester) async {
    final repo = _Repo([_coincide]);
    final resultado = await _ofrecer(tester, repo);
    expect(resultado(), isTrue);
    expect(repo.comparaciones, 1);
  });

  testWidgets('si cierra la cámara no oferta ni compara', (tester) async {
    final repo = _Repo([_coincide]);
    final resultado = await _ofrecer(tester, repo, cierraLaCamara: true);
    expect(resultado(), isFalse);
    expect(repo.comparaciones, 0);
  });

  testWidgets('si no coincide puede reintentar y pasar', (tester) async {
    final repo = _Repo([_noCoincide, _coincide]);
    final resultado = await _ofrecer(tester, repo);

    expect(find.text('No pudimos confirmar que eres tú'), findsOneWidget);
    expect(find.text(_noCoincide.motivo!), findsOneWidget);
    await tester.tap(find.text('Intentar de nuevo'));
    await tester.pumpAndSettle();

    expect(resultado(), isTrue);
    expect(repo.comparaciones, 2);
  });

  testWidgets('tras 3 intentos fallidos no oferta', (tester) async {
    final repo = _Repo([_noCoincide, _noCoincide, _noCoincide]);
    final resultado = await _ofrecer(tester, repo);
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Intentar de nuevo'));
      await tester.pumpAndSettle();
    }
    expect(resultado(), isFalse);
    expect(repo.comparaciones, 3);
    expect(find.text('Intentar de nuevo'), findsNothing);
  });
}
