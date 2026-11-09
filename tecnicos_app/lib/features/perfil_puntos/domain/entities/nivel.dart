// Niveles de gamificación y el progreso del técnico hacia el siguiente.
class Nivel {
  const Nivel({required this.nombre, required this.puntosMinimos});

  final String nombre;

  /// Puntos desde los que se alcanza este nivel.
  final int puntosMinimos;
}

class ProgresoNivel {
  const ProgresoNivel({
    required this.siguiente,
    required this.puntosFaltantes,
    required this.fraccion,
  });

  /// Calcula cuánto le falta al técnico con [puntos] para el siguiente nivel.
  /// La [fraccion] (0 a 1) mide el avance desde su nivel actual.
  factory ProgresoNivel.calcular(int puntos, List<Nivel> niveles) {
    final ordenados = [...niveles]
      ..sort((a, b) => a.puntosMinimos.compareTo(b.puntosMinimos));
    Nivel? actual;
    Nivel? siguiente;
    for (final n in ordenados) {
      if (n.puntosMinimos <= puntos) {
        actual = n;
      } else {
        siguiente = n;
        break;
      }
    }
    if (siguiente == null) {
      return const ProgresoNivel(
        siguiente: null,
        puntosFaltantes: 0,
        fraccion: 1,
      );
    }
    final desde = actual?.puntosMinimos ?? 0;
    final tramo = siguiente.puntosMinimos - desde;
    return ProgresoNivel(
      siguiente: siguiente,
      puntosFaltantes: siguiente.puntosMinimos - puntos,
      fraccion: tramo <= 0 ? 0 : ((puntos - desde) / tramo).clamp(0, 1),
    );
  }

  /// Null si ya está en el nivel más alto.
  final Nivel? siguiente;
  final int puntosFaltantes;
  final double fraccion;

  bool get esNivelMaximo => siguiente == null;
}
