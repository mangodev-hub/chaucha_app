// Tras un rechazo del servidor, el campo de contraseña se arma de nuevo:
// conserva lo escrito y sigue aceptando cambios (en la web, el navegador
// podía dejarlo bloqueado después del envío fallido).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/widgets/campos.dart';
import 'package:tecnicos_app/features/auth/domain/entities/sesion_estado.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/login_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';
import 'package:tecnicos_app/features/auth/presentation/views/login_view.dart';

class _SinSesion extends SesionNotifier {
  @override
  SesionEstado build() => const SinSesion();
}

class _LoginRechazado extends LoginNotifier {
  @override
  Future<void> iniciarSesion({
    required String email,
    required String password,
  }) async {
    state = AsyncError(Exception('Credenciales inválidas'), StackTrace.empty);
  }
}

void main() {
  testWidgets('tras un rechazo la contraseña sigue editable', (tester) async {
    tester.view
      ..physicalSize = const Size(1280, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sesionProvider.overrideWith(_SinSesion.new),
          loginProvider.overrideWith(_LoginRechazado.new),
        ],
        child: const MaterialApp(home: LoginView()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    final contrasena = find.descendant(
      of: find.byType(CampoContrasena),
      matching: find.byType(EditableText),
    );
    await tester.enterText(find.byType(EditableText).first, 'a@b.com');
    await tester.enterText(contrasena, 'mala123');
    final antes = tester.state(find.byType(CampoContrasena));

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();
    await tester.pump();

    // Un campo nuevo, con lo que ya estaba escrito.
    expect(
      identical(tester.state(find.byType(CampoContrasena)), antes),
      isFalse,
    );
    expect(tester.widget<EditableText>(contrasena).controller.text, 'mala123');

    // Se puede volver a entrar, borrar y escribir.
    await tester.tap(contrasena);
    await tester.pump();
    expect(tester.widget<EditableText>(contrasena).focusNode.hasFocus, isTrue);
    await tester.enterText(contrasena, 'buena456');
    await tester.pump();
    expect(tester.widget<EditableText>(contrasena).controller.text, 'buena456');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });
}
