import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/core/widgets/app_button.dart';

/// Home Screen - Main dashboard
/// 
/// Per PRD: Main entry point for shop staff
/// Shows quick actions and navigation to key features
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TailorHouse', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Quick actions
          Text(
            'الإجراءات السريعة',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
            children: [
              _QuickActionCard(
                icon: Icons.add_circle_outline,
                title: 'إنشاء طلب',
                subtitle: 'طلب جديد',
                color: AppColors.primary,
                onTap: () => context.push(AppRoutes.createOrder),
              ),
              _QuickActionCard(
                icon: Icons.list,
                title: 'الطلبات',
                subtitle: 'عرض جميع الطلبات',
                color: AppColors.secondary,
                onTap: () => context.push(AppRoutes.orders),
              ),
              _QuickActionCard(
                icon: Icons.person_search,
                title: 'البحث عن زبون',
                subtitle: 'إيجاد أو إضافة زبون',
                color: AppColors.accent,
                onTap: () => context.push(AppRoutes.customerSearch),
              ),
              _QuickActionCard(
                icon: Icons.straighten,
                title: 'القياس',
                subtitle: 'قياس يدوي أو بالذكاء الاصطناعي',
                color: AppColors.success,
                onTap: () {
                  // TODO: Show dialog to choose AI or Manual
                  context.push('${AppRoutes.aiMeasurement}?orderId=TEMP');
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Worker queues section
          Text(
            'قوائم العمال',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _WorkerQueueCard(
            title: 'قائمة القص',
            role: 'cutter',
            icon: Icons.content_cut,
            color: Colors.orange,
            onTap: () => context.push('${AppRoutes.workerQueue}?role=cutter'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _WorkerQueueCard(
            title: 'قائمة الخياطة',
            role: 'tailor',
            icon: Icons.build,
            color: Colors.purple,
            onTap: () => context.push('${AppRoutes.workerQueue}?role=tailor'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _WorkerQueueCard(
            title: 'قائمة التزرير',
            role: 'buttonWorker',
            icon: Icons.radio_button_checked,
            color: Colors.pink,
            onTap: () => context.push('${AppRoutes.workerQueue}?role=buttonWorker'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _WorkerQueueCard(
            title: 'قائمة الكي',
            role: 'ironWorker',
            icon: Icons.iron,
            color: Colors.indigo,
            onTap: () => context.push('${AppRoutes.workerQueue}?role=ironWorker'),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Customer view
          Card(
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const Icon(Icons.phone_android, size: 48, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'تتبع الطلب للزبون',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'يمكن للزبون تتبع حالة طلبه باستخدام رقم الطلب ورقم الهاتف',
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.outlined(
                    text: 'فتح صفحة تتبع الطلب',
                    onPressed: () => context.push(AppRoutes.customerOrderStatus),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkerQueueCard extends StatelessWidget {
  final String title;
  final String role;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _WorkerQueueCard({
    required this.title,
    required this.role,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium,
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
