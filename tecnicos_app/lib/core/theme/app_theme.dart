// Tema visual único de la app.
import 'package:flutter/material.dart';


abstract final class AppTheme {
  static const Color _semilla = Color(0xFF1E5AA8);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _semilla),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      );
}
