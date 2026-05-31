import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tailorhouse/src/application/application.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'order_event.dart';
part 'order_state.dart';

/// BLoC for managing order-related operations
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final GetOrdersByStatusUseCase _getOrdersByStatusUseCase;
  final SearchOrdersUseCase _searchOrdersUseCase;
  final TransitionWorkflowUseCase _transitionWorkflowUseCase;

  OrderBloc({
    required CreateOrderUseCase createOrderUseCase,
    required GetOrderDetailsUseCase getOrderDetailsUseCase,
    required GetOrdersByStatusUseCase getOrdersByStatusUseCase,
    required SearchOrdersUseCase searchOrdersUseCase,
    required TransitionWorkflowUseCase transitionWorkflowUseCase,
  })  : _createOrderUseCase = createOrderUseCase,
        _getOrderDetailsUseCase = getOrderDetailsUseCase,
        _getOrdersByStatusUseCase = getOrdersByStatusUseCase,
        _searchOrdersUseCase = searchOrdersUseCase,
        _transitionWorkflowUseCase = transitionWorkflowUseCase,
        super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
    on<GetOrdersByStatusEvent>(_onGetOrdersByStatus);
    on<SearchOrdersEvent>(_onSearchOrders);
    on<TransitionWorkflowEvent>(_onTransitionWorkflow);
    on<RefreshOrdersEvent>(_onRefreshOrders);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await _createOrderUseCase.execute(
      CreateOrderInput(
        customerId: event.customerId,
        customerName: event.customerName,
        customerPhone: event.customerPhone,
        garmentType: event.garmentType,
        fabricDescription: event.fabricDescription,
        fabricColor: event.fabricColor,
        totalPrice: event.totalPrice.amount,
        depositPaid: event.depositPaid.amount,
        expectedDeliveryDate: event.expectedDeliveryDate,
        notes: event.notes,
        createdByUserId: event.createdBy,
        createdByUserName: event.createdByName,
        createdByUserRole: event.createdByRole,
      ),
    );

    result.fold(
      onSuccess: (output) => emit(OrderCreated(output.order)),
      onFailure: (failure) => emit(OrderError(failure.message)),
    );
  }

  Future<void> _onGetOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await _getOrderDetailsUseCase.execute(
      GetOrderDetailsInput.byId(event.orderId),
    );

    result.fold(
      onSuccess: (output) => emit(OrderDetailsLoaded(output.order)),
      onFailure: (failure) => emit(OrderError(failure.message)),
    );
  }

  Future<void> _onGetOrdersByStatus(
    GetOrdersByStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await _getOrdersByStatusUseCase.execute(
      GetOrdersByStatusInput(
        shopId: event.shopId,
        status: event.status,
      ),
    );

    result.fold(
      onSuccess: (output) async {
        // Fetch full orders from list items
        final fullOrders = <Order>[];
        for (final item in output.orders) {
          final orderResult = await _getOrderDetailsUseCase.execute(
            GetOrderDetailsInput.byId(item.id),
          );
          orderResult.fold(
            onSuccess: (details) => fullOrders.add(details.order),
            onFailure: (_) {}, // Skip if can't fetch
          );
        }
        emit(OrdersLoaded(fullOrders));
      },
      onFailure: (failure) => emit(OrderError(failure.message)),
    );
  }

  Future<void> _onSearchOrders(
    SearchOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await _searchOrdersUseCase.execute(
      SearchOrdersInput(
        shopId: event.shopId,
        query: event.query,
      ),
    );

    result.fold(
      onSuccess: (output) async {
        // Fetch full orders from list items
        final fullOrders = <Order>[];
        for (final item in output.orders) {
          final orderResult = await _getOrderDetailsUseCase.execute(
            GetOrderDetailsInput.byId(item.id),
          );
          orderResult.fold(
            onSuccess: (details) => fullOrders.add(details.order),
            onFailure: (_) {}, // Skip if can't fetch
          );
        }
        emit(OrdersLoaded(fullOrders));
      },
      onFailure: (failure) => emit(OrderError(failure.message)),
    );
  }

  Future<void> _onTransitionWorkflow(
    TransitionWorkflowEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await _transitionWorkflowUseCase.execute(
      TransitionWorkflowInput(
        orderId: event.orderId,
        targetStatus: event.newStatus,
        userId: event.userId,
        userName: event.userName,
        userRole: event.userRole,
        notes: event.notes,
      ),
    );

    result.fold(
      onSuccess: (output) => emit(WorkflowTransitioned(output.updatedOrder)),
      onFailure: (failure) => emit(OrderError(failure.message)),
    );
  }

  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    add(GetOrdersByStatusEvent(
      shopId: event.shopId,
      status: event.status,
    ));
  }
}
