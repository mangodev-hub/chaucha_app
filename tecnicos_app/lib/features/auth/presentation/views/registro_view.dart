// Pantalla de registro de clientes y técnicos.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../domain/entities/registro_resultado.dart';
import '../../domain/entities/rol.dart';
import '../providers/registro_provider.dart';
import '../widgets/auth_layout.dart';

class RegistroView extends ConsumerStatefulWidget {
  const RegistroView({super.key});

  @override
  ConsumerState<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends ConsumerState<RegistroView> {
  final _formKey = GlobalKey<FormState>();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _cedula = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmacion = TextEditingController();
  Rol _rol = Rol.cliente;
  bool _ocultarPassword = true;

  @override
  void dispose() {
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

  String? _validarConfirmacion(String? valor) =>
      valor == _password.text ? null : 'Las contraseñas no coinciden.';

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(registroProvider.notifier).registrar(
          email: _email.text,
          password: _password.text,
          nombres: _nombres.text,
          apellidos: _apellidos.text,
          cedula: _cedula.text,
          rol: _rol,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registroProvider, (_, estado) {
      if (estado case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AsyncValueView.mensajeDe(error))),
        );
      }
    });
    final estado = ref.watch(registroProvider);

    return AuthLayout(
      titulo: 'Crear cuenta',
      // Si entra directo (sin confirmar correo), el router redirige solo.
      child: switch (estado) {
        AsyncData(value: RegistroResultado.confirmarCorreo) =>
          const _ConfirmarCorreo(),
        _ => _formulario(cargando: estado.isLoading),
      },
    );
  }

  Widget _formulario({required bool cargando}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<Rol>(
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
            selected: {_rol},
            onSelectionChanged: (seleccion) =>
                setState(() => _rol = seleccion.first),
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
          TextFormField(
            controller: _password,
            obscureText: _ocultarPassword,
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.next,
            validator: FormValidators.password,
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmacion,
            obscureText: _ocultarPassword,
            onFieldSubmitted: (_) => _enviar(),
            validator: _validarConfirmacion,
            decoration:
                const InputDecoration(labelText: 'Repite la contraseña'),
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
