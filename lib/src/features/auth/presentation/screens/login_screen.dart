import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';

/// Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual login
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to language selection after successful login
    context.go(AppRoutes.chooseLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                // Logo & Welcome
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: AppSpacing.borderRadiusLg,
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          size: 40,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Welcome Back',
                        style: AppTypography.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Sign in to continue',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: -0.2, end: 0),
                const SizedBox(height: AppSpacing.xxl),

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
                ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: AppSpacing.md),

                // Password field
                AppTextField.password(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: AppSpacing.md),

                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Remember me',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 300.ms).fadeIn(),
                const SizedBox(height: AppSpacing.xl),

                // Login button
                AppButton.gradient(
                  text: 'Log In',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
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
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: AppSpacing.lg),

                // Google sign in
                AppButton.outlined(
                  text: 'Continue with Google',
                  onPressed: () {
                    // TODO: Implement Google sign in
                  },
                  leadingIcon: Icons.g_mobiledata,
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.xxl),

                // Sign up link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.signup),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 700.ms).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

