abstract final class CedulaValidator {
  static const int _longitud = 10;
  static const int _provinciaExtranjeros = 30;
  static const int _ultimaProvincia = 24;
  static const int _tercerDigitoMaximo = 5;
  static const List<int> _coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];

  static bool isValid(String? cedula) => validate(cedula) == null;

  static String? validate(String? value) {
    final cedula = value?.trim() ?? '';

    if (cedula.isEmpty) return 'Ingresa tu número de cédula.';
    if (!RegExp(r'^\d+$').hasMatch(cedula)) {
      return 'La cédula solo debe contener números.';
    }
    if (cedula.length != _longitud) {
      return 'La cédula debe tener $_longitud dígitos.';
    }

    final digitos = cedula.split('').map(int.parse).toList();

    final provincia = digitos[0] * 10 + digitos[1];
    final provinciaValida =
        (provincia >= 1 && provincia <= _ultimaProvincia) ||
        provincia == _provinciaExtranjeros;
    if (!provinciaValida) return 'El código de provincia no es válido.';

    if (digitos[2] > _tercerDigitoMaximo) {
      return 'La cédula no corresponde a una persona natural.';
    }

    if (_digitoVerificador(digitos) != digitos[9]) {
      return 'La cédula no es válida. Revisa los dígitos.';
    }
    return null;
  }

  static int _digitoVerificador(List<int> digitos) {
    var suma = 0;
    for (var i = 0; i < _coeficientes.length; i++) {
      final producto = digitos[i] * _coeficientes[i];
      suma += producto > 9 ? producto - 9 : producto;
    }
    return (10 - suma % 10) % 10;
  }
}
