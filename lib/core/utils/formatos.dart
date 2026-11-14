abstract final class Formatos {
  static String dinero(double valor) => '\$${valor.toStringAsFixed(2)}';

  static String fecha(DateTime fecha) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(fecha.day)}/${dos(fecha.month)}/${fecha.year} '
        '${dos(fecha.hour)}:${dos(fecha.minute)}';
  }

  /// "Hoy", "Ayer" o la fecha (separadores del chat).
  static String dia(DateTime fecha, {DateTime? hoy}) {
    final ahora = hoy ?? DateTime.now();
    final d = DateTime(fecha.year, fecha.month, fecha.day);
    final h = DateTime(ahora.year, ahora.month, ahora.day);
    final diferencia = h.difference(d).inDays;
    if (diferencia == 0) return 'Hoy';
    if (diferencia == 1) return 'Ayer';
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(fecha.day)}/${dos(fecha.month)}/${fecha.year}';
  }

  /// "Lun 10/11/2026" (fecha del servicio).
  static String fechaCorta(DateTime fecha) {
    const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dias[fecha.weekday - 1]} '
        '${dos(fecha.day)}/${dos(fecha.month)}/${fecha.year}';
  }

  /// "Nov 2026" (miembro desde).
  static String mesAnio(DateTime f) {
    const m = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${m[f.month - 1]} ${f.year}';
  }

  static String hora(DateTime fecha) =>
      '${fecha.hour.toString().padLeft(2, '0')}:'
      '${fecha.minute.toString().padLeft(2, '0')}';

  /// "1,2 km": distancia siempre en kilómetros y con coma decimal.
  static String kilometros(double metros) =>
      '${(metros / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';

  /// "\$35" o "\$35.50": precio sin decimales cuando es entero.
  static String precio(double valor) => valor % 1 == 0
      ? '\$${valor.toStringAsFixed(0)}'
      : '\$${valor.toStringAsFixed(2)}';

  /// "hace 5 min", "hace 3 h", "ayer", "hace 4 días" o la fecha.
  static String haceTiempo(DateTime fecha, {DateTime? ahora}) {
    final diferencia = (ahora ?? DateTime.now()).difference(fecha);
    if (diferencia.inMinutes < 1) return 'hace un momento';
    if (diferencia.inMinutes < 60) return 'hace ${diferencia.inMinutes} min';
    if (diferencia.inHours < 24) return 'hace ${diferencia.inHours} h';
    if (diferencia.inDays == 1) return 'ayer';
    if (diferencia.inDays < 7) return 'hace ${diferencia.inDays} días';
    return 'el ${dia(fecha, hoy: ahora)}';
  }

  static String distancia(double metros) => metros < 1000
      ? '${metros.round()} m'
      : '${(metros / 1000).toStringAsFixed(1)} km';
}
