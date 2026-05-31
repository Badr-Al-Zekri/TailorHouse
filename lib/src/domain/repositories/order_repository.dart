import 'package:tailorhouse/src/domain/entities/order.dart';
import 'package:tailorhouse/src/domain/enums/garment_status.dart';

/// Order Repository Interface
/// 
/// Defines the contract for order persistence.
/// Implementation details are deferred to the infrastructure layer.
/// 
/// This is a pure domain interface - no infrastructure dependencies.
abstract class OrderRepository {
  /// Create a new order
  Future<Order> create(Order order);

  /// Get order by ID
  Future<Order?> getById(String id);

  /// Get order by garment ID string (e.g., "TF01-25-00458")
  Future<Order?> getByGarmentId(String garmentId);

  /// Update an existing order
  Future<Order> update(Order order);

  /// Get all orders for a shop
  Future<List<Order>> getByShopId(String shopId);

  /// Get orders by status
  Future<List<Order>> getByStatus(String shopId, GarmentStatus status);

  /// Get orders by customer
  Future<List<Order>> getByCustomerId(String customerId);

  /// Get orders in progress (not delivered)
  Future<List<Order>> getInProgressOrders(String shopId);

  /// Get overdue orders
  Future<List<Order>> getOverdueOrders(String shopId);

  /// Search orders by garment ID or customer name
  Future<List<Order>> search(String shopId, String query);

  /// Get order count by status for a shop
  Future<Map<GarmentStatus, int>> getStatusCounts(String shopId);

  /// Delete an order (soft delete recommended)
  Future<void> delete(String id);

  /// Get the last sequence number used for a shop in a given year
  Future<int> getLastGarmentSequence(String shopCode, int year);

  /// Increment and get the next sequence number
  Future<int> getNextGarmentSequence(String shopCode, int year);
}

