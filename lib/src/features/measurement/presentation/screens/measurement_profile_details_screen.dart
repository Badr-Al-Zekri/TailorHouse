import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/body_measurement.dart';

/// Screen to display saved measurement profile details
class MeasurementProfileDetailsScreen extends StatelessWidget {
  final String profileId;

  const MeasurementProfileDetailsScreen({
    super.key,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context) {
    // Sample data - would come from repository
    final profile = _SampleProfile(
      name: 'Default Profile',
      height: 175,
      weight: 72,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      measurements: {
        'chest': 98.5,
        'waist': 82.0,
        'hip': 96.0,
        'shoulder': 45.0,
        'neck': 38.5,
        'arm_length': 62.0,
        'inseam': 81.0,
        'thigh': 56.0,
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: Edit profile
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Duplicate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Export'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header card
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingLg),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppSpacing.borderRadiusLg,
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 32,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created ${_formatDate(profile.createdAt)}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
            const SizedBox(height: AppSpacing.lg),

            // Basic info
            Text('Basic Information', style: AppTypography.titleMedium)
                .animate(delay: 100.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.height,
                    label: 'Height',
                    value: '${profile.height} cm',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _InfoCard(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Weight',
                    value: '${profile.weight} kg',
                  ),
                ),
              ],
            ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.xl),

            // Measurements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Measurements', style: AppTypography.titleMedium),
                Text(
                  '${profile.measurements.length} recorded',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),

            // Measurements grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 2.2,
              ),
              itemCount: profile.measurements.length,
              itemBuilder: (context, index) {
                final key = profile.measurements.keys.elementAt(index);
                final value = profile.measurements[key]!;
                final bodyPart = BodyParts.getByKey(key);
                return _MeasurementCard(
                  label: bodyPart?.displayName ?? key,
                  value: value,
                ).animate(delay: Duration(milliseconds: 400 + (index * 50))).fadeIn();
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Use this profile button
            AppButton.gradient(
              text: 'Use This Profile for Order',
              onPressed: () => context.push(AppRoutes.createOrder),
              trailingIcon: Icons.arrow_forward,
            ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    if (diff < 30) return '${(diff / 7).floor()} weeks ago';
    return '${(diff / 30).floor()} months ago';
  }
}

class _SampleProfile {
  final String name;
  final double height;
  final double weight;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, double> measurements;

  _SampleProfile({
    required this.name,
    required this.height,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    required this.measurements,
  });
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption,
              ),
              Text(
                value,
                style: AppTypography.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeasurementCard extends StatelessWidget {
  final String label;
  final double value;

  const _MeasurementCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${value.toStringAsFixed(1)} cm',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

