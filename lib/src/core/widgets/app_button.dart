import 'package:flutter/material.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outlined, text, gradient }
enum AppButtonSize { small, medium, large }

/// Reusable button component with multiple variants
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  /// Primary variant constructor
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius,
  })  : variant = AppButtonVariant.primary,
        backgroundColor = null,
        foregroundColor = null;

  /// Secondary variant constructor
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius,
  })  : variant = AppButtonVariant.secondary,
        backgroundColor = null,
        foregroundColor = null;

  /// Outlined variant constructor
  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius,
  })  : variant = AppButtonVariant.outlined,
        backgroundColor = null,
        foregroundColor = null;

  /// Text variant constructor
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius,
  })  : variant = AppButtonVariant.text,
        backgroundColor = null,
        foregroundColor = null;

  /// Gradient variant constructor
  const AppButton.gradient({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius,
  })  : variant = AppButtonVariant.gradient,
        backgroundColor = null,
        foregroundColor = null;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppSpacing.borderRadiusMd;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(context, effectiveBorderRadius),
    );
  }

  Widget _buildButton(BuildContext context, BorderRadius radius) {
    final isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: foregroundColor ?? AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: _getPadding(),
          ),
          child: _buildChild(foregroundColor ?? AppColors.white),
        );

      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.secondary,
            foregroundColor: foregroundColor ?? AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: _getPadding(),
          ),
          child: _buildChild(foregroundColor ?? AppColors.white),
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.primary,
            side: BorderSide(
              color: isDisabled ? AppColors.border : (foregroundColor ?? AppColors.primary),
            ),
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: _getPadding(),
          ),
          child: _buildChild(foregroundColor ?? AppColors.primary),
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: radius),
            padding: _getPadding(),
          ),
          child: _buildChild(foregroundColor ?? AppColors.primary),
        );

      case AppButtonVariant.gradient:
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: isDisabled ? null : AppColors.primaryGradient,
            color: isDisabled ? AppColors.border : null,
            borderRadius: radius,
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: radius),
              padding: _getPadding(),
            ),
            child: _buildChild(AppColors.white),
          ),
        );
    }
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final textStyle = size == AppButtonSize.small
        ? AppTypography.buttonSmall
        : AppTypography.button;

    final iconSize = size == AppButtonSize.small ? 18.0 : 20.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: iconSize),
          const SizedBox(width: AppSpacing.gapSm),
        ],
        Text(text, style: textStyle.copyWith(color: color)),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.gapSm),
          Icon(trailingIcon, size: iconSize),
        ],
      ],
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case AppButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case AppButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingSm,
          vertical: AppSpacing.paddingXs,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMd,
          vertical: AppSpacing.paddingSm,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingLg,
          vertical: AppSpacing.paddingMd,
        );
    }
  }
}

