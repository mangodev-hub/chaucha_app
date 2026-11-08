// Tema visual único de la app, construido a partir de los tokens.
//
// Estilo (ver `docs/DISENO.md`): blanco y azul, fondo celeste suave, tarjetas
// blancas con sombra sutil, botón principal azul con sombra, campos celestes
// sin borde y con ícono. El verde queda solo para lo positivo.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

abstract final class AppTheme {
  static const ColorScheme _colores = ColorScheme(
    brightness: Brightness.light,
    primary: Colores.primario,
    onPrimary: Colors.white,
    primaryContainer: Colores.primarioSuave,
    onPrimaryContainer: Colores.primarioOscuro,
    secondary: Colores.acento,
    onSecondary: Colors.white,
    secondaryContainer: Colores.acentoSuave,
    onSecondaryContainer: Colores.acentoOscuro,
    tertiary: Colores.info,
    onTertiary: Colors.white,
    error: Colores.error,
    onError: Colors.white,
    errorContainer: Colores.errorSuave,
    onErrorContainer: Colores.errorOscuro,
    surface: Colores.tarjeta,
    onSurface: Colores.tinta,
    onSurfaceVariant: Colores.tintaSuave,
    surfaceContainerLowest: Colores.tarjeta,
    surfaceContainerLow: Colores.fondo,
    surfaceContainer: Colores.superficie,
    surfaceContainerHigh: Colores.superficie,
    surfaceContainerHighest: Colores.superficieFuerte,
    outline: Color(0xFFA9B6C8),
    outlineVariant: Colores.linea,
  );

  static final RoundedRectangleBorder _formaMedia = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Radios.medio),
  );

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, colorScheme: _colores);
    final textos = _textos(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: Colores.fondo,
      textTheme: textos,
      appBarTheme: AppBarTheme(
        backgroundColor: Colores.fondo,
        foregroundColor: Colores.tinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textos.titleLarge,
      ),
      // Botón principal: azul, alto y con una sombra azulada ("destacado").
      // Desactivado, sin sombra.
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              minimumSize: const Size(0, 52),
              shape: _formaMedia,
              textStyle: textos.labelLarge?.copyWith(fontSize: 16),
            ).copyWith(
              elevation: WidgetStateProperty.resolveWith(
                (estados) => estados.contains(WidgetState.disabled) ? 0 : 3,
              ),
              shadowColor: const WidgetStatePropertyAll(Sombras.boton),
            ),
      ),
      // Botón secundario: borde y texto azules.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colores.primario,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: Colores.primario),
          shape: _formaMedia,
          textStyle: textos.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colores.primario,
          textStyle: textos.labelLarge,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Colores.primario,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: Colores.linea),
          textStyle: textos.labelLarge,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colores.primario,
        foregroundColor: Colors.white,
        shape: StadiumBorder(),
      ),
      // Campos celestes, sin borde; borde azul al enfocarlos.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colores.superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Espacios.l,
          vertical: Espacios.l,
        ),
        border: _bordeCampo(BorderSide.none),
        enabledBorder: _bordeCampo(BorderSide.none),
        focusedBorder: _bordeCampo(
          const BorderSide(color: Colores.primario, width: 1.5),
        ),
        errorBorder: _bordeCampo(const BorderSide(color: Colores.error)),
        focusedErrorBorder: _bordeCampo(
          const BorderSide(color: Colores.error, width: 1.5),
        ),
        labelStyle: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
        hintStyle: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
        prefixIconColor: Colores.tintaSuave,
        suffixIconColor: Colores.tintaSuave,
      ),
      cardTheme: CardThemeData(
        color: Colores.tarjeta,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.grande),
        ),
      ),
      // Chips: celestes; el elegido con borde azul.
      chipTheme: ChipThemeData(
        backgroundColor: Colores.superficie,
        selectedColor: Colores.primarioSuave,
        checkmarkColor: Colores.primarioOscuro,
        labelStyle: textos.labelLarge?.copyWith(color: Colores.tinta),
        secondaryLabelStyle: textos.labelLarge?.copyWith(
          color: Colores.primarioOscuro,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (estados) => estados.contains(WidgetState.selected)
              ? const BorderSide(color: Colores.primario)
              : const BorderSide(color: Colors.transparent),
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.s,
          vertical: Espacios.xs,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colores.tarjeta,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colores.primarioSuave,
        elevation: 0,
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? Colores.primario
                : Colores.tintaSuave,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => textos.labelMedium?.copyWith(
            color: estados.contains(WidgetState.selected)
                ? Colores.primario
                : Colores.tintaSuave,
            fontWeight: estados.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colores.tarjeta,
        indicatorColor: Colores.primarioSuave,
        selectedIconTheme: const IconThemeData(color: Colores.primario),
        unselectedIconTheme: const IconThemeData(color: Colores.tintaSuave),
        selectedLabelTextStyle: textos.labelMedium?.copyWith(
          color: Colores.primario,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textos.labelMedium?.copyWith(
          color: Colores.tintaSuave,
        ),
      ),
      dividerTheme: const DividerThemeData(color: Colores.linea, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colores.tinta,
        contentTextStyle: textos.bodyMedium?.copyWith(color: Colors.white),
        shape: _formaMedia,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colores.tarjeta,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.muyGrande),
        ),
        titleTextStyle: textos.titleLarge,
        iconColor: Colores.primario,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colores.tarjeta,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: Colores.superficieFuerte,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radios.muyGrande),
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colores.primario,
        linearTrackColor: Colores.superficieFuerte,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Colores.primario,
        inactiveTrackColor: Colores.superficieFuerte,
        thumbColor: Colores.primario,
      ),
    );
  }

  /// Tipografía: títulos en negrita y algo apretados.
  static TextTheme _textos(TextTheme base) {
    final conFuente = GoogleFonts.getTextTheme(
      Tipografia.familia,
      base,
    ).apply(bodyColor: Colores.tinta, displayColor: Colores.tinta);

    TextStyle? titular(TextStyle? estilo, FontWeight peso) =>
        estilo?.copyWith(fontWeight: peso, letterSpacing: -0.5, height: 1.15);

    return conFuente.copyWith(
      displaySmall: titular(conFuente.displaySmall, FontWeight.w800),
      headlineLarge: titular(conFuente.headlineLarge, FontWeight.w800),
      headlineMedium: titular(conFuente.headlineMedium, FontWeight.w800),
      headlineSmall: titular(conFuente.headlineSmall, FontWeight.w800),
      titleLarge: titular(conFuente.titleLarge, FontWeight.w700),
      titleMedium: conFuente.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: conFuente.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      labelLarge: conFuente.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: conFuente.bodyLarge?.copyWith(height: 1.45),
      bodyMedium: conFuente.bodyMedium?.copyWith(height: 1.45),
    );
  }

  static OutlineInputBorder _bordeCampo(BorderSide lado) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(Radios.medio),
    borderSide: lado,
  );
}
