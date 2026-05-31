import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/di/injection.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';
import 'package:tailorhouse/src/features/workflow/presentation/bloc/workflow_bloc.dart';
import 'package:tailorhouse/src/application/application.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:intl/intl.dart';

/// Worker Queue Screen
/// 
/// Per PRD: Workers see orders ready for their stage
/// - Cutter: Orders in MEASURED status
/// - Tailor: Orders in CUTTING status
/// - Button Worker: Orders in SEWING status
/// - Iron Worker: Orders in BUTTONING status
class WorkerQueueScreen extends StatelessWidget {
  final UserRole workerRole;

  const WorkerQueueScreen({
    super.key,
    required this.workerRole,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WorkflowBloc>()
        ..add(GetWorkerQueueEvent(
          shopId: 'SHOP_001', // TODO: Get from current user
          workerRole: workerRole,
        )),
      child: _WorkerQueueContent(workerRole: workerRole),
    );
  }
}

class _WorkerQueueContent extends StatelessWidget {
  final UserRole workerRole;
  final String _currentUserId = 'USER_001'; // TODO: Get from current user
  final String _currentUserName = 'عامل'; // TODO: Get from current user

  _WorkerQueueContent({required this.workerRole});

  String get _screenTitle {
    switch (workerRole) {
      case UserRole.cutter:
        return 'قائمة القص';
      case UserRole.tailor:
        return 'قائمة الخياطة';
      case UserRole.buttonWorker:
        return 'قائمة التزرير';
      case UserRole.ironWorker:
        return 'قائمة الكي';
      default:
        return 'قائمة الأعمال';
    }
  }

  void _moveToNextStatus(BuildContext context, String orderId, GarmentStatus nextStatus) {
    context.read<WorkflowBloc>().add(
          TransitionWorkflowEvent(
            orderId: orderId,
            targetStatus: nextStatus,
            userId: _currentUserId,
            userName: _currentUserName,
            userRole: workerRole,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle, style: AppTypography.titleLarge),
      ),
      body: BlocListener<WorkflowBloc, WorkflowState>(
        listener: (context, state) {
          if (state is WorkflowTransitioned) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث حالة الطلب بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            // Refresh queue
            context.read<WorkflowBloc>().add(
                  GetWorkerQueueEvent(
                    shopId: 'SHOP_001',
                    workerRole: workerRole,
                  ),
                );
          } else if (state is WorkflowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<WorkflowBloc, WorkflowState>(
          builder: (context, state) {
            if (state is WorkflowLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WorkflowError) {
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

            if (state is WorkerQueueLoaded) {
              final queue = state.output;
              
              if (queue.queueItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: AppColors.textSecondary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'لا توجد طلبات في القائمة',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WorkflowBloc>().add(
                        GetWorkerQueueEvent(
                          shopId: 'SHOP_001',
                          workerRole: workerRole,
                        ),
                      );
                },
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Stats
                    if (queue.urgentCount > 0 || queue.overdueCount > 0)
                      Card(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(
                                label: 'إجمالي',
                                value: queue.totalCount.toString(),
                              ),
                              if (queue.urgentCount > 0)
                                _StatItem(
                                  label: 'عاجل',
                                  value: queue.urgentCount.toString(),
                                  color: AppColors.warning,
                                ),
                              if (queue.overdueCount > 0)
                                _StatItem(
                                  label: 'متأخر',
                                  value: queue.overdueCount.toString(),
                                  color: AppColors.error,
                                ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),

                    // Queue items
                    ...queue.queueItems.map((item) => _QueueItemCard(
                          item: item,
                          onMoveToNext: () => _moveToNextStatus(
                            context,
                            item.orderId,
                            item.targetStatus,
                          ),
                        )),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headlineSmall.copyWith(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }
}

class _QueueItemCard extends StatelessWidget {
  final WorkerQueueItem item;
  final VoidCallback onMoveToNext;

  const _QueueItemCard({
    required this.item,
    required this.onMoveToNext,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => context.push(
          '${AppRoutes.orderDetails}/${item.orderId}',
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.garmentIdDisplay,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'متأخر',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Customer
              Text(
                item.customerName,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Garment type
              Text(
                item.garmentType.arabicName,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Expected delivery
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'التسليم: ${dateFormat.format(item.expectedDeliveryDate)}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Action button
              AppButton.primary(
                text: 'الانتقال إلى ${item.targetStatus.arabicName}',
                onPressed: onMoveToNext,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

