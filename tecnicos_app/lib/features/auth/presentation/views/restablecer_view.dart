import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/sacudir.dart';
import '../providers/recuperacion_providers.dart';
import '../widgets/auth_layout.dart';

class RestablecerView extends ConsumerStatefulWidget {
  const RestablecerView({super.key, required this.onCancelar});

  final Future<void> Function() onCancelar;

  @override
  ConsumerState<RestablecerView> createState() => _RestablecerViewState();
}

class _RestablecerViewState extends ConsumerState<RestablecerView> {
  final _formKey = GlobalKey<FormState>();

  /// Intentos de envío fallidos: cada uno sacude el botón.
  int _fallos = 0;

  void _avisarFallo() => setState(() => _fallos++);

  final _password = TextEditingController();
  final _confirmacion = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmacion.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _avisarFallo();
      return;
    }
    final mensajes = ScaffoldMessenger.of(context);
    final bien =
        await ref.read(restablecerProvider.notifier).cambiar(_password.text);
    if (bien) {
      mensajes.showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(restablecerProvider);
    // Si el servidor responde con error, el botón también se sacude.
    ref.listen(restablecerProvider, (_, siguiente) {
      if (siguiente.hasError && !siguiente.isLoading) _avisarFallo();
    });
    final cargando = estado.isLoading;
    final error = cargando || !estado.hasError
        ? null
        : AsyncValueView.mensajeDe(estado.error!);

    return AuthLayout(
      titulo: 'Nueva contraseña',
      subtitulo: 'Elige una contraseña que no uses en otros sitios.',
      tituloCentrado: true,
      anchoEscritorio: 440,
      panelDetallado: true,
      child: AutofillGroup(
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
                etiqueta: 'Nueva contraseña',
                child: CampoContrasena(
                  controller: _password,
                  hintText: 'Mínimo 8 caracteres',
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  validator: FormValidators.password,
                ),
              ),
              const SizedBox(height: Espacios.l),
              CampoEtiquetado(
                etiqueta: 'Confirmar contraseña',
                child: CampoContrasena(
                  controller: _confirmacion,
                  hintText: 'Repite tu contraseña',
                  icono: Icons.lock_reset,
                  onFieldSubmitted: (_) => _guardar(),
                  validator: (valor) => valor == _password.text
                      ? null
                      : 'Las contraseñas no coinciden.',
                ),
              ),
              const SizedBox(height: Espacios.xl),
              Sacudir(
                senal: _fallos,
                child: BotonCarga(
                  texto: 'Guardar contraseña',
                  icono: Icons.check,
                  cargando: cargando,
                  onPressed: _guardar,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: cargando ? null : widget.onCancelar,
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}