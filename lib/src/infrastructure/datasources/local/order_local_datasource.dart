import 'package:tailorhouse/src/infrastructure/models/order_model.dart';
import 'package:tailorhouse/src/infrastructure/services/storage_service.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Local data source for Order operations
class OrderLocalDataSource {
  final StorageService _storageService;

  OrderLocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Save an order
  Future<OrderModel> save(OrderModel order) async {
    await _storageService.ordersBox.put(order.id, order);
    return order;
  }

  /// Get order by ID
  OrderModel? getById(String id) {
    return _storageService.ordersBox.get(id);
  }

  /// Get order by garment ID string
  OrderModel? getByGarmentId(String garmentId) {
    try {
      return _storageService.ordersBox.values.firstWhere(
        (order) => order.garmentIdString.toLowerCase() == garmentId.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get all orders for a shop
  List<OrderModel> getByShopId(String shopId) {
    return _storageService.ordersBox.values
        .where((order) => order.shopId == shopId)
        .toList();
  }

  /// Get orders by status
  List<OrderModel> getByStatus(String shopId, GarmentStatus status) {
    return _storageService.ordersBox.values
        .where((order) =>
            order.shopId == shopId && order.statusIndex == status.index)
        .toList();
  }

  /// Get orders by customer
  List<OrderModel> getByCustomerId(String customerId) {
    return _storageService.ordersBox.values
        .where((order) => order.customerId == customerId)
        .toList();
  }

  /// Get orders in progress (not delivered)
  List<OrderModel> getInProgressOrders(String shopId) {
    return _storageService.ordersBox.values
        .where((order) =>
            order.shopId == shopId &&
            order.statusIndex != GarmentStatus.delivered.index)
        .toList();
  }

  /// Get overdue orders
  List<OrderModel> getOverdueOrders(String shopId) {
    final now = DateTime.now();
    return _storageService.ordersBox.values
        .where((order) =>
            order.shopId == shopId &&
            order.statusIndex != GarmentStatus.delivered.index &&
            order.expectedDeliveryDate.isBefore(now))
        .toList();
  }

  /// Search orders
  List<OrderModel> search(String shopId, String query) {
    final lowerQuery = query.toLowerCase();
    return _storageService.ordersBox.values
        .where((order) =>
            order.shopId == shopId &&
            (order.garmentIdString.toLowerCase().contains(lowerQuery) ||
                order.customerName.toLowerCase().contains(lowerQuery) ||
                order.customerPhone.contains(lowerQuery)))
        .toList();
  }

  /// Get status counts
  Map<GarmentStatus, int> getStatusCounts(String shopId) {
    final counts = <GarmentStatus, int>{};
    for (final status in GarmentStatus.values) {
      counts[status] = 0;
    }

    for (final order in _storageService.ordersBox.values) {
      if (order.shopId == shopId) {
        final status = GarmentStatus.values[order.statusIndex];
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }

    return counts;
  }

  /// Delete order
  Future<void> delete(String id) async {
    await _storageService.ordersBox.delete(id);
  }

  /// Get last garment sequence for shop/year
  int getLastGarmentSequence(String shopCode, int year) {
    return _storageService.getLastSequence(shopCode, year);
  }

  /// Get and increment next garment sequence
  Future<int> getNextGarmentSequence(String shopCode, int year) async {
    final current = _storageService.getLastSequence(shopCode, year);
    final next = current + 1;
    await _storageService.setSequence(shopCode, year, next);
    return next;
  }
}

