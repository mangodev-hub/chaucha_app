// Validadores reutilizables para.
abstract final class FormValidators {
  static String? requerido(String? value, {String campo = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) return '$campo es obligatorio.';
    return null;
  }

  static String? email(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu correo.';
    final valido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(texto);
    return valido ? null : 'El correo no tiene un formato válido.';
  }

  static String? password(String? value, {int minimo = 8}) {
    if (value == null || value.length < minimo) {
      return 'La contraseña debe tener al menos $minimo caracteres.';
    }
    return null;
  }


  static String? monto(String? value, {String campo = 'El monto'}) {
    final texto = value?.trim().replaceAll(',', '.') ?? '';
    if (texto.isEmpty) return '$campo es obligatorio.';
    final numero = double.tryParse(texto);
    if (numero == null) return '$campo debe ser un número.';
    if (numero < 0) return '$campo no puede ser negativo.';
    return null;
  }


  static String? estrellas(int? value) {
    if (value == null || value < 1 || value > 5) {
      return 'Selecciona entre 1 y 5 estrellas.';
    }
    return null;
  }
}
