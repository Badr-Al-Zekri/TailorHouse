import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';

/// Splash screen with animated logo
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    // TODO: Check if user is logged in and has completed onboarding
    // For now, always go to onboarding
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.borderRadiusXl,
                ),
                child: const Icon(
                  Icons.content_cut,
                  size: 64,
                  color: AppColors.white,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: AppSpacing.lg),
              // App Name
              Text(
                'TailorHouse',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: AppSpacing.sm),
              // Tagline
              Text(
                'Perfect Fit, Every Time',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 600.ms),
              const Spacer(flex: 2),
              // Loading indicator
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

