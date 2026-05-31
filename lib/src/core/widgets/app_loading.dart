import 'package:flutter/material.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// Full screen loading overlay
class AppLoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const AppLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.overlayDark,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusMd,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  indicatorColor ?? AppColors.primary,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.gapMd),
                Text(
                  message!,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline loading indicator
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
  });

  const AppLoadingIndicator.small({
    super.key,
    this.color,
  })  : size = 16,
        strokeWidth = 2;

  const AppLoadingIndicator.large({
    super.key,
    this.color,
  })  : size = 48,
        strokeWidth = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder
class AppShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.border.withValues(alpha: 0.3);
    final highlightColor = widget.highlightColor ?? AppColors.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// Shimmer placeholder shapes
class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  const ShimmerPlaceholder.text({
    super.key,
    this.width = double.infinity,
  })  : height = 16,
        borderRadius = const BorderRadius.all(Radius.circular(4));

  const ShimmerPlaceholder.title({
    super.key,
    this.width = 200,
  })  : height = 24,
        borderRadius = const BorderRadius.all(Radius.circular(4));

  const ShimmerPlaceholder.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(100));

  const ShimmerPlaceholder.card({
    super.key,
    this.height = 120,
  })  : width = double.infinity,
        borderRadius = const BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.3),
        borderRadius: borderRadius ?? AppSpacing.borderRadiusSm,
      ),
    );
  }
}

/// Common shimmer loading states
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ShimmerPlaceholder.circle(size: 48),
                const SizedBox(width: AppSpacing.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerPlaceholder.title(width: 120),
                      const SizedBox(height: AppSpacing.gapXs),
                      ShimmerPlaceholder.text(width: MediaQuery.of(context).size.width * 0.4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gapMd),
            const ShimmerPlaceholder.text(),
            const SizedBox(height: AppSpacing.gapXs),
            const ShimmerPlaceholder.text(width: 200),
          ],
        ),
      ),
    );
  }
}

