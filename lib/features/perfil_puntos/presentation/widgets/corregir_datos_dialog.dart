import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../core/validators/codigo_dactilar_validator.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../domain/entities/datos_identidad.dart';
import '../../domain/entities/verificacion.dart';
import '../providers/verificacion_provider.dart';

/// Devuelve true si se guardaron los datos.
Future<bool?> mostrarCorregirDatos(
  BuildContext context,
  Set<CampoIdentidad> campos,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: CorregirDatosDialog(campos: campos),
      ),
    ),
  );
}

class CorregirDatosDialog extends ConsumerStatefulWidget {
  const CorregirDatosDialog({super.key, required this.campos});

  /// Los que no coincidieron: se resaltan.
  final Set<CampoIdentidad> campos;

  @override
  ConsumerState<CorregirDatosDialog> createState() =>
      _CorregirDatosDialogState();
}

class _CorregirDatosDialogState extends ConsumerState<CorregirDatosDialog> {
  final _form = GlobalKey<FormState>();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _cedula = TextEditingController();
  final _dactilar = TextEditingController();
  bool _cargado = false;

  @override
  void dispose() {
    for (final c in [_nombres, _apellidos, _cedula, _dactilar]) {
      c.dispose();
    }
    super.dispose();
  }

  void _llenar(DatosIdentidad d) {
    if (_cargado) return;
    _cargado = true;
    _nombres.text = d.nombres;
    _apellidos.text = d.apellidos;
    _cedula.text = d.cedula;
    _dactilar.text = d.codigoDactilar ?? '';
  }

  Future<void> _guardar() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final ok = await ref
        .read(corregirDatosProvider.notifier)
        .corregir(
          DatosIdentidad(
            nombres: _nombres.text,
            apellidos: _apellidos.text,
            cedula: _cedula.text,
            codigoDactilar: _dactilar.text,
          ),
        );
    if (ok && mounted) Navigator.pop(context, true);
  }

  /// Texto de ayuda bajo el campo que no coincidió.
  String? _aviso(CampoIdentidad campo) => widget.campos.contains(campo)
      ? 'No coincide con tu cédula. Escríbelo tal como aparece en ella.'
      : null;

  Widget _campo({
    required CampoIdentidad campo,
    required String etiqueta,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    TextInputType? teclado,
    List<TextInputFormatter>? formatos,
    TextCapitalization mayusculas = TextCapitalization.words,
  }) {
    final aviso = _aviso(campo);
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.m),
      child: CampoEtiquetado(
        etiqueta: etiqueta,
        child: TextFormField(
          controller: controller,
          keyboardType: teclado,
          inputFormatters: formatos,
          textCapitalization: mayusculas,
          validator: validator,
          decoration: InputDecoration(
            helperText: aviso,
            helperMaxLines: 2,
            helperStyle: aviso == null
                ? null
                : const TextStyle(color: Colores.error),
            prefixIcon: aviso == null
                ? null
                : const Icon(Icons.error_outline, color: Colores.error),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final guardado = ref.watch(corregirDatosProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Espacios.xl),
      child: AsyncValueView<DatosIdentidad>(
        value: ref.watch(misDatosIdentidadProvider),
        onRetry: () => ref.invalidate(misDatosIdentidadProvider),
        onData: (context, datos) {
          _llenar(datos);
          return Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.campos.isEmpty
                      ? 'Corrige tus datos'
                      : 'Tus datos no coinciden con tu cédula',
                  style: textos.headlineSmall,
                ),
                const SizedBox(height: Espacios.xs),
                Text(
                  'Escríbelos exactamente como aparecen en tu cédula. Al '
                  'guardar, la volvemos a revisar.',
                  style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
                ),
                const SizedBox(height: Espacios.l),
                if (guardado.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Espacios.m),
                    child: AvisoBanner(
                      tipo: TipoAviso.error,
                      mensaje: AsyncValueView.mensajeDe(guardado.error!),
                    ),
                  ),
                _campo(
                  campo: CampoIdentidad.nombres,
                  etiqueta: 'Nombres',
                  controller: _nombres,
                  validator: (v) =>
                      FormValidators.requerido(v, campo: 'Los nombres'),
                ),
                _campo(
                  campo: CampoIdentidad.apellidos,
                  etiqueta: 'Apellidos',
                  controller: _apellidos,
                  validator: (v) =>
                      FormValidators.requerido(v, campo: 'Los apellidos'),
                ),
                _campo(
                  campo: CampoIdentidad.cedula,
                  etiqueta: 'Cédula',
                  controller: _cedula,
                  validator: CedulaValidator.validate,
                  teclado: TextInputType.number,
                  formatos: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  mayusculas: TextCapitalization.none,
                ),
                _campo(
                  campo: CampoIdentidad.codigoDactilar,
                  etiqueta: 'Código dactilar',
                  controller: _dactilar,
                  validator: CodigoDactilarValidator.validate,
                  formatos: CodigoDactilarValidator.formatters,
                  mayusculas: TextCapitalization.characters,
                ),
                const SizedBox(height: Espacios.s),
                BotonCarga(
                  texto: 'Guardar y volver a revisar',
                  cargando: guardado.isLoading,
                  onPressed: guardado.isLoading ? null : _guardar,
                ),
                TextButton(
                  onPressed: guardado.isLoading
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
