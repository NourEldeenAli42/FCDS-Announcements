import 'package:flutter/material.dart';
import 'theme_cubit.dart';

class AppTheme {
  static Color getSeedColor(AppThemeType type) {
    switch (type) {
      case AppThemeType.mint:
        return const Color(0xFF367D65);
      case AppThemeType.ocean:
        return const Color(0xFF1565C0);
      case AppThemeType.sunset:
        return const Color(0xFFD84315);
      case AppThemeType.lavender:
        return const Color(0xFF673AB7);
    }
  }

  static ThemeData getTheme(AppThemeType type, Brightness brightness) {
    final seedColor = getSeedColor(type);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark 
            ? colorScheme.surfaceContainer 
            : colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: brightness == Brightness.dark 
            ? colorScheme.surfaceContainerHigh 
            : colorScheme.surfaceContainerHighest,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      inputDecorationTheme: const InputDecorationTheme(),
    );
  }

  // Fallbacks for compatibility
  static ThemeData get lightTheme => getTheme(AppThemeType.mint, Brightness.light);
  static ThemeData get darkTheme => getTheme(AppThemeType.mint, Brightness.dark);
}
