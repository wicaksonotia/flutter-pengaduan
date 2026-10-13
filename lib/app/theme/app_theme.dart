import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color navy = Color(0xFF142B4A);
  static const Color blue = Color(0xFF2878F0);
  static const Color teal = Color(0xFF18B6A4);
  static const Color background = Color(0xFFF4F7FC);
  static const Color textPrimary = Color(0xFF172B4D);
  static const Color textSecondary = Color(0xFF77849A);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        primary: blue,
        secondary: teal,
        surface: Colors.white,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
