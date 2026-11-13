// Pantalla de login. Al entrar, el router redirige solo según el rol.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/boton_google.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/sacudir.dart';
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

  /// Intentos de envío fallidos: cada uno sacude el botón.
  int _fallos = 0;

  void _avisarFallo() => setState(() => _fallos++);

  /// Veces que el servidor rechazó las credenciales. Es la clave del campo
  /// de contraseña: tras cada rechazo el campo se arma de nuevo (conserva lo
  /// escrito). En la web, el administrador de contraseñas del navegador
  /// reacciona al envío fallido y podía dejar el campo sin aceptar cambios.
  int _rechazos = 0;

  void _alRechazar() {
    // Cierra el autocompletado del intento (sin ofrecer guardar una
    // contraseña que no sirvió) para que el navegador suelte el campo.
    TextInput.finishAutofillContext(shouldSave: false);
    setState(() {
      _fallos++;
      _rechazos++;
    });
  }

  /// Tramo de la animación del técnico según el campo con foco: mira el correo
  /// mientras se escribe y se tapa los ojos con la contraseña.
  String _tramo = 'idle';

  void _alCambiarFoco(String tramo, {required bool enfocado}) {
    setState(() {
      if (enfocado) {
        _tramo = tramo;
      } else if (_tramo == tramo) {
        _tramo = 'idle';
      }
    });
  }

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _avisarFallo();
      return;
    }
    await ref
        .read(loginProvider.notifier)
        .iniciarSesion(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final estadoLogin = ref.watch(loginProvider);
    // Si el servidor responde con error, el botón también se sacude.
    ref.listen(loginProvider, (_, siguiente) {
      if (siguiente.hasError && !siguiente.isLoading) _alRechazar();
    });
    final cargando = estadoLogin.isLoading;
    final error = cargando || !estadoLogin.hasError
        ? null
        : AsyncValueView.mensajeDe(estadoLogin.error!);

    final textos = Theme.of(context).textTheme;

    return AuthLayout(
      titulo: 'Hola de nuevo',
      tituloCentrado: true,
      subtitulo: 'Entra para ver tus solicitudes y chats.',
      anchoEscritorio: 440,
      panelDetallado: true,
      animacionEscritorio: 'assets/lottie/tecnico.json',
      animacionMovil: 'assets/lottie/tecnico_login.json',
      tramoAnimacion: _tramo,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AvisoSesion(),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: Espacios.l),
                  child: AvisoBanner(tipo: TipoAviso.error, mensaje: error),
                ),
              CampoEtiquetado(
                etiqueta: 'Correo electrónico',
                // Solo escucha el foco del campo: no lo pide ni cambia el Tab.
                child: Focus(
                  canRequestFocus: false,
                  skipTraversal: true,
                  onFocusChange: (enfocado) =>
                      _alCambiarFoco('email', enfocado: enfocado),
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
              ),
              const SizedBox(height: Espacios.xl),
              CampoEtiquetado(
                etiqueta: 'Contraseña',
                child: Focus(
                  canRequestFocus: false,
                  skipTraversal: true,
                  onFocusChange: (enfocado) =>
                      _alCambiarFoco('password', enfocado: enfocado),
                  child: CampoContrasena(
                    key: ValueKey('contrasena-$_rechazos'),
                    controller: _password,
                    hintText: 'Tu contraseña',
                    autofillHints: const [AutofillHints.password],
                    onFieldSubmitted: (_) => _enviar(),
                    validator: (valor) =>
                        FormValidators.requerido(valor, campo: 'La contraseña'),
                  ),
                ),
              ),
              const SizedBox(height: Espacios.s),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.recuperar),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              const SizedBox(height: Espacios.l),
              Sacudir(
                senal: _fallos,
                child: BotonCarga(
                  texto: 'Iniciar sesión',
                  icono: Icons.arrow_forward,
                  iconoAlFinal: true,
                  cargando: cargando,
                  onPressed: _enviar,
                ),
              ),
              const SizedBox(height: Espacios.xxl),
              BotonGoogle(
                onPressed: cargando
                    ? null
                    : () => ref.read(loginProvider.notifier).iniciarConGoogle(),
              ),
              const SizedBox(height: Espacios.l),
              // Enlace en verde y negrita, como en el lienzo del rediseño.
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.registro),
                  child: Text.rich(
                    TextSpan(
                      text: '¿No tienes cuenta? ',
                      style: textos.bodyMedium?.copyWith(
                        color: Colores.tintaSuave,
                        fontWeight: FontWeight.w500,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Regístrate',
                          style: TextStyle(
                            color: Colores.primario,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvisoSesion extends ConsumerWidget {
  const _AvisoSesion();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(sesionProvider);
    if (estado is! SinSesion) return const SizedBox.shrink();

    final verificado = estado.correoVerificado;
    final mensaje = verificado
        ? 'Correo verificado, ya puedes iniciar sesión.'
        : estado.aviso;
    if (mensaje == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.l),
      child: AvisoBanner(
        tipo: verificado ? TipoAviso.exito : TipoAviso.error,
        mensaje: mensaje,
      ),
    );
  }
}
