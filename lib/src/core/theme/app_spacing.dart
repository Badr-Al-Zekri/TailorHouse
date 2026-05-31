import 'package:flutter/material.dart';

/// TailorHouse spacing system
/// Consistent spacing values throughout the app
abstract class AppSpacing {
  AppSpacing._();

  // ============================================================================
  // Base spacing values (4px grid)
  // ============================================================================

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // ============================================================================
  // Semantic spacing
  // ============================================================================

  /// Padding inside containers, cards
  static const double paddingXs = 8;
  static const double paddingSm = 12;
  static const double paddingMd = 16;
  static const double paddingLg = 20;
  static const double paddingXl = 24;

  /// Gap between items
  static const double gapXs = 4;
  static const double gapSm = 8;
  static const double gapMd = 12;
  static const double gapLg = 16;
  static const double gapXl = 24;

  /// Screen horizontal padding
  static const double screenPaddingHorizontal = 20;
  static const double screenPaddingVertical = 16;

  /// Section spacing (between major sections)
  static const double sectionSpacing = 32;
  static const double sectionSpacingLarge = 48;

  // ============================================================================
  // Border Radius
  // ============================================================================

  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusRound = 100;

  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusRound = BorderRadius.all(Radius.circular(radiusRound));

  // ============================================================================
  // Component sizes
  // ============================================================================

  /// Button heights
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;

  /// Input field height
  static const double inputHeight = 56;
  static const double inputHeightSm = 44;

  /// Icon sizes
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  /// Avatar sizes
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;

  /// App bar height
  static const double appBarHeight = 56;
  static const double appBarHeightLarge = 72;

  /// Bottom navigation height
  static const double bottomNavHeight = 64;

  /// Card min height
  static const double cardMinHeight = 80;

  // ============================================================================
  // Edge Insets shortcuts
  // ============================================================================

  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenPaddingHorizontal,
    vertical: screenPaddingVertical,
  );

  static const EdgeInsets screenPaddingHorizontalOnly = EdgeInsets.symmetric(
    horizontal: screenPaddingHorizontal,
  );
}

