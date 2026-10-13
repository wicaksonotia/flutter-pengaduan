import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ==========================================
  // BRAND COLORS
  // ==========================================

  static const Color navy = Color(0xFF142B4A);
  static const Color navyLight = Color(0xFF1C3D65);
  static const Color blue = Color(0xFF2878F0);
  static const Color blueDark = Color(0xFF285A91);
  static const Color blueLight = Color(0xFFBFD9F5);

  // Gradient utama
  static const List<Color> primaryGradient = [navy, blueDark];

  // ==========================================
  // BACKGROUND & SURFACE
  // ==========================================

  static const Color background = Color(0xFFF4F7FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF4F7FC);
  static const Color surfaceMuted = Color(0xFFE8EDF5);
  static const Color border = Color(0xFFE8EDF5);

  // ==========================================
  // TEXT COLORS
  // ==========================================

  static const Color textPrimary = Color(0xFF142B4A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textBody = Color(0xFF334155);
  static const Color textMuted = Color(0xFF7B8798);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ==========================================
  // STATUS COLORS
  // ==========================================

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFE5484D);
  static const Color info = Color(0xFF2878F0);

  // ==========================================
  // ICON & DECORATION
  // ==========================================

  static const Color iconPrimary = navy;
  static const Color iconSecondary = Color(0xFF8291A5);
  static const Color iconMuted = Color(0xFF94A3B8);

  static const Color divider = Color(0xFFE2E8F0);
  static const Color shadow = Color(0x14142B4A);

  // ==========================================
  // MAP COLORS
  // ==========================================

  static const Color mapMarker = Color(0xFFE5484D);

  // ==========================================
  // GRAYSCALE
  // ==========================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color teal = Color(0xFF18B6A4);
}
