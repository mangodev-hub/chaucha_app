// Implementa registro_view para la aplicación.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/state/view_state.dart';
import '../../../core/validators/cedula_validator.dart';
import '../../../core/validators/form_validators.dart';
import '../../../core/widgets/boton_carga.dart';
import '../models/rol.dart';
import '../services/auth_service.dart';
import '../viewmodels/registro_view_model.dart';
import 'widgets/auth_layout.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key, required this.authService});

  final AuthService authService;

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  late final RegistroViewModel _viewModel =
      RegistroViewModel(widget.authService);
  final _formKey = GlobalKey<FormState>();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _cedula = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmacion = TextEditingController();

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
    for (final controller in [
      _nombres,
      _apellidos,
      _cedula,
      _email,
      _password,
      _confirmacion,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _mostrarErrorSiHay() {
    final estado = _viewModel.value;
    if (estado is ViewError<RegistroResultado> && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(estado.message)));
    }
  }

  String? _validarConfirmacion(String? valor) =>
      valor == _password.text ? null : 'Las contraseñas no coinciden.';

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _viewModel.registrar(
      email: _email.text,
      password: _password.text,
      nombres: _nombres.text,
      apellidos: _apellidos.text,
      cedula: _cedula.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      titulo: 'Crear cuenta',
      child: ValueListenableBuilder<ViewState<RegistroResultado>>(
        valueListenable: _viewModel,
        builder: (context, estado, _) {


          if (estado case ViewLoaded(data: RegistroResultado.confirmarCorreo)) {
            return const _ConfirmarCorreo();
          }
          return _formulario(cargando: estado is ViewLoading<RegistroResultado>);
        },
      ),
    );
  }

  Widget _formulario({required bool cargando}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Rol>(
            valueListenable: _viewModel.rol,
            builder: (context, rol, _) => SegmentedButton<Rol>(
              segments: const [
                ButtonSegment(
                  value: Rol.cliente,
                  label: Text('Necesito un técnico'),
                  icon: Icon(Icons.home_outlined),
                ),
                ButtonSegment(
                  value: Rol.tecnico,
                  label: Text('Soy técnico'),
                  icon: Icon(Icons.handyman_outlined),
                ),
              ],
              selected: {rol},
              onSelectionChanged: (seleccion) =>
                  _viewModel.seleccionarRol(seleccion.first),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nombres,
            decoration: const InputDecoration(labelText: 'Nombres'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (v) => FormValidators.requerido(v, campo: 'Los nombres'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _apellidos,
            decoration: const InputDecoration(labelText: 'Apellidos'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                FormValidators.requerido(v, campo: 'Los apellidos'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cedula,
            decoration: const InputDecoration(labelText: 'Cédula'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            textInputAction: TextInputAction.next,
            validator: CedulaValidator.validate, 
          ),
          const SizedBox(height: 16),
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
            builder: (context, ocultar, _) => Column(
              children: [
                TextFormField(
                  controller: _password,
                  obscureText: ocultar,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  validator: FormValidators.password,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      tooltip: ocultar ? 'Mostrar' : 'Ocultar',
                      icon: Icon(
                        ocultar ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _viewModel.alternarPassword,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmacion,
                  obscureText: ocultar,
                  onFieldSubmitted: (_) => _enviar(),
                  validator: _validarConfirmacion,
                  decoration:
                      const InputDecoration(labelText: 'Repite la contraseña'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BotonCarga(
            texto: 'Crear cuenta',
            cargando: cargando,
            onPressed: _enviar,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('¿Ya tienes cuenta? Inicia sesión'),
          ),
        ],
      ),
    );
  }
}

class _ConfirmarCorreo extends StatelessWidget {
  const _ConfirmarCorreo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 56),
        const SizedBox(height: 16),
        const Text(
          'Te enviamos un correo de confirmación. Ábrelo y luego inicia sesión.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go(AppRoutes.login),
          child: const Text('Ir a iniciar sesión'),
        ),
      ],
    );
  }
}
