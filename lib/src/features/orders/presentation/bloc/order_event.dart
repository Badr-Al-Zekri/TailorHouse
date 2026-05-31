part of 'order_bloc.dart';

/// Base class for order events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new order
class CreateOrderEvent extends OrderEvent {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final GarmentType garmentType;
  final String fabricDescription;
  final String? fabricColor;
  final Money totalPrice;
  final Money depositPaid;
  final DateTime expectedDeliveryDate;
  final String? notes;
  final String createdBy;
  final String createdByName;
  final String createdByRole;

  const CreateOrderEvent({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    required this.fabricDescription,
    this.fabricColor,
    required this.totalPrice,
    required this.depositPaid,
    required this.expectedDeliveryDate,
    this.notes,
    required this.createdBy,
    required this.createdByName,
    required this.createdByRole,
  });

  @override
  List<Object?> get props => [
        customerId,
        customerName,
        customerPhone,
        garmentType,
        fabricDescription,
        fabricColor,
        totalPrice,
        depositPaid,
        expectedDeliveryDate,
        notes,
        createdBy,
        createdByName,
        createdByRole,
      ];
}

/// Event to get order details
class GetOrderDetailsEvent extends OrderEvent {
  final String orderId;

  const GetOrderDetailsEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Event to get orders by status
class GetOrdersByStatusEvent extends OrderEvent {
  final String shopId;
  final GarmentStatus status;

  const GetOrdersByStatusEvent({
    required this.shopId,
    required this.status,
  });

  @override
  List<Object?> get props => [shopId, status];
}

/// Event to search orders
class SearchOrdersEvent extends OrderEvent {
  final String shopId;
  final String query;

  const SearchOrdersEvent({
    required this.shopId,
    required this.query,
  });

  @override
  List<Object?> get props => [shopId, query];
}

/// Event to transition workflow status
class TransitionWorkflowEvent extends OrderEvent {
  final String orderId;
  final GarmentStatus newStatus;
  final String userId;
  final String userName;
  final UserRole userRole;
  final String? notes;

  const TransitionWorkflowEvent({
    required this.orderId,
    required this.newStatus,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.notes,
  });

  @override
  List<Object?> get props => [
        orderId,
        newStatus,
        userId,
        userName,
        userRole,
        notes,
      ];
}

/// Event to refresh orders list
class RefreshOrdersEvent extends OrderEvent {
  final String shopId;
  final GarmentStatus status;

  const RefreshOrdersEvent({
    required this.shopId,
    required this.status,
  });

  @override
  List<Object?> get props => [shopId, status];
}

