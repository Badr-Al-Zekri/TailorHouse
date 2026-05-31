import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';

/// Enable Location screen - shown after language selection
class EnableLocationScreen extends StatelessWidget {
  const EnableLocationScreen({super.key});

  void _enableLocation(BuildContext context) async {
    // TODO: Request location permission
    // For now, just navigate to home
    context.go(AppRoutes.home);
  }

  void _skipLocation(BuildContext context) {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    // Inner ring
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    // Icon
                    const Icon(
                      Icons.location_on,
                      size: 64,
                      color: AppColors.accent,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                'Enable Your Location',
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.md),

              // Description
              Text(
                'We need your location to find nearby tailors and provide better service. Your location data is only used while using the app.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 400.ms).fadeIn(),
              const Spacer(flex: 2),

              // Features list
              _FeatureItem(
                icon: Icons.store,
                text: 'Find nearby tailors',
              ).animate(delay: 500.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: AppSpacing.sm),
              _FeatureItem(
                icon: Icons.delivery_dining,
                text: 'Track deliveries in real-time',
              ).animate(delay: 600.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: AppSpacing.sm),
              _FeatureItem(
                icon: Icons.directions,
                text: 'Get directions to shops',
              ).animate(delay: 700.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const Spacer(),

              // Enable Location button
              AppButton.gradient(
                text: 'Enable Location',
                onPressed: () => _enableLocation(context),
                leadingIcon: Icons.my_location,
              ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.md),

              // Not now button
              TextButton(
                onPressed: () => _skipLocation(context),
                child: Text(
                  'Not Now',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ).animate(delay: 900.ms).fadeIn(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Icon(
            icon,
            color: AppColors.success,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          text,
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }
}

