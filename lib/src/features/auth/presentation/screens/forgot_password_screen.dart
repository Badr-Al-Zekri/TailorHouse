import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';

/// Forgot password screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual password reset
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          // Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 48,
                color: AppColors.primary,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
              ),
          const SizedBox(height: AppSpacing.xl),

          // Header
          Center(
            child: Column(
              children: [
                Text(
                  'Forgot Password?',
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "Don't worry! Enter your email and we'll send you a reset link.",
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.xxl),

          // Email field
          AppTextField.email(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppSpacing.xl),

          // Send button
          AppButton.gradient(
            text: 'Send Reset Link',
            onPressed: _isLoading ? null : _handleSendResetEmail,
            isLoading: _isLoading,
          ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.xxl),

          // Back to login
          Center(
            child: TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Login'),
            ),
          ).animate(delay: 800.ms).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxxl),
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 48,
            color: AppColors.success,
          ),
        ).animate().fadeIn(duration: 400.ms).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
            ),
        const SizedBox(height: AppSpacing.xl),

        // Success message
        Text(
          'Check Your Email',
          style: AppTypography.headlineMedium,
        ).animate(delay: 200.ms).fadeIn(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We have sent a password reset link to\n${_emailController.text}',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 400.ms).fadeIn(),
        const SizedBox(height: AppSpacing.xxl),

        // Didn't receive email
        Text(
          "Didn't receive the email?",
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ).animate(delay: 600.ms).fadeIn(),
        const SizedBox(height: AppSpacing.sm),
        AppButton.text(
          text: 'Resend Email',
          onPressed: () {
            setState(() => _emailSent = false);
          },
        ).animate(delay: 800.ms).fadeIn(),
        const SizedBox(height: AppSpacing.xxl),

        // Back to login
        AppButton.primary(
          text: 'Back to Login',
          onPressed: () => context.pop(),
        ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

