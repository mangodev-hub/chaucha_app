// Conversión segura de valores que llegan de Supabase.
double aDouble(Object? valor, {double porDefecto = 0}) {
  if (valor is num) return valor.toDouble();
  if (valor is String) return double.tryParse(valor) ?? porDefecto;
  return porDefecto;
}

int aInt(Object? valor, {int porDefecto = 0}) {
  if (valor is num) return valor.toInt();
  if (valor is String) return int.tryParse(valor) ?? porDefecto;
  return porDefecto;
}

DateTime aFecha(Object? valor) =>
    valor is String ? DateTime.parse(valor).toLocal() : DateTime.now();



Map<String, dynamic>? anidado(Object? valor) {
  if (valor is Map<String, dynamic>) return valor;
  if (valor is List && valor.isNotEmpty && valor.first is Map<String, dynamic>) {
    return valor.first as Map<String, dynamic>;
  }
  return null;
}
