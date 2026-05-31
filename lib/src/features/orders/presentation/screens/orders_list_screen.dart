import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tailorhouse/src/core/router/app_router.dart';
import 'package:tailorhouse/src/core/theme/app_colors.dart';
import 'package:tailorhouse/src/core/theme/app_spacing.dart';
import 'package:tailorhouse/src/core/theme/app_typography.dart';
import 'package:tailorhouse/src/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:intl/intl.dart';

/// Orders list screen with status filters
/// 
/// Per PRD: Shows orders filtered by status (CREATED, MEASURED, CUTTING, etc.)
/// Shop Owner/Staff can view all orders, filter by status, and navigate to details
class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final String _currentShopId = 'SHOP_001'; // TODO: Get from current user/shop

  final List<GarmentStatus> _statusTabs = [
    GarmentStatus.created,
    GarmentStatus.measured,
    GarmentStatus.cutting,
    GarmentStatus.sewing,
    GarmentStatus.buttoning,
    GarmentStatus.ironing,
    GarmentStatus.ready,
    GarmentStatus.delivered,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    
    // Load initial orders
    _loadOrders(_statusTabs[0]);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _loadOrders(_statusTabs[_tabController.index]);
  }

  void _loadOrders(GarmentStatus status) {
    context.read<OrderBloc>().add(
          GetOrdersByStatusEvent(
            shopId: _currentShopId,
            status: status,
          ),
        );
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      _loadOrders(_statusTabs[_tabController.index]);
    } else {
      context.read<OrderBloc>().add(
            SearchOrdersEvent(
              shopId: _currentShopId,
              query: query,
            ),
          );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.createOrder),
            tooltip: 'إنشاء طلب جديد',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _statusTabs.map((status) => Tab(
            text: status.arabicName,
          )).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث برقم الطلب أو اسم الزبون...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearch,
            ),
          ),
          // Orders list
          Expanded(
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
                        Text(
                          state.message,
                          style: AppTypography.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () => _loadOrders(_statusTabs[_tabController.index]),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is OrdersLoaded) {
                  if (state.orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: AppColors.textSecondary),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'لا توجد طلبات',
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
                      _loadOrders(_statusTabs[_tabController.index]);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return _OrderCard(order: order);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Order card widget
class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');
    final isOverdue = order.isOverdue;
    final progress = order.progressPercentage;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => context.push(
          '${AppRoutes.orderDetails}/${order.id}',
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Garment ID
                  Text(
                    order.garmentId.toString(),
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status.arabicName,
                      style: AppTypography.caption.copyWith(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Customer info
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    order.customerName,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    order.customerPhone,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Garment type and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.garmentType.arabicName,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    order.totalPrice.formatArabic(),
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التقدم: ${(progress * 100).toStringAsFixed(0)}%',
                        style: AppTypography.caption,
                      ),
                      if (isOverdue)
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
                  const SizedBox(height: AppSpacing.xs),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverdue ? AppColors.error : AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // Expected delivery
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'التسليم المتوقع: ${dateFormat.format(order.expectedDeliveryDate)}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(GarmentStatus status) {
    switch (status) {
      case GarmentStatus.created:
        return Colors.blue;
      case GarmentStatus.measured:
        return Colors.cyan;
      case GarmentStatus.cutting:
        return Colors.orange;
      case GarmentStatus.sewing:
        return Colors.purple;
      case GarmentStatus.buttoning:
        return Colors.pink;
      case GarmentStatus.ironing:
        return Colors.indigo;
      case GarmentStatus.ready:
        return Colors.green;
      case GarmentStatus.delivered:
        return Colors.grey;
    }
  }
}
