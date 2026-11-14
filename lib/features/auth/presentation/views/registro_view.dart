import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../core/validators/codigo_dactilar_validator.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/sacudir.dart';
import '../../domain/entities/registro_resultado.dart';
import '../../domain/entities/rol.dart';
import '../providers/recuperacion_providers.dart';
import '../providers/registro_provider.dart';
import '../widgets/auth_layout.dart';
import '../widgets/enlace_auth.dart';
import '../widgets/opcion_rol.dart';

class RegistroView extends ConsumerStatefulWidget {
  const RegistroView({super.key});

  @override
  ConsumerState<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends ConsumerState<RegistroView> {
  final _formKey = GlobalKey<FormState>();

  /// Intentos de envío fallidos: cada uno sacude el botón.
  int _fallos = 0;

  void _avisarFallo() => setState(() => _fallos++);

  /// Veces que el servidor rechazó el registro.
  int _rechazos = 0;

  void _alRechazar() {
    // Cierra el autocompletado del intento sin ofrecer guardar la clave.
    TextInput.finishAutofillContext(shouldSave: false);
    setState(() {
      _fallos++;
      _rechazos++;
    });
  }

  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _cedula = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmacion = TextEditingController();
  final _dactilar = TextEditingController();
  Rol _rol = Rol.cliente;
  Timer? _temporizador;
  int _espera = 0;

  @override
  void dispose() {
    _temporizador?.cancel();
    for (final controller in [
      _nombres,
      _apellidos,
      _cedula,
      _email,
      _password,
      _confirmacion,
      _dactilar,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validarConfirmacion(String? valor) =>
      valor == _password.text ? null : 'Las contraseñas no coinciden.';

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _avisarFallo();
      return;
    }
    await ref
        .read(registroProvider.notifier)
        .registrar(
          email: _email.text,
          password: _password.text,
          nombres: _nombres.text,
          apellidos: _apellidos.text,
          cedula: _cedula.text,
          rol: _rol,
          codigoDactilar: _dactilar.text,
        );
  }

  void _iniciarEspera() {
    setState(() => _espera = 60);
    _temporizador?.cancel();
    _temporizador = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _espera--);
      if (_espera <= 0) t.cancel();
    });
  }

  Future<void> _reenviar() async {
    await ref.read(reenviarConfirmacionProvider.notifier).reenviar(_email.text);
    if (!mounted) return;
    final estado = ref.read(reenviarConfirmacionProvider);
    if (estado.hasError) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(estado.error!),
        tipo: TipoMensaje.error,
      );
      return;
    }
    context.mostrarMensaje(
      'Te enviamos el correo otra vez.',
      tipo: TipoMensaje.exito,
    );
    _iniciarEspera();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(registroProvider);
    // Si el servidor responde con error, el botón también se sacude.
    ref.listen(registroProvider, (_, siguiente) {
      if (siguiente.hasError && !siguiente.isLoading) _alRechazar();
    });
    final reenvio = ref.watch(reenviarConfirmacionProvider);
    final error = estado.isLoading || !estado.hasError
        ? null
        : AsyncValueView.mensajeDe(estado.error!);

    if (estado case AsyncData(value: RegistroResultado.confirmarCorreo)) {
      return AuthLayout(
        titulo: 'Revisa tu correo',
        tituloCentrado: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EstadoMensaje(
              icono: Icons.mark_email_read_outlined,
              tipo: TipoEstado.exito,
              mensaje:
                  'Te enviamos un enlace de confirmación. '
                  'Ábrelo y luego inicia sesión.',
              textoAccion: 'Iniciar sesión',
              onAccion: () => context.go(AppRoutes.login),
            ),
            const SizedBox(height: Espacios.l),
            Text(
              '¿No recibiste el correo de confirmación? Revisa spam o '
              'promociones; a veces tarda unos minutos.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colores.tintaSuave),
            ),
            TextButton(
              onPressed: (_espera > 0 || reenvio.isLoading) ? null : _reenviar,
              child: Text(
                _espera > 0 ? 'Reenviar en ${_espera}s' : 'Reenviar correo',
              ),
            ),
          ],
        ),
      );
    }

    return AuthLayout(
      titulo: 'Crear cuenta',
      subtitulo: 'Únete a la comunidad de servicios de Quito.',
      tituloCentrado: true,
      anchoEscritorio: 520,
      esRegistro: true,
      child: _formulario(cargando: estado.isLoading, error: error),
    );
  }

  Widget _formulario({required bool cargando, String? error}) {
    const separacion = SizedBox(height: Espacios.l);
    final contrasena = CampoEtiquetado(
      etiqueta: 'Contraseña',
      child: CampoContrasena(
        key: ValueKey('contrasena-$_rechazos'),
        controller: _password,
        hintText: 'Mínimo 8 caracteres',
        autofillHints: const [AutofillHints.newPassword],
        textInputAction: TextInputAction.next,
        validator: FormValidators.password,
      ),
    );
    final confirmacion = CampoEtiquetado(
      etiqueta: 'Confirmar contraseña',
      child: CampoContrasena(
        key: ValueKey('confirmacion-$_rechazos'),
        controller: _confirmacion,
        hintText: 'Repite tu contraseña',
        icono: Icons.lock_reset,
        onFieldSubmitted: (_) => _enviar(),
        validator: _validarConfirmacion,
      ),
    );
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null) ...[
              AvisoBanner(tipo: TipoAviso.error, mensaje: error),
              const SizedBox(height: Espacios.l),
            ],
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: OpcionRol(
                      icono: Icons.search,
                      titulo: 'Buscar un servicio',
                      descripcion: 'Quiero contratar técnicos',
                      elegida: _rol == Rol.cliente,
                      onTap: () => setState(() => _rol = Rol.cliente),
                    ),
                  ),
                  const SizedBox(width: Espacios.m),
                  Expanded(
                    child: OpcionRol(
                      icono: Icons.handyman_outlined,
                      titulo: 'Ofrecer mis servicios',
                      descripcion: 'Soy técnico profesional',
                      elegida: _rol == Rol.tecnico,
                      onTap: () => setState(() => _rol = Rol.tecnico),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Espacios.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CampoEtiquetado(
                    etiqueta: 'Nombres',
                    child: TextFormField(
                      controller: _nombres,
                      decoration: const InputDecoration(
                        hintText: 'Jorge Luis ',
                      ),
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.givenName],
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          FormValidators.requerido(v, campo: 'Los nombres'),
                    ),
                  ),
                ),
                const SizedBox(width: Espacios.m),
                Expanded(
                  child: CampoEtiquetado(
                    etiqueta: 'Apellidos',
                    child: TextFormField(
                      controller: _apellidos,
                      decoration: const InputDecoration(
                        hintText: 'Zambrano García',
                      ),
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.familyName],
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          FormValidators.requerido(v, campo: 'Los apellidos'),
                    ),
                  ),
                ),
              ],
            ),
            separacion,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CampoEtiquetado(
                    etiqueta: 'Cédula',
                    ayuda: '10 dígitos',
                    child: TextFormField(
                      controller: _cedula,
                      decoration: const InputDecoration(
                        hintText: '17xxxxxxxx',
                        prefixIcon: Icon(Icons.badge_outlined),
                        errorMaxLines: 2,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: CedulaValidator.validate,
                    ),
                  ),
                ),
                const SizedBox(width: Espacios.m),
                Expanded(
                  child: CampoEtiquetado(
                    etiqueta: 'Código dactilar',
                    child: TextFormField(
                      controller: _dactilar,
                      decoration: const InputDecoration(
                        hintText: 'V1234V5678',
                        helperText: 'Está en el reverso de tu cédula',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: CodigoDactilarValidator.formatters,
                      textInputAction: TextInputAction.next,
                      validator: CodigoDactilarValidator.validate,
                    ),
                  ),
                ),
              ],
            ),
            separacion,
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
            separacion,
            if (MediaQuery.sizeOf(context).width >= 900)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: contrasena),
                  const SizedBox(width: Espacios.m),
                  Expanded(child: confirmacion),
                ],
              )
            else ...[
              contrasena,
              separacion,
              confirmacion,
            ],
            const SizedBox(height: Espacios.xl),
            Sacudir(
              senal: _fallos,
              child: BotonCarga(
                texto: 'Registrarse',
                icono: Icons.arrow_forward,
                iconoAlFinal: true,
                cargando: cargando,
                onPressed: _enviar,
              ),
            ),
            const SizedBox(height: Espacios.l),
            EnlaceAuth(
              pregunta: '¿Ya tienes cuenta?',
              accion: 'Inicia sesión',
              onPressed: () => context.go(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
