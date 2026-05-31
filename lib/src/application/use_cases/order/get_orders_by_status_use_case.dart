import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for getting orders by status
class GetOrdersByStatusInput {
  final String shopId;
  final GarmentStatus? status; // null means all orders

  const GetOrdersByStatusInput({
    required this.shopId,
    this.status,
  });

  /// Get all orders
  factory GetOrdersByStatusInput.all(String shopId) {
    return GetOrdersByStatusInput(shopId: shopId);
  }

  /// Get orders in progress (not delivered)
  factory GetOrdersByStatusInput.inProgress(String shopId) {
    return GetOrdersByStatusInput(shopId: shopId);
  }
}

/// Order list item with summary info
class OrderListItem {
  final String id;
  final String garmentIdDisplay;
  final String customerName;
  final String customerPhone;
  final GarmentType garmentType;
  final GarmentStatus status;
  final DateTime expectedDeliveryDate;
  final bool isOverdue;
  final double progressPercentage;
  final DateTime createdAt;

  const OrderListItem({
    required this.id,
    required this.garmentIdDisplay,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    required this.status,
    required this.expectedDeliveryDate,
    required this.isOverdue,
    required this.progressPercentage,
    required this.createdAt,
  });

  factory OrderListItem.fromOrder(Order order) {
    return OrderListItem(
      id: order.id,
      garmentIdDisplay: order.garmentId.toString(),
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      garmentType: order.garmentType,
      status: order.status,
      expectedDeliveryDate: order.expectedDeliveryDate,
      isOverdue: order.isOverdue,
      progressPercentage: order.progressPercentage,
      createdAt: order.createdAt,
    );
  }
}

/// Output with order list and counts
class GetOrdersByStatusOutput {
  final List<OrderListItem> orders;
  final Map<GarmentStatus, int> statusCounts;
  final int totalCount;
  final int overdueCount;

  const GetOrdersByStatusOutput({
    required this.orders,
    required this.statusCounts,
    required this.totalCount,
    required this.overdueCount,
  });
}

/// Use case for getting orders filtered by status
class GetOrdersByStatusUseCase implements UseCase<GetOrdersByStatusInput, Result<GetOrdersByStatusOutput>> {
  final OrderRepository _orderRepository;

  GetOrdersByStatusUseCase({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  @override
  Future<Result<GetOrdersByStatusOutput>> execute(GetOrdersByStatusInput input) async {
    try {
      // 1. Get orders
      List<Order> orders;
      if (input.status != null) {
        orders = await _orderRepository.getByStatus(input.shopId, input.status!);
      } else {
        orders = await _orderRepository.getByShopId(input.shopId);
      }

      // 2. Get status counts
      final statusCounts = await _orderRepository.getStatusCounts(input.shopId);

      // 3. Calculate overdue count
      final overdueOrders = await _orderRepository.getOverdueOrders(input.shopId);

      // 4. Convert to list items
      final orderItems = orders.map((o) => OrderListItem.fromOrder(o)).toList();

      // 5. Sort by expected delivery date (nearest first)
      orderItems.sort((a, b) => a.expectedDeliveryDate.compareTo(b.expectedDeliveryDate));

      return Result.success(GetOrdersByStatusOutput(
        orders: orderItems,
        statusCounts: statusCounts,
        totalCount: orders.length,
        overdueCount: overdueOrders.length,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to get orders: $e',
        arabicMessage: 'فشل في جلب الطلبات',
      ));
    }
  }
}

