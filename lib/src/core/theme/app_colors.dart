import 'package:flutter/material.dart';

/// TailorHouse color palette
/// A sophisticated, warm palette inspired by tailoring and craftsmanship
abstract class AppColors {
  AppColors._();

  // ============================================================================
  // Brand Colors
  // ============================================================================

  /// Primary brand color - Deep burgundy/wine
  static const Color primary = Color(0xFF8B2635);
  static const Color primaryLight = Color(0xFFB54A5A);
  static const Color primaryDark = Color(0xFF5E1A24);

  /// Secondary color - Warm gold/champagne
  static const Color secondary = Color(0xFFD4A373);
  static const Color secondaryLight = Color(0xFFE8C9A4);
  static const Color secondaryDark = Color(0xFFA67B4E);

  /// Accent color - Deep teal for contrast
  static const Color accent = Color(0xFF2D6A6A);
  static const Color accentLight = Color(0xFF4A9898);
  static const Color accentDark = Color(0xFF1A4040);

  // ============================================================================
  // Neutral Colors
  // ============================================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  /// Off-white with warm undertone
  static const Color background = Color(0xFFFAF8F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  /// Surface colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF252525);

  /// Card colors
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2D2D2D);

  // ============================================================================
  // Text Colors
  // ============================================================================

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);

  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color textDisabledDark = Color(0xFF4D4D4D);

  // ============================================================================
  // Semantic Colors
  // ============================================================================

  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successDark = Color(0xFF1B5E20);

  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFF8E0000);

  static const Color warning = Color(0xFFF9A825);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color warningDark = Color(0xFFC17900);

  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color infoDark = Color(0xFF0D47A1);

  // ============================================================================
  // Border Colors
  // ============================================================================

  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFF424242);

  // ============================================================================
  // Status Colors
  // ============================================================================

  static const Color statusPending = Color(0xFFFFA726);
  static const Color statusProcessing = Color(0xFF42A5F5);
  static const Color statusReady = Color(0xFF66BB6A);
  static const Color statusDelivered = Color(0xFF26A69A);
  static const Color statusCancelled = Color(0xFFEF5350);

  // ============================================================================
  // Gradient Definitions
  // ============================================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAF8F5), Color(0xFFF5EFE6)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B2635), Color(0xFFD4A373)],
  );

  // ============================================================================
  // Shadow Colors
  // ============================================================================

  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // ============================================================================
  // Overlay Colors
  // ============================================================================

  static const Color overlayLight = Color(0x80FFFFFF);
  static const Color overlayDark = Color(0x80000000);
  static const Color scrim = Color(0x52000000);
}

