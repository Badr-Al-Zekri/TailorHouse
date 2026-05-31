import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order.dart';
import 'package:tailorhouse/src/features/orders/domain/repositories/order_repository.dart';

/// Use case for getting all orders
class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  /// Get all orders for the current user
  FutureResult<List<Order>> call() {
    return _repository.getOrders();
  }

  /// Watch orders for reactive UI
  Stream<List<Order>> watch() {
    return _repository.watchOrders();
  }
}

/// Use case for getting orders by status
class GetOrdersByStatusUseCase {
  final OrderRepository _repository;

  GetOrdersByStatusUseCase(this._repository);

  /// Get orders filtered by status
  FutureResult<List<Order>> call(OrderStatus status) {
    return _repository.getOrdersByStatus(status);
  }
}

/// Use case for getting a single order
class GetOrderUseCase {
  final OrderRepository _repository;

  GetOrderUseCase(this._repository);

  /// Get a specific order by ID
  FutureResult<Order> call(String id) {
    return _repository.getOrder(id);
  }
}

/// Use case for getting order counts by status
class GetOrderCountsUseCase {
  final OrderRepository _repository;

  GetOrderCountsUseCase(this._repository);

  /// Get count of orders grouped by status
  FutureResult<Map<OrderStatus, int>> call() {
    return _repository.getOrderCountsByStatus();
  }
}

/// Use case for cancelling an order
class CancelOrderUseCase {
  final OrderRepository _repository;

  CancelOrderUseCase(this._repository);

  /// Cancel an order by ID
  FutureResult<void> call(String id) {
    return _repository.cancelOrder(id);
  }
}

/// Use case for syncing orders
class SyncOrdersUseCase {
  final OrderRepository _repository;

  SyncOrdersUseCase(this._repository);

  /// Sync all local orders with remote server
  FutureResult<void> call() {
    return _repository.syncOrders();
  }
}

