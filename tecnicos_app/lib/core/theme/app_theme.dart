// Tema visual único de la app, construido a partir de los tokens.
//
// DISEÑO PROVISIONAL: ver `docs/DISENO.md`. Estilo: títulos grandes en
// negrita, botones negros, tarjetas grises planas y un solo color de acento.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

abstract final class AppTheme {
  static const ColorScheme _colores = ColorScheme(
    brightness: Brightness.light,
    primary: Colores.tinta,
    onPrimary: Colors.white,
    primaryContainer: Colores.acentoSuave,
    onPrimaryContainer: Colores.acentoOscuro,
    secondary: Colores.acento,
    onSecondary: Colors.white,
    secondaryContainer: Colores.acentoSuave,
    onSecondaryContainer: Colores.acentoOscuro,
    tertiary: Colores.info,
    onTertiary: Colors.white,
    error: Colores.error,
    onError: Colors.white,
    errorContainer: Colores.errorSuave,
    onErrorContainer: Color(0xFF8C1D18),
    surface: Colores.fondo,
    onSurface: Colores.tinta,
    onSurfaceVariant: Colores.tintaSuave,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8F8F8),
    surfaceContainer: Colores.superficie,
    surfaceContainerHigh: Color(0xFFEEEEEE),
    surfaceContainerHighest: Colores.superficieFuerte,
    outline: Color(0xFFBDBDBD),
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
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          shape: _formaMedia,
          textStyle: textos.labelLarge?.copyWith(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colores.tinta,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: Colores.linea),
          shape: _formaMedia,
          textStyle: textos.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colores.tinta,
          textStyle: textos.labelLarge,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Colores.tinta,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: Colores.linea),
          textStyle: textos.labelLarge,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colores.tinta,
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colores.superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Espacios.l,
          vertical: 14,
        ),
        border: _bordeCampo(BorderSide.none),
        enabledBorder: _bordeCampo(BorderSide.none),
        focusedBorder:
            _bordeCampo(const BorderSide(color: Colores.tinta, width: 1.5)),
        errorBorder: _bordeCampo(const BorderSide(color: Colores.error)),
        focusedErrorBorder:
            _bordeCampo(const BorderSide(color: Colores.error, width: 1.5)),
        labelStyle: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
        hintStyle: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
      ),
      cardTheme: CardThemeData(
        color: Colores.superficie,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.grande),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colores.superficie,
        selectedColor: Colores.acentoSuave,
        checkmarkColor: Colores.acentoOscuro,
        labelStyle: textos.labelLarge?.copyWith(color: Colores.tinta),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: Espacios.s),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colores.fondo,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? Colores.tinta
                : Colores.tintaSuave,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => textos.labelMedium?.copyWith(
            color: estados.contains(WidgetState.selected)
                ? Colores.tinta
                : Colores.tintaSuave,
            fontWeight: estados.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colores.fondo,
        indicatorColor: Colores.superficie,
        selectedIconTheme: const IconThemeData(color: Colores.tinta),
        unselectedIconTheme: const IconThemeData(color: Colores.tintaSuave),
        selectedLabelTextStyle:
            textos.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelTextStyle:
            textos.labelMedium?.copyWith(color: Colores.tintaSuave),
      ),
      dividerTheme: const DividerThemeData(color: Colores.linea, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colores.tinta,
        contentTextStyle: textos.bodyMedium?.copyWith(color: Colors.white),
        shape: _formaMedia,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colores.fondo,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.grande),
        ),
        titleTextStyle: textos.titleLarge,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colores.fondo,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Radios.grande)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colores.tinta,
        linearTrackColor: Colores.superficie,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Colores.tinta,
        inactiveTrackColor: Colores.superficieFuerte,
        thumbColor: Colores.tinta,
      ),
    );
  }

  /// Tipografía provisional: títulos grandes, en negrita y algo apretados.
  static TextTheme _textos(TextTheme base) {
    final conFuente = GoogleFonts.getTextTheme(Tipografia.familia, base)
        .apply(bodyColor: Colores.tinta, displayColor: Colores.tinta);

    TextStyle? titular(TextStyle? estilo, FontWeight peso) =>
        estilo?.copyWith(fontWeight: peso, letterSpacing: -0.5, height: 1.15);

    return conFuente.copyWith(
      displaySmall: titular(conFuente.displaySmall, FontWeight.w800),
      headlineLarge: titular(conFuente.headlineLarge, FontWeight.w800),
      headlineMedium: titular(conFuente.headlineMedium, FontWeight.w800),
      headlineSmall: titular(conFuente.headlineSmall, FontWeight.w800),
      titleLarge: titular(conFuente.titleLarge, FontWeight.w700),
      titleMedium:
          conFuente.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
