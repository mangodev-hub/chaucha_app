import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/seguridad/biometria.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_usuario_repository.dart';
import 'package:tecnicos_app/features/auth/domain/entities/resultado_rostro.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/usuario_repository.dart';
import 'package:tecnicos_app/features/auth/presentation/widgets/confirmar_identidad.dart';

class _Biometria extends Biometria {
  _Biometria(this.resultado);

  final ResultadoBiometria resultado;

  @override
  Future<ResultadoBiometria> confirmar(String motivo) async => resultado;
}

class _Repo implements UsuarioRepository {
  int registros = 0;

  @override
  Future<void> registrarVerificacionPostulacion() async => registros++;

  @override
  Future<ResultadoRostro> verificarRostroPostulacion(Uint8List foto) async =>
      const ResultadoRostro(verificado: true);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<(_Repo, bool?)> _probar(
  WidgetTester tester,
  ResultadoBiometria resultado,
) async {
  final repo = _Repo();
  bool? confirmado;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        biometriaProvider.overrideWithValue(_Biometria(resultado)),
        usuarioRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) => TextButton(
            onPressed: () async =>
                confirmado = await confirmarIdentidadParaOfertar(context, ref),
            child: const Text('Ofrecer'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Ofrecer'));
  await tester.pumpAndSettle();
  return (repo, confirmado);
}

void main() {
  testWidgets('con biometría confirmada registra y deja ofertar', (
    tester,
  ) async {
    final (repo, ok) = await _probar(tester, ResultadoBiometria.confirmada);
    expect(ok, isTrue);
    expect(repo.registros, 1);
  });

  testWidgets('si cancela la biometría no oferta ni registra', (tester) async {
    final (repo, ok) = await _probar(tester, ResultadoBiometria.cancelada);
    expect(ok, isFalse);
    expect(repo.registros, 0);
  });
}
