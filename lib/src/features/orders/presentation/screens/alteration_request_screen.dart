import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order_item.dart';

/// Alteration request screen
class AlterationRequestScreen extends StatefulWidget {
  const AlterationRequestScreen({super.key});

  @override
  State<AlterationRequestScreen> createState() => _AlterationRequestScreenState();
}

class _AlterationRequestScreenState extends State<AlterationRequestScreen> {
  final Set<AlterationType> _selectedAlterations = {};
  final _notesController = TextEditingController();
  final List<String> _uploadedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _selectImage() {
    // TODO: Implement image picker
    setState(() {
      _uploadedImages.add('image_${_uploadedImages.length + 1}');
    });
  }

  Future<void> _submitRequest() async {
    if (_selectedAlterations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one alteration type')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alteration request submitted successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Alteration'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
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
                      'Upload photos of your garment and describe the alterations needed.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: AppSpacing.xl),

            // Upload photos section
            Text('Upload Photos', style: AppTypography.titleMedium)
                .animate(delay: 100.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                // Add photo button
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(
                        color: AppColors.primary,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: AppColors.primary),
                        const SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Uploaded images
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _uploadedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.border.withValues(alpha: 0.3),
                            borderRadius: AppSpacing.borderRadiusMd,
                          ),
                          child: Stack(
                            children: [
                              const Center(
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _uploadedImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: AppSpacing.xl),

            // Alteration types
            Text('Select Alteration Type', style: AppTypography.titleMedium)
                .animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: AlterationType.values.map((type) {
                final isSelected = _selectedAlterations.contains(type);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedAlterations.remove(type);
                      } else {
                        _selectedAlterations.add(type);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingMd,
                      vertical: AppSpacing.paddingSm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.surface,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          type.displayName,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ).animate(delay: 400.ms).fadeIn(),
            const SizedBox(height: AppSpacing.xl),

            // Description
            Text('Description', style: AppTypography.titleMedium)
                .animate(delay: 500.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),
            AppTextField.multiline(
              controller: _notesController,
              hint: 'Describe the alterations needed in detail...\n\nFor example:\n- Shorten sleeves by 2 inches\n- Take in waist by 1 inch',
              minLines: 5,
              maxLines: 8,
            ).animate(delay: 600.ms).fadeIn(),
            const SizedBox(height: AppSpacing.xl),

            // Estimated cost
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingMd),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: AppColors.secondary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Cost',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          'Will be confirmed after review',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${(_selectedAlterations.length * 15).toStringAsFixed(2)}+',
                    style: AppTypography.price.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 700.ms).fadeIn(),
            const SizedBox(height: AppSpacing.xxl),

            // Submit button
            AppButton.gradient(
              text: 'Submit Request',
              onPressed: _isSubmitting ? null : _submitRequest,
              isLoading: _isSubmitting,
            ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

