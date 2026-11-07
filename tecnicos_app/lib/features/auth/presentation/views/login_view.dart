// Pantalla de login. Al entrar, el router redirige solo según el rol.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../domain/entities/sesion_estado.dart';
import '../providers/login_provider.dart';
import '../providers/sesion_provider.dart';
import '../widgets/auth_layout.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _ocultarPassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(loginProvider.notifier).iniciarSesion(
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (_, estado) {
      if (estado case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AsyncValueView.mensajeDe(error))),
        );
      }
    });
    final cargando = ref.watch(loginProvider).isLoading;

    return AuthLayout(
      titulo: 'Iniciar sesión',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AvisoSesion(),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: FormValidators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: _ocultarPassword,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _enviar(),
              validator: (valor) =>
                  FormValidators.requerido(valor, campo: 'La contraseña'),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  tooltip: _ocultarPassword ? 'Mostrar' : 'Ocultar',
                  icon: Icon(
                    _ocultarPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _ocultarPassword = !_ocultarPassword),
                ),
              ),
            ),
            const SizedBox(height: 24),
            BotonCarga(
              texto: 'Entrar',
              cargando: cargando,
              onPressed: _enviar,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.registro),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Explica por qué se cerró la sesión (p. ej. cuenta sin perfil).
class _AvisoSesion extends ConsumerWidget {
  const _AvisoSesion();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(sesionProvider);
    final aviso = estado is SinSesion ? estado.aviso : null;
    if (aviso == null) return const SizedBox.shrink();
    final colores = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: colores.errorContainer,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            aviso,
            style: TextStyle(color: colores.onErrorContainer),
          ),
        ),
      ),
    );
  }
}
