import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for getting order details
class GetOrderDetailsInput {
  /// Can be either the internal ID or the garment ID string
  final String orderIdentifier;
  
  /// If true, search by garment ID (e.g., "TF01-25-00001")
  /// If false, search by internal ID
  final bool searchByGarmentId;

  const GetOrderDetailsInput({
    required this.orderIdentifier,
    this.searchByGarmentId = false,
  });

  /// Create input for searching by garment ID
  factory GetOrderDetailsInput.byGarmentId(String garmentId) {
    return GetOrderDetailsInput(
      orderIdentifier: garmentId,
      searchByGarmentId: true,
    );
  }

  /// Create input for searching by internal ID
  factory GetOrderDetailsInput.byId(String id) {
    return GetOrderDetailsInput(
      orderIdentifier: id,
      searchByGarmentId: false,
    );
  }
}

/// Detailed output with order and workflow info
class GetOrderDetailsOutput {
  final Order order;
  final String garmentIdDisplay;
  final List<WorkflowStageInfo> workflowStages;
  final GarmentStatus? nextAvailableStatus;
  final bool isOverdue;
  final int daysUntilDelivery;
  final double progressPercentage;

  const GetOrderDetailsOutput({
    required this.order,
    required this.garmentIdDisplay,
    required this.workflowStages,
    this.nextAvailableStatus,
    required this.isOverdue,
    required this.daysUntilDelivery,
    required this.progressPercentage,
  });
}

/// Use case for getting order details
/// 
/// Supports lookup by:
/// - Internal order ID
/// - Human-readable garment ID (e.g., "TF01-25-00001")
class GetOrderDetailsUseCase implements UseCase<GetOrderDetailsInput, Result<GetOrderDetailsOutput>> {
  final OrderRepository _orderRepository;
  final WorkflowStateMachine _workflowStateMachine;

  GetOrderDetailsUseCase({
    required OrderRepository orderRepository,
    WorkflowStateMachine? workflowStateMachine,
  })  : _orderRepository = orderRepository,
        _workflowStateMachine = workflowStateMachine ?? const WorkflowStateMachine();

  @override
  Future<Result<GetOrderDetailsOutput>> execute(GetOrderDetailsInput input) async {
    try {
      // 1. Get order
      Order? order;
      if (input.searchByGarmentId) {
        order = await _orderRepository.getByGarmentId(input.orderIdentifier);
      } else {
        order = await _orderRepository.getById(input.orderIdentifier);
      }

      if (order == null) {
        return Result.failure(NotFoundFailure(
          entityType: 'Order',
          entityId: input.orderIdentifier,
        ));
      }

      // 2. Get workflow stages info
      final workflowStages = _workflowStateMachine.getWorkflowStages(order);

      // 3. Get next available status
      final nextStatus = _workflowStateMachine.getNextStatus(order);

      return Result.success(GetOrderDetailsOutput(
        order: order,
        garmentIdDisplay: order.garmentId.toString(),
        workflowStages: workflowStages,
        nextAvailableStatus: nextStatus,
        isOverdue: order.isOverdue,
        daysUntilDelivery: order.daysUntilDelivery,
        progressPercentage: order.progressPercentage,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to get order details: $e',
        arabicMessage: 'فشل في جلب تفاصيل الطلب',
      ));
    }
  }
}

