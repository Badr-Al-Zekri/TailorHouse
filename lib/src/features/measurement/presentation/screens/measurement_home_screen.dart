import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_shadows.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';

/// Home screen for measurements
class MeasurementHomeScreen extends StatelessWidget {
  const MeasurementHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, User 👋',
                              style: AppTypography.headlineSmall,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Ready to take your measurements?',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: AppSpacing.borderRadiusMd,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: AppSpacing.xl),

                    // Quick Actions Card
                    _QuickActionsCard()
                        .animate(delay: 200.ms)
                        .fadeIn()
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: AppSpacing.lg),

                    // Section: Choose Method
                    Text(
                      'Start Measuring',
                      style: AppTypography.titleLarge,
                    ).animate(delay: 400.ms).fadeIn(),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Measurement Options
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // AI Measurement Card
                  _MeasurementOptionCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'AI Measurement',
                    subtitle: 'Quick and accurate using your camera',
                    gradient: AppColors.primaryGradient,
                    features: const [
                      'Takes 2-3 photos',
                      '95% accuracy',
                      '2 minutes',
                    ],
                    onTap: () => context.push(AppRoutes.aiMeasurement),
                    isPrimary: true,
                  )
                      .animate(delay: 500.ms)
                      .fadeIn()
                      .slideX(begin: -0.1, end: 0),
                  const SizedBox(height: AppSpacing.md),

                  // Manual Measurement Card
                  _MeasurementOptionCard(
                    icon: Icons.straighten,
                    title: 'Manual Measurement',
                    subtitle: 'Enter measurements yourself',
                    gradient: AppColors.secondaryGradient,
                    features: const [
                      'Full control',
                      'Detailed input',
                      'Best for pros',
                    ],
                    onTap: () => context.push(AppRoutes.manualMeasurement),
                    isPrimary: false,
                  )
                      .animate(delay: 600.ms)
                      .fadeIn()
                      .slideX(begin: -0.1, end: 0),
                  const SizedBox(height: AppSpacing.xl),

                  // Saved Profiles Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Profiles',
                        style: AppTypography.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ).animate(delay: 700.ms).fadeIn(),
                  const SizedBox(height: AppSpacing.md),

                  // Empty state or profiles list
                  _EmptyProfilesCard()
                      .animate(delay: 800.ms)
                      .fadeIn()
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingLg),
      decoration: BoxDecoration(
        gradient: AppColors.premiumGradient,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppShadows.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Perfect Fit',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Take your measurements with AI in under 2 minutes',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  text: 'Start Now',
                  onPressed: () => context.push(AppRoutes.aiMeasurement),
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  size: AppButtonSize.small,
                  isFullWidth: false,
                  trailingIcon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 48,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final List<String> features;
  final VoidCallback onTap;
  final bool isPrimary;

  const _MeasurementOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.features,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingLg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: isPrimary ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleMedium,
                      ),
                      if (isPrimary) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingXs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppSpacing.borderRadiusSm,
                          ),
                          child: Text(
                            'Recommended',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Features
                  Row(
                    children: features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              feature,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProfilesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingXl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.folder_outlined,
              size: 32,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No saved profiles yet',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Take your first measurement to create a profile',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

