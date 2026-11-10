import 'package:flutter/services.dart';

abstract final class CodigoDactilarValidator {
  static final _formato = RegExp(r'^[A-Z]\d{4}[A-Z]\d{4}$');

  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
    LengthLimitingTextInputFormatter(10),
    TextInputFormatter.withFunction(
      (anterior, nuevo) => nuevo.copyWith(text: nuevo.text.toUpperCase()),
    ),
  ];

  static String? validate(String? value) {
    final codigo = value?.trim().toUpperCase() ?? '';
    if (codigo.isEmpty) return 'Ingresa tu código dactilar.';
    return _formato.hasMatch(codigo)
        ? null
        : 'Formato inválido. Ejemplo: V1234V5678.';
  }
}
