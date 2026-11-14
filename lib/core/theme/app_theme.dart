import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class AppTheme {
  static const ColorScheme _colores = ColorScheme(
    brightness: Brightness.light,
    primary: Colores.primario,
    onPrimary: Colores.sobreOscuro,
    primaryContainer: Colores.primarioSuave,
    onPrimaryContainer: Colores.primarioOscuro,
    // Secundario: celeste.
    secondary: Colores.cielo,
    onSecondary: Colores.tinta,
    secondaryContainer: Colores.cieloSuave,
    onSecondaryContainer: Colores.cieloOscuro,
    tertiary: Colores.info,
    onTertiary: Colores.sobreOscuro,
    error: Colores.error,
    onError: Colores.sobreOscuro,
    errorContainer: Colores.errorSuave,
    onErrorContainer: Colores.errorOscuro,
    surface: Colores.tarjeta,
    onSurface: Colores.tinta,
    onSurfaceVariant: Colores.tintaSuave,
    surfaceContainerLowest: Colores.tarjeta,
    surfaceContainerLow: Colores.lienzo,
    surfaceContainer: Colores.superficie,
    surfaceContainerHigh: Colores.superficie,
    surfaceContainerHighest: Colores.superficieFuerte,
    outline: Color(0xFF9DB5A5),
    outlineVariant: Colores.linea,
  );

  static const StadiumBorder _pildora = StadiumBorder();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: _colores,
      fontFamily: Tipografia.familia,
    );
    final textos = _textos(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: Colores.fondo,
      textTheme: textos,
      // Barra superior sobre el fondo oscuro: título e íconos blancos.
      appBarTheme: AppBarTheme(
        backgroundColor: Colores.fondo,
        foregroundColor: Colores.sobreOscuro,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textos.titleLarge?.copyWith(color: Colores.sobreOscuro),
        iconTheme: const IconThemeData(color: Colores.sobreOscuro),
        actionsIconTheme: const IconThemeData(color: Colores.sobreOscuro),
      ),
      // Botón principal: píldora verde oscuro con texto blanco en negrita.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          shape: _pildora,
          elevation: 0,
          textStyle: textos.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colores.tinta,
          backgroundColor: Colores.tarjeta,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: Colores.superficieFuerte, width: 1.5),
          shape: _pildora,
          textStyle: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(elevation: 0, shape: _pildora),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colores.primario,
          shape: _pildora,
          textStyle: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Colores.primario,
          selectedForegroundColor: Colores.sobreOscuro,
          side: const BorderSide(color: Colores.linea),
          textStyle: textos.labelLarge,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colores.primario,
        foregroundColor: Colores.sobreOscuro,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colores.superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Espacios.l + 4,
          vertical: Espacios.l,
        ),
        border: _bordeCampo(BorderSide.none),
        enabledBorder: _bordeCampo(BorderSide.none),
        focusedBorder: _bordeCampo(
          const BorderSide(color: Colores.primarioVivo, width: 1.5),
        ),
        errorBorder: _bordeCampo(const BorderSide(color: Colores.error)),
        focusedErrorBorder: _bordeCampo(
          const BorderSide(color: Colores.error, width: 1.5),
        ),
        labelStyle: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
        hintStyle: textos.bodyLarge?.copyWith(color: Colores.tintaSuave),
        prefixIconColor: Colores.tintaSuave,
        suffixIconColor: Colores.primario,
      ),
      cardTheme: CardThemeData(
        color: Colores.tarjeta,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.subtarjeta),
          side: const BorderSide(color: Colores.linea),
        ),
      ),
      // Chips: píldoras verdosas; la elegida en verde suave con borde verde.
      chipTheme: ChipThemeData(
        backgroundColor: Colores.superficie,
        selectedColor: Colores.primarioSuave,
        checkmarkColor: Colores.primarioOscuro,
        elevation: 0,
        pressElevation: 0,
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
        backgroundColor: Colores.lienzo,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colores.primarioSuave,
        elevation: 0,
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            color: estados.contains(WidgetState.selected)
                ? Colores.primario
                : Colores.cielo.withValues(alpha: 0.7),
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
      dividerTheme: const DividerThemeData(color: Colores.linea, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colores.tinta,
        elevation: 0,
        contentTextStyle: textos.bodyMedium?.copyWith(
          color: Colores.sobreOscuro,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.grande),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colores.lienzo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.bento),
        ),
        titleTextStyle: textos.titleLarge,
        iconColor: Colores.primario,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colores.lienzo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: Colores.cielo,
        dragHandleSize: Size(40, 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radios.hoja),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colores.lienzo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.subtarjeta),
          side: const BorderSide(color: Colores.linea),
        ),
      ),
      // Verde medio: se ve tanto sobre el fondo oscuro como sobre las hojas.
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colores.primarioVivo,
        linearTrackColor: Colores.superficieFuerte,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Colores.primario,
        inactiveTrackColor: Colores.superficieFuerte,
        thumbColor: Colores.primario,
      ),
    );
  }

  /// Tipografía: títulos en negrita, cuerpo en peso medio.
  static TextTheme _textos(TextTheme base) {
    final conFuente = base.apply(
      fontFamily: Tipografia.familia,
      bodyColor: Colores.tinta,
      displayColor: Colores.tinta,
    );

    TextStyle? titular(TextStyle? estilo, FontWeight peso) =>
        estilo?.copyWith(fontWeight: peso, height: 1.15);

    final sinEspaciado = conFuente.copyWith(
      displayLarge: conFuente.displayLarge?.copyWith(letterSpacing: 0),
      displayMedium: conFuente.displayMedium?.copyWith(letterSpacing: 0),
      displaySmall: conFuente.displaySmall?.copyWith(letterSpacing: 0),
      headlineLarge: conFuente.headlineLarge?.copyWith(letterSpacing: 0),
      headlineMedium: conFuente.headlineMedium?.copyWith(letterSpacing: 0),
      headlineSmall: conFuente.headlineSmall?.copyWith(letterSpacing: 0),
      titleLarge: conFuente.titleLarge?.copyWith(letterSpacing: 0),
      titleMedium: conFuente.titleMedium?.copyWith(letterSpacing: 0),
      titleSmall: conFuente.titleSmall?.copyWith(letterSpacing: 0),
      bodyLarge: conFuente.bodyLarge?.copyWith(letterSpacing: 0),
      bodyMedium: conFuente.bodyMedium?.copyWith(letterSpacing: 0),
      bodySmall: conFuente.bodySmall?.copyWith(letterSpacing: 0),
      labelLarge: conFuente.labelLarge?.copyWith(letterSpacing: 0),
      labelMedium: conFuente.labelMedium?.copyWith(letterSpacing: 0),
      labelSmall: conFuente.labelSmall?.copyWith(letterSpacing: 0),
    );

    return sinEspaciado.copyWith(
      displaySmall: titular(sinEspaciado.displaySmall, FontWeight.w800),
      headlineLarge: titular(sinEspaciado.headlineLarge, FontWeight.w800),
      headlineMedium: titular(sinEspaciado.headlineMedium, FontWeight.w800),
      headlineSmall: titular(sinEspaciado.headlineSmall, FontWeight.w800),
      // Títulos de tarjeta: 20-22 en negrita.
      titleLarge: titular(
        sinEspaciado.titleLarge?.copyWith(fontSize: 21),
        FontWeight.w700,
      ),
      titleMedium: sinEspaciado.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleSmall: sinEspaciado.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      labelLarge: sinEspaciado.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: sinEspaciado.bodyLarge?.copyWith(
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: sinEspaciado.bodyMedium?.copyWith(
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: sinEspaciado.bodySmall?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  static OutlineInputBorder _bordeCampo(BorderSide lado) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(Radios.subtarjeta + 6),
    borderSide: lado,
  );
}
