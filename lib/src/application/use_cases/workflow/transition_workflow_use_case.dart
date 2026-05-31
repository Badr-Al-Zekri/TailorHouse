import 'package:tailorhouse/src/application/common/use_case.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Input for transitioning order to next workflow stage
class TransitionWorkflowInput {
  final String orderId;
  
  /// Target status (must be the immediate next status)
  final GarmentStatus targetStatus;

  /// User performing the transition
  final String userId;
  final String userName;
  final UserRole userRole;

  /// Optional notes for this transition
  final String? notes;

  /// Device info for audit
  final String? deviceInfo;

  const TransitionWorkflowInput({
    required this.orderId,
    required this.targetStatus,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.notes,
    this.deviceInfo,
  });
}

/// Output after workflow transition
class TransitionWorkflowOutput {
  final Order updatedOrder;
  final GarmentStatus previousStatus;
  final GarmentStatus newStatus;
  final WorkflowLog transitionLog;
  final bool isComplete;
  final GarmentStatus? nextAvailableStatus;

  const TransitionWorkflowOutput({
    required this.updatedOrder,
    required this.previousStatus,
    required this.newStatus,
    required this.transitionLog,
    required this.isComplete,
    this.nextAvailableStatus,
  });
}

/// Use case for transitioning an order through the workflow
/// 
/// Business Rules Enforced:
/// - Only sequential transitions (no skipping)
/// - User must have permission for this transition
/// - Pre-conditions must be met (e.g., measurements for MEASURED)
/// - Every transition is logged
class TransitionWorkflowUseCase implements UseCase<TransitionWorkflowInput, Result<TransitionWorkflowOutput>> {
  final OrderRepository _orderRepository;
  final WorkflowLogRepository _workflowLogRepository;
  final WorkflowStateMachine _workflowStateMachine;

  TransitionWorkflowUseCase({
    required OrderRepository orderRepository,
    required WorkflowLogRepository workflowLogRepository,
    WorkflowStateMachine? workflowStateMachine,
  })  : _orderRepository = orderRepository,
        _workflowLogRepository = workflowLogRepository,
        _workflowStateMachine = workflowStateMachine ?? const WorkflowStateMachine();

  @override
  Future<Result<TransitionWorkflowOutput>> execute(TransitionWorkflowInput input) async {
    try {
      // 1. Get order
      final order = await _orderRepository.getById(input.orderId);
      if (order == null) {
        return Result.failure(NotFoundFailure(
          entityType: 'Order',
          entityId: input.orderId,
        ));
      }

      // 2. Validate transition using state machine
      final validationError = _workflowStateMachine.validateTransition(
        order: order,
        targetStatus: input.targetStatus,
        userRole: input.userRole,
      );

      if (validationError != null) {
        return Result.failure(WorkflowFailure(
          message: validationError,
          arabicMessage: _translateWorkflowError(validationError),
        ));
      }

      // 3. Store previous status for output
      final previousStatus = order.status;

      // 4. Perform transition
      final updatedOrder = order.transitionTo(
        newStatus: input.targetStatus,
        userId: input.userId,
        userName: input.userName,
        userRole: input.userRole.englishName,
        notes: input.notes,
        deviceInfo: input.deviceInfo,
      );

      // 5. Persist order
      final savedOrder = await _orderRepository.update(updatedOrder);

      // 6. Get the new workflow log (last entry)
      final transitionLog = savedOrder.workflowLogs.last;

      // 7. Persist workflow log separately (for querying)
      await _workflowLogRepository.create(transitionLog);

      return Result.success(TransitionWorkflowOutput(
        updatedOrder: savedOrder,
        previousStatus: previousStatus,
        newStatus: input.targetStatus,
        transitionLog: transitionLog,
        isComplete: savedOrder.isComplete,
        nextAvailableStatus: _workflowStateMachine.getNextStatus(savedOrder),
      ));
    } on DomainException catch (e) {
      return Result.failure(Failure(
        message: e.message,
        arabicMessage: e.arabicMessage,
        originalError: e,
      ));
    } catch (e) {
      return Result.failure(StorageFailure(
        message: 'Failed to transition workflow: $e',
        arabicMessage: 'فشل في تحديث حالة الطلب',
      ));
    }
  }

  String _translateWorkflowError(String error) {
    if (error.contains('Cannot transition')) {
      return 'لا يمكن الانتقال إلى هذه الحالة';
    }
    if (error.contains('not authorized')) {
      return 'ليس لديك صلاحية لتنفيذ هذا الإجراء';
    }
    if (error.contains('Measurements must be recorded')) {
      return 'يجب تسجيل القياسات أولاً';
    }
    return 'خطأ في سير العمل';
  }
}

/// Convenience use case for moving to the next status
class MoveToNextStatusUseCase implements UseCase<MoveToNextStatusInput, Result<TransitionWorkflowOutput>> {
  final TransitionWorkflowUseCase _transitionUseCase;
  final OrderRepository _orderRepository;

  MoveToNextStatusUseCase({
    required TransitionWorkflowUseCase transitionUseCase,
    required OrderRepository orderRepository,
  })  : _transitionUseCase = transitionUseCase,
        _orderRepository = orderRepository;

  @override
  Future<Result<TransitionWorkflowOutput>> execute(MoveToNextStatusInput input) async {
    // Get order to determine next status
    final order = await _orderRepository.getById(input.orderId);
    if (order == null) {
      return Result.failure(NotFoundFailure(
        entityType: 'Order',
        entityId: input.orderId,
      ));
    }

    final nextStatus = order.status.nextStatus;
    if (nextStatus == null) {
      return Result.failure(WorkflowFailure(
        message: 'Order is already at final status',
        arabicMessage: 'الطلب في الحالة النهائية بالفعل',
      ));
    }

    return _transitionUseCase.execute(TransitionWorkflowInput(
      orderId: input.orderId,
      targetStatus: nextStatus,
      userId: input.userId,
      userName: input.userName,
      userRole: input.userRole,
      notes: input.notes,
      deviceInfo: input.deviceInfo,
    ));
  }
}

class MoveToNextStatusInput {
  final String orderId;
  final String userId;
  final String userName;
  final UserRole userRole;
  final String? notes;
  final String? deviceInfo;

  const MoveToNextStatusInput({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.notes,
    this.deviceInfo,
  });
}

