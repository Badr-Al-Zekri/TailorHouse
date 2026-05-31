import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// TailorHouse theme configuration
class AppTheme {
  AppTheme._();

  // ============================================================================
  // Light Theme
  // ============================================================================

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accent,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.accentLight,
        onTertiaryContainer: AppColors.accentDark,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.errorDark,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.borderLight,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        titleTextStyle: AppTypography.titleLarge,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconMd,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.2),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return AppTypography.labelSmall;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            );
          }
          return const IconThemeData(
            color: AppColors.textTertiary,
            size: AppSpacing.iconMd,
          );
        }),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          side: const BorderSide(color: AppColors.borderLight),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textDisabled,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingLg,
            vertical: AppSpacing.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingLg,
            vertical: AppSpacing.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          side: const BorderSide(color: AppColors.primary),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMd,
            vertical: AppSpacing.paddingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.error,
        ),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        highlightElevation: 8,
        shape: CircleBorder(),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
        disabledColor: AppColors.borderLight,
        labelStyle: AppTypography.labelMedium,
        secondaryLabelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingSm,
          vertical: AppSpacing.paddingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusRound,
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        elevation: 8,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.titleLarge,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        modalElevation: 16,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXl),
            topRight: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.border,
        dragHandleSize: Size(40, 4),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppSpacing.iconMd,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.borderLight,
        circularTrackColor: AppColors.borderLight,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight.withValues(alpha: 0.4);
          }
          return AppColors.borderLight;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // Expansion Tile Theme
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: AppColors.surface,
        collapsedBackgroundColor: AppColors.surface,
        iconColor: AppColors.textSecondary,
        collapsedIconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        collapsedTextColor: AppColors.textPrimary,
        tilePadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingXs,
        ),
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingXs,
        ),
        minLeadingWidth: 24,
        horizontalTitleGap: AppSpacing.gapMd,
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
      ),
    );
  }

  // ============================================================================
  // Dark Theme
  // ============================================================================

  static ThemeData get dark {
    return light.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primary,
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.black,
        secondaryContainer: AppColors.secondary,
        onSecondaryContainer: AppColors.white,
        tertiary: AppColors.accentLight,
        onTertiary: AppColors.black,
        tertiaryContainer: AppColors.accent,
        onTertiaryContainer: AppColors.white,
        error: AppColors.errorLight,
        onError: AppColors.errorDark,
        errorContainer: AppColors.error,
        onErrorContainer: AppColors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.backgroundDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.borderDark,
        outlineVariant: Color(0xFF3D3D3D),
      ),
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryDark,
          size: AppSpacing.iconMd,
        ),
      ),
      cardTheme: light.cardTheme.copyWith(
        color: AppColors.cardDark,
      ),
      bottomNavigationBarTheme: light.bottomNavigationBarTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textTertiaryDark,
      ),
      inputDecorationTheme: light.inputDecorationTheme.copyWith(
        fillColor: AppColors.surfaceDark,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiaryDark,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      dialogTheme: light.dialogTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
      ),
      bottomSheetTheme: light.bottomSheetTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
        dragHandleColor: AppColors.borderDark,
      ),
      snackBarTheme: light.snackBarTheme.copyWith(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      dividerTheme: light.dividerTheme.copyWith(
        color: AppColors.borderDark,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryDark),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark),
        titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark),
        titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimaryDark),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.textPrimaryDark),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: AppSpacing.iconMd,
      ),
    );
  }
}

