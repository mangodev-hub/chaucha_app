// Tokens de diseño: colores, radios, espacios y tipografía con nombre.
//
// DISEÑO PROVISIONAL: estos valores se van a redefinir (paleta, tipografía,
// marca). Para cambiar el aspecto de la app se cambian aquí, no en cada
// pantalla. Ver `docs/DISENO.md`.
import 'package:flutter/material.dart';

abstract final class Colores {
  // Base: casi negro sobre blanco, tarjetas en gris claro.
  static const Color tinta = Color(0xFF111111);
  static const Color tintaSuave = Color(0xFF5E5E5E);
  static const Color fondo = Color(0xFFFFFFFF);
  static const Color superficie = Color(0xFFF3F3F3);
  static const Color superficieFuerte = Color(0xFFE8E8E8);
  static const Color linea = Color(0xFFE2E2E2);

  // Acento (provisional: verde). Solo para lo positivo: puntos, nivel,
  // verificado, completado.
  static const Color acento = Color(0xFF2E9E5B);
  static const Color acentoSuave = Color(0xFFE3F4EA);
  static const Color acentoOscuro = Color(0xFF1B5E36);

  // Semánticos.
  static const Color info = Color(0xFF2563C9);
  static const Color aviso = Color(0xFFD97706);
  static const Color error = Color(0xFFC62828);
  static const Color errorSuave = Color(0xFFFDECEC);

  // Estrellas de calificación.
  static const Color estrella = Color(0xFFF5A623);
}

abstract final class Radios {
  static const double pequeno = 8;
  static const double medio = 12;
  static const double grande = 16;
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

abstract final class Tipografia {
  /// Provisional. Se descarga con `google_fonts`; antes de publicar hay que
  /// incluir los archivos de la fuente en la app (ver `docs/DISENO.md`).
  static const String familia = 'Plus Jakarta Sans';
}
