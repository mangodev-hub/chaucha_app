import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Etiqueta en negrita arriba del campo, con una ayuda azul opcional a la
/// derecha ("Ecuador (10 dígitos)", "Opcional").
class CampoEtiquetado extends StatelessWidget {
  const CampoEtiquetado({
    super.key,
    required this.etiqueta,
    required this.child,
    this.ayuda,
  });

  final String etiqueta;
  final String? ayuda;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final ayuda = this.ayuda;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                etiqueta,
                style: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (ayuda != null) ...[
              const SizedBox(width: Espacios.s),
              Flexible(
                child: Text(
                  ayuda,
                  textAlign: TextAlign.end,
                  style: textos.labelMedium?.copyWith(color: Colores.primario),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: Espacios.s - 2),
        child,
      ],
    );
  }
}

/// Campo de contraseña con candado y ojo para mostrarla u ocultarla.
class CampoContrasena extends StatefulWidget {
  const CampoContrasena({
    super.key,
    required this.controller,
    this.hintText,
    this.icono = Icons.lock_outline,
    this.validator,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData icono;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<CampoContrasena> createState() => _CampoContrasenaState();
}

class _CampoContrasenaState extends State<CampoContrasena> {
  bool _oculta = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _oculta,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icono),
        suffixIcon: IconButton(
          tooltip: _oculta ? 'Mostrar contraseña' : 'Ocultar contraseña',
          // El ojo cambia con un giro corto, escala y fundido.
          icon: AnimatedSwitcher(
            duration: Movimiento.de(context, Movimiento.rapido),
            switchInCurve: Movimiento.entrada,
            switchOutCurve: Movimiento.entrada,
            transitionBuilder: (child, animacion) => RotationTransition(
              turns: Tween<double>(begin: -0.1, end: 0).animate(animacion),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.6, end: 1).animate(animacion),
                child: FadeTransition(opacity: animacion, child: child),
              ),
            ),
            child: Icon(
              _oculta
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              key: ValueKey(_oculta),
            ),
          ),
          onPressed: () => setState(() => _oculta = !_oculta),
        ),
      ),
    );
  }
}
