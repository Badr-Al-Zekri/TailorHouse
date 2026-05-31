import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/di/injection.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/features/measurement/presentation/bloc/measurement_bloc.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Measurement Results Screen
/// 
/// Shows AI measurement results with confidence scores
/// Allows editing/adjustment of measurements
class MeasurementResultsScreen extends StatelessWidget {
  final String orderId;

  const MeasurementResultsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MeasurementBloc>()
        ..add(GetMeasurementEvent(orderId: orderId)),
      child: _MeasurementResultsContent(orderId: orderId),
    );
  }
}

class _MeasurementResultsContent extends StatelessWidget {
  final String orderId;

  const _MeasurementResultsContent({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج القياس', style: AppTypography.titleLarge),
      ),
      body: BlocBuilder<MeasurementBloc, MeasurementState>(
        builder: (context, state) {
          if (state is MeasurementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MeasurementError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: AppSpacing.md),
                  Text(state.message, style: AppTypography.bodyLarge),
                ],
              ),
            );
          }

          if (state is MeasurementLoaded) {
            final measurement = state.measurement;
            final measurements = <String, MeasurementValue>{};
            
            if (measurement.height != null) measurements['الطول'] = measurement.height!;
            if (measurement.shoulder != null) measurements['عرض الكتف'] = measurement.shoulder!;
            if (measurement.chest != null) measurements['محيط الصدر'] = measurement.chest!;
            if (measurement.waist != null) measurements['محيط الخصر'] = measurement.waist!;
            if (measurement.hips != null) measurements['محيط الأرداف'] = measurement.hips!;
            if (measurement.sleeveLength != null) measurements['طول الكم'] = measurement.sleeveLength!;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Confidence indicator
                if (measurement.isAiMeasurement)
                  Card(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'قياس بالذكاء الاصطناعي',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (measurement.averageConfidence != null)
                                  Text(
                                    'مستوى الثقة: ${(measurement.averageConfidence! * 100).toStringAsFixed(0)}%',
                                    style: AppTypography.caption,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),

                // Measurements list
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'القياسات',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...measurements.entries.map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: AppTypography.bodyMedium,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        entry.value.formatCm(),
                                        style: AppTypography.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (entry.value.isAiMeasurement &&
                                          entry.value.confidence != null) ...[
                                        const SizedBox(width: AppSpacing.xs),
                                        Icon(
                                          entry.value.hasHighConfidence
                                              ? Icons.check_circle
                                              : Icons.warning_amber_rounded,
                                          size: 16,
                                          color: entry.value.hasHighConfidence
                                              ? AppColors.success
                                              : AppColors.warning,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Action buttons
                AppButton.primary(
                  text: 'تعديل القياسات',
                  onPressed: () {
                    context.push(
                      '${AppRoutes.manualMeasurement}?orderId=$orderId',
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton.secondary(
                  text: 'حفظ والاستمرار',
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
