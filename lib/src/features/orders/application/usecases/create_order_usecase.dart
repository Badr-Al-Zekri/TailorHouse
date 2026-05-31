import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/core/error/failures.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order_item.dart';
import 'package:tailorhouse/src/features/orders/domain/repositories/order_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for creating a new order
class CreateOrderUseCase {
  final OrderRepository _repository;
  final Uuid _uuid;

  CreateOrderUseCase(
    this._repository, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  /// Execute order creation
  FutureResult<Order> call(CreateOrderParams params) async {
    // Validate input
    final validationError = _validateInput(params);
    if (validationError != null) {
      return Results.failure(validationError);
    }

    // Calculate total amount
    final totalAmount = params.items.fold<double>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );

    // Create the order
    final now = DateTime.now();
    final order = Order(
      id: _uuid.v4(),
      customerId: params.customerId,
      measurementProfileId: params.measurementProfileId,
      items: params.items,
      status: OrderStatus.pending,
      totalAmount: totalAmount,
      notes: params.notes,
      estimatedCompletionDate: _calculateEstimatedCompletion(params.items),
      createdAt: now,
      updatedAt: now,
      statusHistory: [
        OrderStatusHistory(
          status: OrderStatus.pending,
          changedAt: now,
          note: 'Order created',
        ),
      ],
      isSynced: false,
    );

    return _repository.createOrder(order);
  }

  Failure? _validateInput(CreateOrderParams params) {
    if (params.items.isEmpty) {
      return const ValidationFailure(message: 'Order must have at least one item');
    }

    for (final item in params.items) {
      if (item.quantity < 1) {
        return const ValidationFailure(message: 'Item quantity must be at least 1');
      }
      if (item.unitPrice <= 0) {
        return const ValidationFailure(message: 'Item price must be greater than 0');
      }
    }

    return null;
  }

  DateTime _calculateEstimatedCompletion(List<OrderItem> items) {
    // Base estimation: 7 days + 2 days per item
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final daysToAdd = 7 + (totalItems * 2);
    return DateTime.now().add(Duration(days: daysToAdd));
  }
}

/// Parameters for creating an order
class CreateOrderParams {
  final String customerId;
  final String? measurementProfileId;
  final List<OrderItem> items;
  final String? notes;

  const CreateOrderParams({
    required this.customerId,
    this.measurementProfileId,
    required this.items,
    this.notes,
  });
}

