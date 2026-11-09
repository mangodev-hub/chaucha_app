// Tokens de diseño: colores, radios, espacios, sombras y tipografía con nombre.
//
// Estilo: blanco y azul, fondos celestes suaves, tarjetas blancas con sombra
// sutil y campos azulados, tomado de las pantallas de referencia de login,
// registro y verificación (skill `diseno-chauchaapp`, `docs/DISENO.md`).
// Para cambiar el aspecto de la app se cambian aquí, no en cada pantalla.
import 'package:flutter/material.dart';

abstract final class Colores {
  // Marca: azul. Botones, enlaces, navegación activa, foco, progreso.
  /// Azul principal. Con texto blanco cumple AA (4.6:1).
  static const Color primario = Color(0xFF1976D2);

  /// Nombre de la marca, pasos completados, texto sobre `primarioSuave`.
  static const Color primarioOscuro = Color(0xFF1565C0);

  /// Azul brillante de la referencia, solo decorativo (círculo del logo,
  /// íconos ilustrativos): con texto blanco no llega a AA.
  static const Color primarioVivo = Color(0xFF2196F3);

  /// Pasos pendientes, bordes de lo resaltado.
  static const Color primarioClaro = Color(0xFFBBDEFB);

  /// Fondo de lo elegido o resaltado, íconos en recuadro, avatares.
  static const Color primarioSuave = Color(0xFFE3F2FD);
  static const Color primarioProfundo = Color(0xFF0D47A1);

  // Texto: azul marino y gris azulado.
  static const Color tinta = Color(0xFF0F2A44);
  static const Color tintaSuave = Color(0xFF5B6B7F);

  // Fondos y superficies.
  /// Fondo celeste muy suave de las pantallas.
  static const Color fondo = Color(0xFFF2F8FE);

  /// Tarjetas, diálogos, hojas inferiores y barras: blanco.
  static const Color tarjeta = Color(0xFFFFFFFF);

  /// Campos de texto y opciones sin elegir: celeste claro.
  static const Color superficie = Color(0xFFEAF3FC);
  static const Color superficieFuerte = Color(0xFFD6E6F7);
  static const Color linea = Color(0xFFE1EAF4);

  // Acento verde: solo para lo positivo (completado, aprobado, verificado).
  static const Color acento = Color(0xFF2E9E5B);
  static const Color acentoSuave = Color(0xFFE3F4EA);
  static const Color acentoOscuro = Color(0xFF1B5E36);

  // Semánticos.
  /// Celeste oscuro, distinto del primario: estados "Abierta" y similares.
  static const Color info = Color(0xFF0369A1);
  static const Color aviso = Color(0xFFD97706);
  static const Color avisoSuave = Color(0xFFFEF3E2);
  static const Color avisoOscuro = Color(0xFF92400E);
  static const Color error = Color(0xFFC62828);
  static const Color errorSuave = Color(0xFFFDECEC);
  static const Color errorOscuro = Color(0xFF8C1D18);

  // Estrellas de calificación.
  static const Color estrella = Color(0xFFF5A623);
}

abstract final class Radios {
  static const double pequeno = 8;
  static const double medio = 12;
  static const double grande = 16;

  /// Tarjeta principal de login y registro, hojas inferiores.
  static const double muyGrande = 24;
  static const double pildora = 999;
}

abstract final class Espacios {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class Sombras {
  /// Sombra sutil y azulada para tarjetas.
  static const List<BoxShadow> suave = [
    BoxShadow(color: Color(0x140F2A44), blurRadius: 18, offset: Offset(0, 6)),
  ];

  /// Sombra del botón principal ("destacado").
  static const Color boton = Color(0x661976D2);

  /// Sombra azul de las tarjetas con fondo azul (`TarjetaPortada`).
  static const List<BoxShadow> azul = [
    BoxShadow(color: Color(0x401976D2), blurRadius: 24, offset: Offset(0, 10)),
  ];
}

abstract final class Degradados {
  /// Fondo de las tarjetas de portada del inicio: del azul principal al
  /// profundo. Con texto blanco cumple AA en todo el recorrido.
  static const LinearGradient portada = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colores.primario, Colores.primarioProfundo],
  );
}

/// Duraciones y curvas de las animaciones. Las pantallas y componentes piden
/// la duración con [Movimiento.de], que respeta la opción del sistema
/// "reducir animaciones" (accesibilidad).
abstract final class Movimiento {
  /// Íconos que cambian (ojo de la contraseña).
  static const Duration rapido = Duration(milliseconds: 150);

  /// Cambios de estado: botones, píldoras, pasos.
  static const Duration normal = Duration(milliseconds: 250);

  /// Momentos de éxito: check animado y aparición con rebote.
  static const Duration lento = Duration(milliseconds: 500);

  /// Curva general: arranca rápido y frena suave.
  static const Curve entrada = Curves.easeOutCubic;

  /// Pasa un poco del tamaño final y vuelve ("pop"). Solo para lo positivo.
  static const Curve rebote = Curves.easeOutBack;

  /// [duracion], o cero si el sistema pide reducir las animaciones.
  static Duration de(BuildContext context, Duration duracion) =>
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false)
      ? Duration.zero
      : duracion;
}

abstract final class Tipografia {
  /// Provisional. Se descarga con `google_fonts`; antes de publicar hay que
  /// incluir los archivos de la fuente en la app (ver `docs/DISENO.md`).
  static const String familia = 'Plus Jakarta Sans';
}
