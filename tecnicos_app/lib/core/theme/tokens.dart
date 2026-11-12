// Tokens de diseño: colores, radios, espacios, sombras y tipografía con nombre.
//
// Estilo: verde y celeste. El verde bosque es la marca y las acciones; el
// verde marca (más vivo) va en el logo, los íconos activos y el progreso; el
// celeste es lo del cliente, la información y los acentos. Fondos verde muy
// suave, tarjetas blancas con sombra sutil y campos verdosos sin borde
// (ver `docs/DISENO.md`). Para cambiar el aspecto de la app se cambian aquí,
// no en cada pantalla.
import 'package:flutter/material.dart';

abstract final class Colores {
  // Marca: verde bosque. Botones, enlaces, pestaña activa, foco, portada.
  /// Verde bosque. Con texto blanco cumple AA y AAA (7.4:1).
  static const Color primario = Color(0xFF006414);

  /// Nombre de la marca, pasos completados, texto sobre `primarioSuave`.
  static const Color primarioOscuro = Color(0xFF004B0F);

  /// Verde marca: logo, íconos activos, barras de progreso y foco. Con
  /// texto blanco da 3.8:1, así que no lleva texto normal encima.
  static const Color primarioVivo = Color(0xFF009929);

  /// Verde brote: puntos del calendario, check de éxito, acentos de la
  /// portada y pasos pendientes. Solo decorativo o con texto oscuro.
  static const Color primarioClaro = Color(0xFF5CCB5F);

  /// Fondo de lo elegido o resaltado, mis burbujas del chat, íconos en
  /// recuadro, avatares.
  static const Color primarioSuave = Color(0xFFE3F6E4);

  /// Verde más profundo que el bosque, para fondos de marca en escritorio.
  static const Color primarioProfundo = Color(0xFF003D0C);

  // Celeste: lo que es del cliente, información, distancia y la tuerca del
  // logo. Con texto blanco no llega a AA: se usa con texto oscuro o como
  // decoración; para texto celeste se usa `info`.
  static const Color cielo = Color(0xFF27A3DF);
  static const Color cieloClaro = Color(0xFF41B6EF);
  static const Color cieloSuave = Color(0xFFE3F3FC);

  /// Celeste oscuro, legible como texto sobre blanco y sobre `cieloSuave`.
  static const Color cieloOscuro = Color(0xFF0B4F73);

  /// Fondo de la conversación del chat: celeste casi blanco, para que las
  /// burbujas blancas y verdes se distingan del resto de la app.
  static const Color fondoChat = Color(0xFFEEF7FC);

  // Texto: verde muy oscuro y gris verdoso.
  static const Color tinta = Color(0xFF0E2A14);
  static const Color tintaSuave = Color(0xFF4F6654);

  // Fondos y superficies.
  /// Fondo verde muy suave de las pantallas.
  static const Color fondo = Color(0xFFF3FAF4);

  /// Tarjetas, diálogos, hojas inferiores y barras: blanco.
  static const Color tarjeta = Color(0xFFFFFFFF);

  /// Campos de texto y opciones sin elegir: verde claro.
  static const Color superficie = Color(0xFFEAF6EB);
  static const Color superficieFuerte = Color(0xFFD5EBD7);
  static const Color linea = Color(0xFFDCEBDD);

  // Acento positivo (completado, aprobado, verificado): el verde marca.
  static const Color acento = primarioVivo;
  static const Color acentoSuave = Color(0xFFDDF5DE);
  static const Color acentoOscuro = primario;

  // Semánticos.
  /// Celeste legible como texto: estados "Abierta" y similares, distancia.
  static const Color info = Color(0xFF0F6E9E);
  static const Color aviso = Color(0xFFB45309);
  static const Color avisoSuave = Color(0xFFFDF0E1);
  static const Color avisoOscuro = Color(0xFF7C3A06);
  static const Color error = Color(0xFFB3261E);
  static const Color errorSuave = Color(0xFFFDECEA);
  static const Color errorOscuro = Color(0xFF8C1D18);

  // Estrellas de calificación.
  static const Color estrella = Color(0xFFE39B00);
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
  /// Sombra sutil y verdosa para tarjetas.
  static const List<BoxShadow> suave = [
    BoxShadow(color: Color(0x140E2A14), blurRadius: 18, offset: Offset(0, 6)),
  ];

  /// Sombra del botón principal ("destacado").
  static const Color boton = Color(0x66006414);

  /// Sombra verde más marcada para las tarjetas con fondo verde
  /// (`TarjetaPortada`) y el botón central de la barra inferior.
  static const List<BoxShadow> fuerte = [
    BoxShadow(color: Color(0x40006414), blurRadius: 24, offset: Offset(0, 10)),
  ];
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
  /// Una sola familia para todo. Se descarga con `google_fonts`; antes de
  /// publicar hay que incluir los archivos de la fuente en la app (ver
  /// `docs/DISENO.md`).
  static const String familia = 'Figtree';
}
