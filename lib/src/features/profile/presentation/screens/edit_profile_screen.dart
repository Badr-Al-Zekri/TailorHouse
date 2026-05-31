import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';

/// Edit profile screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@email.com');
  final _phoneController = TextEditingController(text: '+1 234 567 8900');
  DateTime? _dateOfBirth = DateTime(1990, 5, 15);
  String _selectedGender = 'Male';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
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
                      onTap: () {
                        // TODO: Implement image picker
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: AppSpacing.xxl),

            // Name field
            AppTextField(
              label: 'Full Name',
              controller: _nameController,
              prefixIcon: const Icon(Icons.person_outline),
              textCapitalization: TextCapitalization.words,
            ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.md),

            // Email field
            AppTextField.email(
              controller: _emailController,
              enabled: false, // Email can't be changed
            ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.md),

            // Phone field
            AppTextField.phone(
              controller: _phoneController,
            ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.md),

            // Date of birth
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date of Birth', style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          _dateOfBirth != null
                              ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                              : 'Select date',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.md),

            // Gender selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gender', style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: ['Male', 'Female', 'Other'].map((gender) {
                    final isSelected = _selectedGender == gender;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = gender),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                            right: gender != 'Other' ? AppSpacing.sm : 0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.paddingSm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.surface,
                            borderRadius: AppSpacing.borderRadiusMd,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              gender,
                              style: AppTypography.labelMedium.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ).animate(delay: 500.ms).fadeIn().slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.xxl),

            // Save button
            AppButton.gradient(
              text: 'Save Changes',
              onPressed: _isSaving ? null : _saveProfile,
              isLoading: _isSaving,
            ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

