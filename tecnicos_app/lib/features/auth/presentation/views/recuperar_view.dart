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
import '../../../../core/widgets/estado_mensaje.dart';
import '../providers/recuperacion_providers.dart';
import '../widgets/auth_layout.dart';
import '../widgets/enlace_auth.dart';

class RecuperarView extends ConsumerStatefulWidget {
  const RecuperarView({super.key});

  @override
  ConsumerState<RecuperarView> createState() => _RecuperarViewState();
}

class _RecuperarViewState extends ConsumerState<RecuperarView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(recuperarProvider.notifier).enviar(_email.text);
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(recuperarProvider);
    final cargando = estado.isLoading;
    final error = cargando || !estado.hasError
        ? null
        : AsyncValueView.mensajeDe(estado.error!);

    if (estado.value ?? false) {
      return AuthLayout(
        titulo: 'Revisa tu correo',
        tituloCentrado: true,
        child: EstadoMensaje(
          icono: Icons.mark_email_read_outlined,
          tipo: TipoEstado.exito,
          mensaje: 'Si el correo está registrado, te enviamos un enlace '
              'para crear una nueva contraseña.',
          textoAccion: 'Volver a iniciar sesión',
          onAccion: () => context.go(AppRoutes.login),
        ),
      );
    }

    return AuthLayout(
      titulo: '¿Olvidaste tu contraseña?',
      subtitulo: 'Escribe tu correo y te enviamos un enlace para recuperarla.',
      tituloCentrado: true,
      anchoEscritorio: 440,
      panelDetallado: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null) ...[
              AvisoBanner(tipo: TipoAviso.error, mensaje: error),
              const SizedBox(height: Espacios.l),
            ],
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
                onFieldSubmitted: (_) => _enviar(),
                validator: FormValidators.email,
              ),
            ),
            const SizedBox(height: Espacios.xl),
            BotonCarga(
              texto: 'Enviar enlace',
              icono: Icons.arrow_forward,
              iconoAlFinal: true,
              cargando: cargando,
              onPressed: _enviar,
            ),
            const SizedBox(height: Espacios.l),
            EnlaceAuth(
              pregunta: '¿Ya la recordaste?',
              accion: 'Inicia sesión',
              onPressed: () => context.go(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}