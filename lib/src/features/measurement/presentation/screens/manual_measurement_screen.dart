import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/core/widgets/app_text_field.dart';
import 'package:tailorhouse/src/features/measurement/presentation/bloc/measurement_bloc.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Manual Measurement Screen
/// 
/// Per PRD FR-5: Manual measurement input and adjustment always available
/// Allows staff to enter measurements manually
class ManualMeasurementScreen extends StatefulWidget {
  final String orderId;
  final GarmentType garmentType;

  const ManualMeasurementScreen({
    super.key,
    required this.orderId,
    required this.garmentType,
  });

  @override
  State<ManualMeasurementScreen> createState() => _ManualMeasurementScreenState();
}

class _ManualMeasurementScreenState extends State<ManualMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final String _currentUserId = 'USER_001'; // TODO: Get from current user

  // Required measurements per garment type
  final Map<GarmentType, List<String>> _requiredMeasurements = {
    GarmentType.thobe: ['shoulder', 'chest', 'thobeLength', 'sleeveLength'],
    GarmentType.shirt: ['shoulder', 'chest', 'sleeveLength'],
    GarmentType.trousers: ['waist', 'hips', 'trouserLength'],
    GarmentType.suit: ['shoulder', 'chest', 'waist', 'sleeveLength', 'trouserLength'],
    GarmentType.jacket: ['shoulder', 'chest', 'sleeveLength'],
    GarmentType.abaya: ['shoulder', 'chest', 'height'],
    GarmentType.dress: ['shoulder', 'chest', 'waist', 'hips', 'height'],
    GarmentType.jalabiya: ['shoulder', 'chest', 'height'],
    GarmentType.other: ['chest'],
  };

  final Map<String, String> _measurementLabels = {
    'height': 'الطول (سم)',
    'shoulder': 'عرض الكتف (سم)',
    'chest': 'محيط الصدر (سم)',
    'waist': 'محيط الخصر (سم)',
    'hips': 'محيط الأرداف (سم)',
    'sleeveLength': 'طول الكم (سم)',
    'trouserLength': 'طول البنطلون (سم)',
    'thobeLength': 'طول الثوب (سم)',
    'neck': 'محيط الرقبة (سم)',
    'armLength': 'طول الذراع (سم)',
    'wrist': 'محيط المعصم (سم)',
    'inseam': 'طول الساق الداخلي (سم)',
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers for all measurements
    for (final key in _measurementLabels.keys) {
      _controllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final required = _requiredMeasurements[widget.garmentType] ?? [];
    for (final field in required) {
      if (_controllers[field]?.text.trim().isEmpty ?? true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_measurementLabels[field]} مطلوب')),
        );
        return;
      }
    }

    // Build measurement input
    final measurementInput = <String, double>{};
    for (final entry in _controllers.entries) {
      final value = double.tryParse(entry.value.text);
      if (value != null && value > 0) {
        measurementInput[entry.key] = value;
      }
    }

    context.read<MeasurementBloc>().add(
          AddMeasurementEvent(
            orderId: widget.orderId,
            height: measurementInput['height'],
            shoulder: measurementInput['shoulder'],
            chest: measurementInput['chest'],
            waist: measurementInput['waist'],
            hips: measurementInput['hips'],
            sleeveLength: measurementInput['sleeveLength'],
            trouserLength: measurementInput['trouserLength'],
            thobeLength: measurementInput['thobeLength'],
            neck: measurementInput['neck'],
            armLength: measurementInput['armLength'],
            wrist: measurementInput['wrist'],
            inseam: measurementInput['inseam'],
            isAiMeasurement: false,
            measuredByUserId: _currentUserId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final required = _requiredMeasurements[widget.garmentType] ?? [];
    final optional = _measurementLabels.keys
        .where((key) => !required.contains(key))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('القياس اليدوي', style: AppTypography.titleLarge),
      ),
      body: BlocListener<MeasurementBloc, MeasurementState>(
        listener: (context, state) {
          if (state is MeasurementAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حفظ القياسات بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else if (state is MeasurementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<MeasurementBloc, MeasurementState>(
          builder: (context, state) {
            final isLoading = state is MeasurementLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Info card
                  Card(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'القياسات المطلوبة: ${required.map((r) => _measurementLabels[r]).join(', ')}',
                              style: AppTypography.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Required measurements
                  Text(
                    'القياسات المطلوبة',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...required.map((field) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppTextField.measurement(
                          label: _measurementLabels[field] ?? field,
                          controller: _controllers[field],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '${_measurementLabels[field]} مطلوب';
                            }
                            final num = double.tryParse(value);
                            if (num == null || num <= 0) {
                              return 'يجب أن يكون الرقم أكبر من صفر';
                            }
                            return null;
                          },
                        ),
                      )),
                  const SizedBox(height: AppSpacing.lg),

                  // Optional measurements
                  if (optional.isNotEmpty) ...[
                    Text(
                      'قياسات إضافية (اختياري)',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...optional.map((field) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: AppTextField.measurement(
                            label: _measurementLabels[field] ?? field,
                            controller: _controllers[field],
                          ),
                        )),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Submit button
                  AppButton.primary(
                    text: 'حفظ القياسات',
                    onPressed: isLoading ? null : _onSubmit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
