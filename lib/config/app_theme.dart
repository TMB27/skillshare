import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryTeal = Color(0xFF26A69A);
  static const Color primaryDark = Color(0xFF00695C);
  static const Color primaryLight = Color(0xFF80CBC4);

  // Secondary Colors
  static const Color secondaryBlue = Color(0xFF2196F3);
  static const Color secondaryPurple = Color(0xFF9C27B0);
  static const Color secondaryOrange = Color(0xFFFF9800);

  // Neutral Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerGray = Color(0xFFE0E0E0);

  // Status Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        brightness: Brightness.light,
      ),
      primaryColor: primaryTeal,
      scaffoldBackgroundColor: backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTeal,
          side: const BorderSide(color: primaryTeal),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryTeal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryTeal,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceGray,
        selectedColor: primaryTeal,
        labelStyle: const TextStyle(color: textPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        brightness: Brightness.dark,
      ),
      primaryColor: primaryTeal,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryTeal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 8,
      ),
    );
  }
}
