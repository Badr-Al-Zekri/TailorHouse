import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// Profile screen (Account tab)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'JD',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => context.push(AppRoutes.editProfile),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'John Doe',
                      style: AppTypography.headlineSmall,
                    ),
                    Text(
                      'john.doe@email.com',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatItem(value: '12', label: 'Orders'),
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.border,
                          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        ),
                        _StatItem(value: '3', label: 'Profiles'),
                        Container(
                          width: 1,
                          height: 30,
                          color: AppColors.border,
                          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        ),
                        _StatItem(value: '4.9', label: 'Rating'),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.lg),

              // Menu sections
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline,
                      title: 'My Profile',
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.straighten,
                      title: 'My Measurements',
                      subtitle: '3 profiles saved',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Order History',
                      subtitle: '12 orders',
                      onTap: () => context.push(AppRoutes.orders),
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.favorite_outline,
                      title: 'Wishlist',
                      onTap: () {},
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.md),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                  ],
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.md),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: _MenuItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  titleColor: AppColors.error,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption,
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }
}

