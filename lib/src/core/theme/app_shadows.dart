import 'package:flutter/material.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';

/// TailorHouse shadow system
/// Consistent elevation and depth throughout the app
abstract class AppShadows {
  AppShadows._();

  // ============================================================================
  // Elevation shadows (Material-style)
  // ============================================================================

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> xs = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];

  // ============================================================================
  // Colored shadows
  // ============================================================================

  static List<BoxShadow> primary = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> secondary = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.3),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> success = [
    BoxShadow(
      color: AppColors.success.withValues(alpha: 0.3),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> error = [
    BoxShadow(
      color: AppColors.error.withValues(alpha: 0.3),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // Special shadows
  // ============================================================================

  /// Soft floating shadow for cards
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 0,
    ),
  ];

  /// Bottom sheet shadow
  static const List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// FAB shadow
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Inner shadow for inputs
  static const List<BoxShadow> innerSm = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
}

