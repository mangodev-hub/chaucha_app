abstract final class FormValidators {
  static String? requerido(String? value, {String campo = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) return '$campo es obligatorio.';
    return null;
  }

  static String? email(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu correo.';
    if (texto.length > 254) return 'El correo es demasiado largo.';
    final valido = RegExp(
      r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$',
    ).hasMatch(texto);
    return valido ? null : 'El correo no tiene un formato válido.';
  }

  static String? password(String? value, {int minimo = 8}) {
    final texto = value ?? '';
    if (texto.length < minimo) return 'Debe tener al menos $minimo caracteres.';
    if (texto.length > 72) return 'Máximo 72 caracteres.';
    if (texto.contains(' ')) return 'No puede contener espacios.';
    if (!RegExp(r'[a-z]').hasMatch(texto)) {
      return 'Incluye una letra minúscula.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(texto)) {
      return 'Incluye una letra mayúscula.';
    }
    if (!RegExp(r'\d').hasMatch(texto)) return 'Incluye al menos un número.';
    return null;
  }

  static String? nombre(String? value, {String campo = 'Este campo'}) {
    final texto = value?.trim() ?? '';
    if (texto.length < 2) return '$campo debe tener al menos 2 letras.';
    if (texto.length > 60) return '$campo es demasiado largo.';
    final valido = RegExp(
      r"^[A-Za-zÁÉÍÓÚÜáéíóúüÑñ]+([ '\-][A-Za-zÁÉÍÓÚÜáéíóúüÑñ]+)*$",
    ).hasMatch(texto);
    return valido ? null : '$campo solo puede tener letras.';
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
