import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';

/// Change password screen
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Your password must be at least 8 characters and contain both letters and numbers.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
              const SizedBox(height: AppSpacing.xl),

              // Current password
              AppTextField.password(
                label: 'Current Password',
                hint: 'Enter your current password',
                controller: _currentPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Current password is required';
                  }
                  return null;
                },
              ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.05, end: 0),
              const SizedBox(height: AppSpacing.md),

              // New password
              AppTextField.password(
                label: 'New Password',
                hint: 'Enter your new password',
                controller: _newPasswordController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'New password is required';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                    return 'Password must contain letters and numbers';
                  }
                  if (value == _currentPasswordController.text) {
                    return 'New password must be different from current';
                  }
                  return null;
                },
              ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.05, end: 0),
              const SizedBox(height: AppSpacing.md),

              // Confirm new password
              AppTextField.password(
                label: 'Confirm New Password',
                hint: 'Re-enter your new password',
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.05, end: 0),
              const SizedBox(height: AppSpacing.xxl),

              // Password strength indicator
              _PasswordStrengthIndicator(
                password: _newPasswordController.text,
              ).animate(delay: 400.ms).fadeIn(),
              const SizedBox(height: AppSpacing.xxl),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      text: 'Cancel',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton.gradient(
                      text: 'Save Changes',
                      onPressed: _isSaving ? null : _changePassword,
                      isLoading: _isSaving,
                    ),
                  ),
                ],
              ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const _PasswordStrengthIndicator({required this.password});

  int get _strength {
    if (password.isEmpty) return 0;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    return strength;
  }

  String get _strengthText {
    if (_strength <= 1) return 'Weak';
    if (_strength <= 3) return 'Medium';
    if (_strength <= 5) return 'Strong';
    return 'Very Strong';
  }

  Color get _strengthColor {
    if (_strength <= 1) return AppColors.error;
    if (_strength <= 3) return AppColors.warning;
    if (_strength <= 5) return AppColors.success;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Password Strength', style: AppTypography.labelMedium),
            Text(
              _strengthText,
              style: AppTypography.labelMedium.copyWith(color: _strengthColor),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: List.generate(6, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 5 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index < _strength ? _strengthColor : AppColors.border,
                  borderRadius: AppSpacing.borderRadiusRound,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

