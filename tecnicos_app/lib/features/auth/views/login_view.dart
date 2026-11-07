// Se recibe la INTERFAZ, nunca Supabase.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/state/view_state.dart';
import '../../../core/validators/form_validators.dart';
import '../../../core/widgets/boton_carga.dart';
import '../models/sesion_estado.dart';
import '../services/auth_service.dart';
import '../viewmodels/login_view_model.dart';
import 'widgets/auth_layout.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.authService, required this.sesion});


  final AuthService authService;
  final ValueListenable<SesionEstado> sesion;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel _viewModel = LoginViewModel(widget.authService);
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_mostrarErrorSiHay);
  }

  @override
  void dispose() {
    _viewModel
      ..removeListener(_mostrarErrorSiHay)
      ..dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _mostrarErrorSiHay() {
    final estado = _viewModel.value;
    if (estado is ViewError<void> && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(estado.message)));
    }
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _viewModel.iniciarSesion(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      titulo: 'Iniciar sesión',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AvisoSesion(sesion: widget.sesion),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: FormValidators.email,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: _viewModel.ocultarPassword,
              builder: (context, ocultar, _) => TextFormField(
                controller: _password,
                obscureText: ocultar,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _enviar(),
                validator: (valor) =>
                    FormValidators.requerido(valor, campo: 'La contraseña'),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    tooltip: ocultar ? 'Mostrar' : 'Ocultar',
                    icon: Icon(ocultar ? Icons.visibility : Icons.visibility_off),
                    onPressed: _viewModel.alternarPassword,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<ViewState<void>>(
              valueListenable: _viewModel,
              builder: (context, estado, _) => BotonCarga(
                texto: 'Entrar',
                cargando: estado is ViewLoading<void>,
                onPressed: _enviar,
              ),
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


class _AvisoSesion extends StatelessWidget {
  const _AvisoSesion({required this.sesion});

  final ValueListenable<SesionEstado> sesion;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SesionEstado>(
      valueListenable: sesion,
      builder: (context, estado, _) {
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
      },
    );
  }
}
