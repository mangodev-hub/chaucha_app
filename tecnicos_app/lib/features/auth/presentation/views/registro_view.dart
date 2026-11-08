// Pantalla de registro de clientes y técnicos.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/registro_resultado.dart';
import '../../domain/entities/rol.dart';
import '../providers/registro_provider.dart';
import '../widgets/auth_layout.dart';
import '../widgets/enlace_auth.dart';

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
    await ref
        .read(registroProvider.notifier)
        .registrar(
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
        context.mostrarMensaje(
          AsyncValueView.mensajeDe(error),
          tipo: TipoMensaje.error,
        );
      }
    });
    final estado = ref.watch(registroProvider);

    // Si entra directo (sin confirmar correo), el router redirige solo.
    if (estado case AsyncData(value: RegistroResultado.confirmarCorreo)) {
      return AuthLayout(
        titulo: 'Revisa tu correo',
        tituloCentrado: true,
        child: EstadoMensaje(
          icono: Icons.mark_email_read_outlined,
          tipo: TipoEstado.exito,
          mensaje:
              'Te enviamos un enlace de confirmación. '
              'Ábrelo y luego inicia sesión.',
          textoAccion: 'Ir a iniciar sesión',
          onAccion: () => context.go(AppRoutes.login),
        ),
      );
    }

    return AuthLayout(
      titulo: 'Crear cuenta',
      subtitulo: 'Únete a la comunidad de servicios de Quito.',
      tituloCentrado: true,
      child: _formulario(cargando: estado.isLoading),
    );
  }

  Widget _formulario({required bool cargando}) {
    const separacion = SizedBox(height: Espacios.l);
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _OpcionRol(
                      icono: Icons.search,
                      titulo: 'Buscar un servicio',
                      descripcion: 'Quiero contratar técnicos',
                      elegida: _rol == Rol.cliente,
                      onTap: () => setState(() => _rol = Rol.cliente),
                    ),
                  ),
                  const SizedBox(width: Espacios.m),
                  Expanded(
                    child: _OpcionRol(
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
                        hintText: 'Juan Carlos',
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
                      decoration: const InputDecoration(hintText: 'Morales V.'),
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
            CampoEtiquetado(
              etiqueta: 'Cédula de identidad',
              ayuda: 'Ecuador (10 dígitos)',
              child: TextFormField(
                controller: _cedula,
                decoration: const InputDecoration(
                  hintText: '17xxxxxxxx',
                  prefixIcon: Icon(Icons.badge_outlined),
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
            CampoEtiquetado(
              etiqueta: 'Contraseña',
              child: CampoContrasena(
                controller: _password,
                hintText: 'Mínimo 8 caracteres',
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                validator: FormValidators.password,
              ),
            ),
            separacion,
            CampoEtiquetado(
              etiqueta: 'Confirmar contraseña',
              child: CampoContrasena(
                controller: _confirmacion,
                hintText: 'Repite tu contraseña',
                icono: Icons.lock_reset,
                onFieldSubmitted: (_) => _enviar(),
                validator: _validarConfirmacion,
              ),
            ),
            const SizedBox(height: Espacios.xl),
            BotonCarga(
              texto: 'Registrarse',
              icono: Icons.arrow_forward,
              iconoAlFinal: true,
              cargando: cargando,
              onPressed: _enviar,
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

/// Tarjeta para elegir el tipo de cuenta: celeste sin elegir; con borde
/// azul y check cuando está elegida.
class _OpcionRol extends StatelessWidget {
  const _OpcionRol({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.elegida,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool elegida;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: elegida,
      child: TarjetaApp(
        onTap: onTap,
        radio: Radios.medio,
        conSombra: false,
        color: elegida ? Colores.tarjeta : Colores.superficie,
        colorBorde: elegida ? Colores.primario : Colores.superficie,
        padding: const EdgeInsets.all(Espacios.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconoRecuadro(icono: icono, lado: 32),
                const Spacer(),
                if (elegida)
                  const Icon(
                    Icons.check_circle,
                    color: Colores.primario,
                    size: 22,
                  ),
              ],
            ),
            const SizedBox(height: Espacios.s),
            Text(titulo, style: textos.titleSmall),
            const SizedBox(height: 2),
            Text(
              descripcion,
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
          ],
        ),
      ),
    );
  }
}
