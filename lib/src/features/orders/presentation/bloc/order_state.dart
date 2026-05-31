part of 'order_bloc.dart';

/// Base class for order states
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OrderInitial extends OrderState {}

/// Loading state
class OrderLoading extends OrderState {}

/// State when orders are loaded
class OrdersLoaded extends OrderState {
  final List<Order> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

/// State when order details are loaded
class OrderDetailsLoaded extends OrderState {
  final Order order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

/// State when order is created
class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated(this.order);

  @override
  List<Object?> get props => [order];
}

/// State when workflow is transitioned
class WorkflowTransitioned extends OrderState {
  final Order order;

  const WorkflowTransitioned(this.order);

  @override
  List<Object?> get props => [order];
}

/// Error state
class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

