import 'package:flutter/material.dart';

abstract final class Colores {
  // Paleta principal (Eco-Sky).
  /// Verde oscuro (`darkGreen`): botones con texto, píldoras activas,
  /// fichas de fecha, pestaña activa. Con texto blanco cumple AAA (7.4:1).
  static const Color primario = Color(0xFF006414);

  /// Texto verde sobre fondos verdes claros (pasos completados, la marca).
  static const Color primarioOscuro = Color(0xFF004B0F);

  /// Verde medio (`midGreen`): logo, íconos activos, progreso, estados
  /// confirmados. Con texto blanco da 3.8:1: no lleva texto normal encima.
  static const Color primarioVivo = Color(0xFF009929);

  /// Verde claro (`lightGreen`): fondo de tarjetas portada, insignias
  /// circulares y ondas. Lleva texto oscuro (`tinta`).
  static const Color primarioClaro = Color(0xFF5CCB5F);

  /// Fondo de lo elegido o resaltado, mis burbujas del chat, íconos en
  /// recuadro, avatares (verde claro muy aclarado).
  static const Color primarioSuave = Color(0xFFE3F6E4);

  /// Azul medio (`midBlue`): contenedores de selección, bordes destacados,
  /// pestañas inactivas, el indicador de las hojas inferiores.
  static const Color cielo = Color(0xFF27A3DF);

  /// Azul claro (`lightBlue`): tarjetas de contexto (cabeceras de detalle y
  /// perfil, portada del técnico) y ondas. Lleva texto oscuro (`tinta`).
  static const Color cieloClaro = Color(0xFF41B6EF);

  /// Celeste muy aclarado: fondos de información e íconos en recuadro.
  static const Color cieloSuave = Color(0xFFE3F3FC);

  /// Tonos medios del degradado de la portada del técnico
  /// (`cieloSuave` → `cieloNube` → `cieloBruma`). Llevan texto oscuro.
  static const Color cieloNube = Color(0xFFBFE4F8);
  static const Color cieloBruma = Color(0xFF9FD6F3);

  /// Celeste oscuro, legible como texto sobre blanco y sobre `cieloSuave`.
  static const Color cieloOscuro = Color(0xFF0B4F73);

  // Superficies.
  /// Fondo del `Scaffold` (`appBackground`): verde bosque muy profundo.
  static const Color fondo = Color(0xFF0B2518);

  /// Fondo claro de las pantallas web del cliente (inicio con menú lateral).
  static const Color fondoClaro = Color(0xFFF4F9F4);

  /// Divisor de la barra inferior del pie de página.
  static const Color divisor = Color(0xFFEEF3EE);

  /// Borde inferior de la barra superior blanca.
  static const Color bordeBarra = Color(0xFFE3ECE4);

  /// Superficie clara (`surfaceLight`): la gran hoja de cada pantalla, la
  /// barra inferior, hojas inferiores y sub-tarjetas sobre el fondo oscuro.
  static const Color lienzo = Color(0xFFF4F9F6);

  /// Tarjetas dentro de la hoja clara, diálogos y burbujas: blanco.
  static const Color tarjeta = Color(0xFFFFFFFF);

  /// Campos de texto, opciones sin elegir y filas de datos.
  static const Color superficie = Color(0xFFE8F1EC);
  static const Color superficieFuerte = Color(0xFFD5E3DA);

  /// Borde fino de las tarjetas blancas sobre la hoja clara (sin sombras,
  /// el borde marca el límite).
  static const Color linea = Color(0xFFDCE8E0);

  /// Fila de datos (precio, ticket, fecha): el mismo tono de los campos.
  static const Color neutro = superficie;

  /// Fondo de la conversación del chat: celeste casi blanco, para que las
  /// burbujas blancas y verdes se distingan del resto de la app.
  static const Color fondoChat = Color(0xFFEEF7FC);

  // Texto.
  /// Texto principal sobre superficies claras (`textOnLight`).
  static const Color tinta = Color(0xFF062B14);

  /// Textos secundarios y placeholders (`textMuted`).
  static const Color tintaSuave = Color(0xFF2D523B);

  /// Texto secundario de la navegación ("‹ Volver").
  static const Color tintaGris = Color(0xFF4F6654);

  /// Títulos de las barras claras.
  static const Color tintaTitulo = Color(0xFF0E2A14);

  /// Texto e íconos sobre el fondo oscuro y sobre `primario` (`textOnDark`).
  static const Color sobreOscuro = Color(0xFFFFFFFF);

  // Acento positivo (completado, aprobado, verificado): el verde medio.
  static const Color acento = primarioVivo;
  static const Color acentoSuave = Color(0xFFDDF5DE);
  static const Color acentoOscuro = primario;

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

// Todo muy redondeado (estilo bento): ninguna caja baja de 12.
abstract final class Radios {
  /// Detalles chicos: miniaturas, marcas del calendario.
  static const double pequeno = 12;

  /// Cajas internas y fichas de fecha, hora y filtros (`FichaDato`).
  static const double medio = 16;

  /// Sub-tarjetas (dentro de la hoja clara o de una tarjeta con onda),
  /// filas de datos y avisos.
  static const double grande = 22;
  static const double subtarjeta = grande;

  /// Tarjetas del inicio del cliente (chats, visita, técnicos, publicidad).
  static const double tarjeta = 18;

  /// Tarjetas grandes y diálogos.
  static const double muyGrande = 30;

  /// Tarjetas bento: la hoja clara de cada pantalla y las tarjetas con onda.
  static const double bento = 30;

  /// Barra inferior y hojas inferiores (esquinas de arriba).
  static const double hoja = 32;
  static const double pildora = 999;
}

/// Sombras. Solo las tarjetas blancas del inicio del cliente llevan sombra;
/// el resto de la app se apoya en el borde fino.
abstract final class Sombras {
  static const List<BoxShadow> tarjeta = [
    BoxShadow(color: Color(0x140E2A14), blurRadius: 18, offset: Offset(0, 6)),
  ];
}

abstract final class Espacios {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;

  /// Separación vertical entre tarjetas bento.
  static const double bento = 18;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Duraciones y curvas de las animaciones.
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
  /// Una sola familia, geométrica y redondeada. Va incluida en la app
  /// (`assets/fonts/plus_jakarta_sans`, pesos 400 a 800, ver `pubspec.yaml`).
  static const String familia = 'Plus Jakarta Sans';
}
