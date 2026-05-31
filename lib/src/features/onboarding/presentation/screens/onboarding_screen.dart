import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';

/// Onboarding screen with page view
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: Icons.camera_alt_outlined,
      title: 'AI-Powered Measurements',
      subtitle:
          'Get accurate body measurements using just your phone camera. Our AI technology ensures perfect fit every time.',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8B2635), Color(0xFFB54A5A)],
      ),
    ),
    _OnboardingPageData(
      icon: Icons.checkroom_outlined,
      title: 'Custom Made for You',
      subtitle:
          'Order custom-tailored clothes that match your exact measurements. Say goodbye to ill-fitting garments.',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD4A373), Color(0xFFA67B4E)],
      ),
    ),
    _OnboardingPageData(
      icon: Icons.local_shipping_outlined,
      title: 'Track Your Orders',
      subtitle:
          'Stay updated on your order status from cutting to delivery. Request alterations with just a few taps.',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2D6A6A), Color(0xFF4A9898)],
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _getStarted() {
    // TODO: Mark onboarding as complete
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(
                data: _pages[index],
                isVisible: _currentPage == index,
              );
            },
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.paddingSm,
            right: AppSpacing.paddingMd,
            child: TextButton(
              onPressed: _getStarted,
              child: Text(
                'Skip',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),

          // Bottom section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: AppSpacing.screenPaddingHorizontal,
                right: AppSpacing.screenPaddingHorizontal,
                bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
                top: AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 8,
                      dotColor: AppColors.white.withValues(alpha: 0.3),
                      activeDotColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Next/Get Started button
                  AppButton(
                    text: isLastPage ? 'Get Started' : 'Next',
                    onPressed: _nextPage,
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    trailingIcon: isLastPage ? null : Icons.arrow_forward,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final bool isVisible;

  const _OnboardingPage({
    required this.data,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: data.gradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingHorizontal,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  data.icon,
                  size: 80,
                  color: AppColors.white,
                ),
              )
                  .animate(target: isVisible ? 1 : 0)
                  .fadeIn(duration: 500.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
              const Spacer(),
              // Title
              Text(
                data.title,
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(target: isVisible ? 1 : 0, delay: 200.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.md),
              // Subtitle
              Text(
                data.subtitle,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(target: isVisible ? 1 : 0, delay: 350.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 180), // Space for bottom section
            ],
          ),
        ),
      ),
    );
  }
}

