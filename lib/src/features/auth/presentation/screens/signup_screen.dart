import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';

/// Sign up screen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement actual sign up
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to language selection after successful signup
    context.go(AppRoutes.chooseLanguage);
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Create Account',
                  style: AppTypography.headlineMedium,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Sign up to get started',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate(delay: 100.ms).fadeIn(),
                const SizedBox(height: AppSpacing.xl),

                // Name field
                AppTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: AppSpacing.md),

                // Email field
                AppTextField.email(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    // Proper email format validation with @ and .
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email (e.g., example@gmail.com)';
                    }
                    return null;
                  },
                ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: AppSpacing.md),

                // Password field
                AppTextField.password(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: AppSpacing.md),

                // Confirm Password field
                AppTextField.password(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ).animate(delay: 500.ms).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: AppSpacing.md),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() => _acceptTerms = value ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: AppTypography.bodySmall,
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 600.ms).fadeIn(),
                const SizedBox(height: AppSpacing.xl),

                // Sign up button
                AppButton.gradient(
                  text: 'Sign Up',
                  onPressed: _isLoading ? null : _handleSignUp,
                  isLoading: _isLoading,
                ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.lg),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        'or',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ).animate(delay: 800.ms).fadeIn(),
                const SizedBox(height: AppSpacing.lg),

                // Google sign up
                AppButton.outlined(
                  text: 'Continue with Google',
                  onPressed: () {
                    // TODO: Implement Google sign up
                  },
                  leadingIcon: Icons.g_mobiledata,
                ).animate(delay: 900.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.xxl),

                // Login link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Log In',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 1000.ms).fadeIn(),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

