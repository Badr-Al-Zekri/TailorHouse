import 'package:equatable/equatable.dart';
import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/features/orders/domain/entities/order_item.dart';

/// Represents a customer order
class Order extends Equatable {
  final String id;
  final String customerId;
  final String? measurementProfileId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double totalAmount;
  final String? notes;
  final DateTime? estimatedCompletionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderStatusHistory> statusHistory;
  final bool isSynced;

  const Order({
    required this.id,
    required this.customerId,
    this.measurementProfileId,
    required this.items,
    required this.status,
    required this.totalAmount,
    this.notes,
    this.estimatedCompletionDate,
    required this.createdAt,
    required this.updatedAt,
    this.statusHistory = const [],
    this.isSynced = false,
  });

  /// Create a copy with updated fields
  Order copyWith({
    String? id,
    String? customerId,
    String? measurementProfileId,
    List<OrderItem>? items,
    OrderStatus? status,
    double? totalAmount,
    String? notes,
    DateTime? estimatedCompletionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderStatusHistory>? statusHistory,
    bool? isSynced,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      measurementProfileId: measurementProfileId ?? this.measurementProfileId,
      items: items ?? this.items,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      estimatedCompletionDate:
          estimatedCompletionDate ?? this.estimatedCompletionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusHistory: statusHistory ?? this.statusHistory,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  /// Total number of items
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Check if order can be cancelled
  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// Check if order is completed
  bool get isCompleted => status == OrderStatus.delivered;

  /// Check if order is active (not completed or cancelled)
  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;

  /// Get progress percentage based on status
  double get progressPercentage {
    switch (status) {
      case OrderStatus.pending:
        return 0.1;
      case OrderStatus.confirmed:
        return 0.25;
      case OrderStatus.cutting:
        return 0.4;
      case OrderStatus.sewing:
        return 0.65;
      case OrderStatus.ready:
        return 0.85;
      case OrderStatus.delivered:
        return 1.0;
      case OrderStatus.cancelled:
        return 0.0;
    }
  }

  /// Get formatted order ID for display
  String get displayId => '#${id.substring(0, 8).toUpperCase()}';

  @override
  List<Object?> get props => [
        id,
        customerId,
        measurementProfileId,
        items,
        status,
        totalAmount,
        notes,
        estimatedCompletionDate,
        createdAt,
        updatedAt,
        statusHistory,
        isSynced,
      ];
}

/// Order status change record
class OrderStatusHistory extends Equatable {
  final OrderStatus status;
  final DateTime changedAt;
  final String? note;

  const OrderStatusHistory({
    required this.status,
    required this.changedAt,
    this.note,
  });

  @override
  List<Object?> get props => [status, changedAt, note];
}

