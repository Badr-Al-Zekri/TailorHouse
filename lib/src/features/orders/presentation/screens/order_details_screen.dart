import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailorhouse/src/core/di/injection.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailorhouse/src/features/workflow/presentation/bloc/workflow_bloc.dart'
    as workflow;
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:intl/intl.dart';

/// Order Details Screen
/// 
/// Per PRD FR-10: View current order status, know current stage
/// Shows complete order information with workflow timeline
class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<OrderBloc>()),
        BlocProvider.value(value: sl<workflow.WorkflowBloc>()),
      ],
      child: _OrderDetailsContent(orderId: orderId),
    );
  }
}

class _OrderDetailsContent extends StatefulWidget {
  final String orderId;

  const _OrderDetailsContent({required this.orderId});

  @override
  State<_OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<_OrderDetailsContent> {
  final String _currentUserId = 'USER_001'; 
  final String _currentUserName = 'موظف'; 
  final UserRole _currentUserRole = UserRole.staff; 

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(
          GetOrderDetailsEvent(orderId: widget.orderId),
        );
  }

  void _transitionToNextStatus(Order order) {
    final nextStatus = order.status.nextStatus;
    if (nextStatus == null) return;

    context.read<workflow.WorkflowBloc>().add(
          workflow.TransitionWorkflowEvent(
            orderId: order.id,
            targetStatus: nextStatus,
            userId: _currentUserId,
            userName: _currentUserName,
            userRole: _currentUserRole,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب', style: AppTypography.titleLarge),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<workflow.WorkflowBloc, workflow.WorkflowState>(
            listener: (context, state) {
              if (state is workflow.WorkflowTransitioned) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تحديث حالة الطلب بنجاح'),
                    backgroundColor: AppColors.success,
                  ),
                );
                // Refresh order details
                context.read<OrderBloc>().add(
                      GetOrderDetailsEvent(orderId: widget.orderId),
                    );
              } else if (state is workflow.WorkflowError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(state.message, style: AppTypography.bodyLarge),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderBloc>().add(
                              GetOrderDetailsEvent(orderId: widget.orderId),
                            );
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is OrderDetailsLoaded) {
              final order = state.order;
              final nextStatus = order.status.nextStatus;
              final canTransition = nextStatus != null;

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Garment ID Card
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
                            order.garmentId.toString(),
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

                  // Customer Info
                  _InfoSection(
                    title: 'معلومات الزبون',
                    items: [
                      _InfoItem(label: 'الاسم', value: order.customerName),
                      _InfoItem(label: 'الهاتف', value: order.customerPhone),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Order Details
                  _InfoSection(
                    title: 'تفاصيل الطلب',
                    items: [
                      _InfoItem(
                        label: 'نوع القطعة',
                        value: order.garmentType.arabicName,
                      ),
                      _InfoItem(
                        label: 'وصف القماش',
                        value: order.fabricDescription,
                      ),
                      if (order.fabricColor != null)
                        _InfoItem(
                          label: 'لون القماش',
                          value: order.fabricColor!,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Pricing
                  _InfoSection(
                    title: 'التسعير',
                    items: [
                      _InfoItem(
                        label: 'السعر الإجمالي',
                        value: order.totalPrice.formatArabic(),
                      ),
                      _InfoItem(
                        label: 'العربون المدفوع',
                        value: order.depositPaid.formatArabic(),
                      ),
                      _InfoItem(
                        label: 'المتبقي',
                        value: order.remainingBalance.formatArabic(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Delivery Info
                  _InfoSection(
                    title: 'معلومات التسليم',
                    items: [
                      _InfoItem(
                        label: 'تاريخ التسليم المتوقع',
                        value: DateFormat('yyyy/MM/dd', 'ar')
                            .format(order.expectedDeliveryDate),
                      ),
                      if (order.actualDeliveryDate != null)
                        _InfoItem(
                          label: 'تاريخ التسليم الفعلي',
                          value: DateFormat('yyyy/MM/dd', 'ar')
                              .format(order.actualDeliveryDate!),
                        ),
                      if (order.isOverdue)
                        _InfoItem(
                          label: 'الحالة',
                          value: 'متأخر',
                          valueColor: AppColors.error,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Workflow Timeline
                  _WorkflowTimeline(order: order),
                  const SizedBox(height: AppSpacing.md),

                  // Measurements
                  if (order.measurement != null)
                    _MeasurementsSection(measurement: order.measurement!),
                  const SizedBox(height: AppSpacing.md),

                  // Action Button
                  if (canTransition)
                    AppButton.primary(
                      text: 'الانتقال إلى ${nextStatus.arabicName}',
                      onPressed: () => _transitionToNextStatus(order),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.label,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        item.value,
                        style: AppTypography.bodyMedium.copyWith(
                          color: item.valueColor ?? AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  final Color? valueColor;

  _InfoItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

class _WorkflowTimeline extends StatelessWidget {
  final Order order;

  const _WorkflowTimeline({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سير العمل',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...GarmentStatus.values.asMap().entries.map((entry) {
              final index = entry.key;
              final status = entry.value;
              final isCompleted = order.status.order > status.order ||
                  order.status == status;
              final isCurrent = order.status == status;

              return _TimelineItem(
                status: status,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLast: index == GarmentStatus.values.length - 1,
                log: order.workflowLogs.firstWhere(
                  (log) => log.toStatus == status,
                  orElse: () => order.workflowLogs.first,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final GarmentStatus status;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final WorkflowLog log;

  const _TimelineItem({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent
                    ? AppColors.primary
                    : isCompleted
                        ? AppColors.success
                        : AppColors.textSecondary.withValues(alpha: 0.3),
                border: Border.all(
                  color: isCurrent ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? AppColors.success
                    : AppColors.textSecondary.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.arabicName,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent
                      ? AppColors.primary
                      : isCompleted
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              ),
              if (isCompleted || isCurrent)
                Text(
                  DateFormat('yyyy/MM/dd HH:mm', 'ar').format(log.timestamp),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeasurementsSection extends StatelessWidget {
  final Measurement measurement;

  const _MeasurementsSection({required this.measurement});

  @override
  Widget build(BuildContext context) {
    final measurements = <String, MeasurementValue?>{};
    if (measurement.height != null) measurements['الطول'] = measurement.height;
    if (measurement.shoulder != null) measurements['العرض'] = measurement.shoulder;
    if (measurement.chest != null) measurements['الصدر'] = measurement.chest;
    if (measurement.waist != null) measurements['الخصر'] = measurement.waist;
    if (measurement.hips != null) measurements['الأرداف'] = measurement.hips;
    if (measurement.sleeveLength != null) {
      measurements['طول الكم'] = measurement.sleeveLength;
    }

    if (measurements.isEmpty) return const SizedBox.shrink();

    return Card(
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
            const SizedBox(height: AppSpacing.sm),
            ...measurements.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        entry.value!.formatCm(),
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
