import 'package:flutter/material.dart';
import 'package:tailorhouse/src/core/di/injection.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';
import 'package:tailorhouse/src/application/application.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:intl/intl.dart';

/// Customer Order Status Screen
/// 
/// Per PRD FR-10: Customer can view current order status, know current stage,
/// receive ready notification
/// Security: Requires garment ID and phone verification
class CustomerOrderStatusScreen extends StatefulWidget {
  const CustomerOrderStatusScreen({super.key});

  @override
  State<CustomerOrderStatusScreen> createState() => _CustomerOrderStatusScreenState();
}

class _CustomerOrderStatusScreenState extends State<CustomerOrderStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _garmentIdController = TextEditingController();
  final _phoneController = TextEditingController();
  CustomerOrderView? _orderView;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _garmentIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _checkOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _orderView = null;
    });

    try {
      final useCase = sl<CustomerViewOrderUseCase>();
      final result = await useCase.execute(
        CustomerViewOrderInput(
          garmentId: _garmentIdController.text.trim(),
          customerPhone: _phoneController.text.trim(),
        ),
      );

      result.fold(
        onSuccess: (view) {
          setState(() {
            _orderView = view;
            _isLoading = false;
          });
        },
        onFailure: (failure) {
          setState(() {
            _errorMessage = failure.message;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع الطلب', style: AppTypography.titleLarge),
      ),
      body: _orderView == null
          ? _buildSearchForm()
          : _buildOrderView(_orderView!),
    );
  }

  Widget _buildSearchForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.xl),
          // Icon
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          // Title
          Text(
            'تتبع حالة طلبك',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'أدخل رقم الطلب ورقم هاتفك للتحقق',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Garment ID field
          AppTextField(
            label: 'رقم الطلب',
            hint: 'مثال: TF01-25-00001',
            controller: _garmentIdController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'رقم الطلب مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Phone field
          AppTextField(
            label: 'رقم الهاتف',
            hint: 'أدخل رقم هاتفك',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'رقم الهاتف مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Check button
          AppButton.primary(
            text: 'التحقق من الطلب',
            onPressed: _isLoading ? null : _checkOrder,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderView(CustomerOrderView view) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Garment ID card
        Card(
          color: AppColors.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Text(
                  'رقم الطلب',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  view.garmentIdDisplay,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Status card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الحالة الحالية',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _getStatusColor(view.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(view.status),
                        color: _getStatusColor(view.status),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        view.statusArabic,
                        style: AppTypography.titleLarge.copyWith(
                          color: _getStatusColor(view.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (view.isReady)
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'القطعة جاهزة للاستلام',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Progress
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التقدم',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(view.progressPercentage * 100).toStringAsFixed(0)}%',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                LinearProgressIndicator(
                  value: view.progressPercentage,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Workflow stages
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مراحل العمل',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...view.stages.map((stage) => _CustomerStageItem(stage: stage)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Delivery info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات التسليم',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'التسليم المتوقع: ${DateFormat('yyyy/MM/dd', 'ar').format(view.expectedDeliveryDate)}',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.store, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      view.shopName,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
                if (view.shopPhone.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        view.shopPhone,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Back button
        AppButton.secondary(
          text: 'البحث عن طلب آخر',
          onPressed: () {
            setState(() {
              _orderView = null;
              _garmentIdController.clear();
              _phoneController.clear();
            });
          },
        ),
      ],
    );
  }

  Color _getStatusColor(GarmentStatus status) {
    switch (status) {
      case GarmentStatus.created:
      case GarmentStatus.measured:
        return Colors.blue;
      case GarmentStatus.cutting:
      case GarmentStatus.sewing:
      case GarmentStatus.buttoning:
      case GarmentStatus.ironing:
        return Colors.orange;
      case GarmentStatus.ready:
        return AppColors.success;
      case GarmentStatus.delivered:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(GarmentStatus status) {
    switch (status) {
      case GarmentStatus.created:
        return Icons.add_circle;
      case GarmentStatus.measured:
        return Icons.straighten;
      case GarmentStatus.cutting:
        return Icons.content_cut;
      case GarmentStatus.sewing:
        return Icons.build;
      case GarmentStatus.buttoning:
        return Icons.radio_button_checked;
      case GarmentStatus.ironing:
        return Icons.iron;
      case GarmentStatus.ready:
        return Icons.check_circle;
      case GarmentStatus.delivered:
        return Icons.done_all;
    }
  }
}

class _CustomerStageItem extends StatelessWidget {
  final CustomerWorkflowStage stage;

  const _CustomerStageItem({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stage.isCompleted
                  ? AppColors.success
                  : stage.isCurrent
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            child: stage.isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              stage.nameArabic,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: stage.isCurrent ? FontWeight.bold : FontWeight.normal,
                color: stage.isCurrent
                    ? AppColors.primary
                    : stage.isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

