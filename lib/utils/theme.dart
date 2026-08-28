import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors - Green Cyber Theme
  static const Color primaryGreen = Color(0xFF00E676);
  static const Color primaryGreenDark = Color(0xFF00C853);
  static const Color primaryGreenLight = Color(0xFF69F0AE);
  static const Color accentGreen = Color(0xFF1DE9B6);

  // Background Colors
  static const Color background = Color(0xFF0D1B1E);
  static const Color surface = Color(0xFF152A2E);
  static const Color surfaceLight = Color(0xFF1E3A3F);
  static const Color surfaceDark = Color(0xFF0A1315);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB2DFDB);
  static const Color textMuted = Color(0xFF80CBC4);

  // Status Colors
  static const Color connected = Color(0xFF00E676);
  static const Color connecting = Color(0xFFFFD600);
  static const Color disconnected = Color(0xFFFF5252);
  static const Color error = Color(0xFFFF1744);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, accentGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [surface, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF1DE9B6), Color(0xFF00BFA5)],
    stops: [0.0, 0.5, 1.0],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: accentGreen,
        surface: surface,
        background: background,
        error: error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: surface,
        shadowColor: primaryGreen.withOpacity(0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.black,
          elevation: 8,
          shadowColor: primaryGreen.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
      dividerTheme: DividerThemeData(
        color: primaryGreen.withOpacity(0.1),
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
