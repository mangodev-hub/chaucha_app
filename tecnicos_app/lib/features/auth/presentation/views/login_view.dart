// Pantalla de login. Al entrar, el router redirige solo según el rol.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../domain/entities/sesion_estado.dart';
import '../providers/login_provider.dart';
import '../providers/sesion_provider.dart';
import '../widgets/auth_layout.dart';
import '../widgets/enlace_auth.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(loginProvider.notifier)
        .iniciarSesion(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (_, estado) {
      if (estado case AsyncError(:final error)) {
        context.mostrarMensaje(
          AsyncValueView.mensajeDe(error),
          tipo: TipoMensaje.error,
        );
      }
    });
    final cargando = ref.watch(loginProvider).isLoading;

    return AuthLayout(
      titulo: 'Iniciar sesión',
      subtitulo: 'Ingresa tus datos para gestionar tus servicios del hogar.',
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AvisoSesion(),
              CampoEtiquetado(
                etiqueta: 'Correo electrónico',
                child: TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: FormValidators.email,
                ),
              ),
              const SizedBox(height: Espacios.l + 2),
              CampoEtiquetado(
                etiqueta: 'Contraseña',
                child: CampoContrasena(
                  controller: _password,
                  hintText: 'Tu contraseña',
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _enviar(),
                  validator: (valor) =>
                      FormValidators.requerido(valor, campo: 'La contraseña'),
                ),
              ),
              const SizedBox(height: Espacios.xl),
              BotonCarga(
                texto: 'Iniciar sesión',
                icono: Icons.arrow_forward,
                iconoAlFinal: true,
                cargando: cargando,
                onPressed: _enviar,
              ),
              const SizedBox(height: Espacios.l),
              EnlaceAuth(
                pregunta: '¿No tienes cuenta?',
                accion: 'Regístrate',
                onPressed: () => context.go(AppRoutes.registro),
              ),
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.l),
      child: AvisoBanner(tipo: TipoAviso.error, mensaje: aviso),
    );
  }
}
