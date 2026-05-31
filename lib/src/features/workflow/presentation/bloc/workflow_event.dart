part of 'workflow_bloc.dart';

/// Base class for workflow events
abstract class WorkflowEvent extends Equatable {
  const WorkflowEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get worker queue
class GetWorkerQueueEvent extends WorkflowEvent {
  final String shopId;
  final UserRole workerRole;

  const GetWorkerQueueEvent({
    required this.shopId,
    required this.workerRole,
  });

  @override
  List<Object?> get props => [shopId, workerRole];
}

/// Event to transition workflow status
class TransitionWorkflowEvent extends WorkflowEvent {
  final String orderId;
  final GarmentStatus targetStatus;
  final String userId;
  final String userName;
  final UserRole userRole;
  final String? notes;

  const TransitionWorkflowEvent({
    required this.orderId,
    required this.targetStatus,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.notes,
  });

  @override
  List<Object?> get props => [
        orderId,
        targetStatus,
        userId,
        userName,
        userRole,
        notes,
      ];
}

/// Event to move to next status
class MoveToNextStatusEvent extends WorkflowEvent {
  final String orderId;
  final GarmentStatus nextStatus;
  final String userId;
  final String userName;
  final UserRole userRole;
  final String? notes;

  const MoveToNextStatusEvent({
    required this.orderId,
    required this.nextStatus,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.notes,
  });

  @override
  List<Object?> get props => [
        orderId,
        nextStatus,
        userId,
        userName,
        userRole,
        notes,
      ];
}

