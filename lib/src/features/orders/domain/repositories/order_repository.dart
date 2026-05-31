import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order_item.dart';

/// Abstract repository for order operations
abstract class OrderRepository {
  /// Get all orders for the current user
  FutureResult<List<Order>> getOrders();

  /// Get orders filtered by status
  FutureResult<List<Order>> getOrdersByStatus(OrderStatus status);

  /// Get a specific order by ID
  FutureResult<Order> getOrder(String id);

  /// Create a new order
  FutureResult<Order> createOrder(Order order);

  /// Update an existing order
  FutureResult<Order> updateOrder(Order order);

  /// Update order status
  FutureResult<Order> updateOrderStatus(String id, OrderStatus status);

  /// Cancel an order
  FutureResult<void> cancelOrder(String id);

  /// Create an alteration request
  FutureResult<AlterationRequest> createAlterationRequest(
    AlterationRequest request,
  );

  /// Get alteration requests for an order
  FutureResult<List<AlterationRequest>> getAlterationRequests(String orderId);

  /// Sync orders with remote server
  FutureResult<void> syncOrders();

  /// Stream of orders for reactive UI
  Stream<List<Order>> watchOrders();

  /// Get order count by status
  FutureResult<Map<OrderStatus, int>> getOrderCountsByStatus();
}

