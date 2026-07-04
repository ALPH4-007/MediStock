import 'package:flutter/material.dart';

class AppTheme {
  // ---------------------------------------------------------------------
  // Colors
  // ---------------------------------------------------------------------
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color darkGreen = Color(0xFF1B5E20);

  static const Color background = Color(0xFFF5F7FA);
  static const Color card = Colors.white;

  static const Color black = Color(0xFF212121);
  static const Color grey = Color(0xFF757575);

  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color danger = Colors.red;

  // ---------------------------------------------------------------------
  // Shared shape values
  // ---------------------------------------------------------------------
  // Reused everywhere a rounded corner is needed, so the whole app's
  // "roundness" can be changed by editing one number.
  static const double radius = 12;

  static final BorderRadius borderRadius = BorderRadius.circular(radius);

  static final RoundedRectangleBorder roundedShape = RoundedRectangleBorder(
    borderRadius: borderRadius,
  );

  // ---------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      secondary: lightGreen,
      error: danger,
      surface: card,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: black,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: black,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: black),
      bodyMedium: TextStyle(fontSize: 14, color: grey),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: roundedShape,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
    ),

    cardTheme: CardThemeData(
      color: card,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: roundedShape,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius * 1.5),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkGreen,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: roundedShape,
    ),

    iconTheme: const IconThemeData(color: black, size: 24),
  );
}
