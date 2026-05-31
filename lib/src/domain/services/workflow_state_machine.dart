import 'package:tailorhouse/src/domain/enums/garment_status.dart';
import 'package:tailorhouse/src/domain/enums/user_role.dart';
import 'package:tailorhouse/src/domain/entities/order.dart';

/// Workflow State Machine - Enforces strict workflow rules
/// 
/// This service encapsulates all workflow transition logic.
/// It ensures:
/// - Only valid transitions are allowed
/// - No stages are skipped
/// - Users have permission for transitions
/// - Pre-conditions are met (e.g., measurements exist)
class WorkflowStateMachine {
  const WorkflowStateMachine();

  /// Validate if a transition is allowed
  /// 
  /// Returns null if valid, error message if invalid
  String? validateTransition({
    required Order order,
    required GarmentStatus targetStatus,
    required UserRole userRole,
  }) {
    // Check if transition is structurally valid
    if (!order.status.canTransitionTo(targetStatus)) {
      return 'Cannot transition from ${order.status.englishName} to ${targetStatus.englishName}. '
          'Must follow strict order: ${_getWorkflowPath()}';
    }

    // Check user permission
    if (!_userCanPerformTransition(userRole, order.status, targetStatus)) {
      return 'User role ${userRole.englishName} is not authorized to perform this transition';
    }

    // Check pre-conditions
    final preConditionError = _checkPreConditions(order, targetStatus);
    if (preConditionError != null) {
      return preConditionError;
    }

    return null;
  }

  /// Check if a specific transition is allowed
  bool isTransitionAllowed({
    required Order order,
    required GarmentStatus targetStatus,
    required UserRole userRole,
  }) {
    return validateTransition(
      order: order,
      targetStatus: targetStatus,
      userRole: userRole,
    ) == null;
  }

  /// Get the next allowed status for an order
  GarmentStatus? getNextStatus(Order order) {
    return order.status.nextStatus;
  }

  /// Get all available transitions for a user role
  List<GarmentStatus> getAvailableTransitions({
    required Order order,
    required UserRole userRole,
  }) {
    final nextStatus = order.status.nextStatus;
    if (nextStatus == null) return [];

    if (isTransitionAllowed(
      order: order,
      targetStatus: nextStatus,
      userRole: userRole,
    )) {
      return [nextStatus];
    }

    return [];
  }

  /// Check if user role can perform a specific transition
  bool _userCanPerformTransition(
    UserRole role,
    GarmentStatus fromStatus,
    GarmentStatus toStatus,
  ) {
    // Owner and staff can do any transition
    if (role == UserRole.owner || role == UserRole.staff) {
      return true;
    }

    // Workers can only perform their assigned transitions
    final transition = _getTransitionEnum(fromStatus, toStatus);
    if (transition == null) return false;

    return role.canPerformTransition(transition);
  }

  /// Get the GarmentStatusTransition enum for a transition
  GarmentStatusTransition? _getTransitionEnum(
    GarmentStatus from,
    GarmentStatus to,
  ) {
    if (from == GarmentStatus.created && to == GarmentStatus.measured) {
      return GarmentStatusTransition.createdToMeasured;
    }
    if (from == GarmentStatus.measured && to == GarmentStatus.cutting) {
      return GarmentStatusTransition.measuredToCutting;
    }
    if (from == GarmentStatus.cutting && to == GarmentStatus.sewing) {
      return GarmentStatusTransition.cuttingToSewing;
    }
    if (from == GarmentStatus.sewing && to == GarmentStatus.buttoning) {
      return GarmentStatusTransition.sewingToButtoning;
    }
    if (from == GarmentStatus.buttoning && to == GarmentStatus.ironing) {
      return GarmentStatusTransition.buttoningToIroning;
    }
    if (from == GarmentStatus.ironing && to == GarmentStatus.ready) {
      return GarmentStatusTransition.ironingToReady;
    }
    if (from == GarmentStatus.ready && to == GarmentStatus.delivered) {
      return GarmentStatusTransition.readyToDelivered;
    }
    return null;
  }

  /// Check pre-conditions for a transition
  String? _checkPreConditions(Order order, GarmentStatus targetStatus) {
    switch (targetStatus) {
      case GarmentStatus.measured:
        if (!order.hasMeasurements) {
          return 'Measurements must be recorded before transitioning to MEASURED';
        }
        break;
      case GarmentStatus.delivered:
        if (!order.isFullyPaid) {
          // This is a warning, not a hard block - shop may allow delivery with remaining balance
          // return 'Order has remaining balance of ${order.remainingBalance}';
        }
        break;
      default:
        break;
    }
    return null;
  }

  /// Get the complete workflow path as string
  String _getWorkflowPath() {
    return GarmentStatus.values.map((s) => s.englishName).join(' → ');
  }

  /// Get workflow stage information for display
  List<WorkflowStageInfo> getWorkflowStages(Order order) {
    return GarmentStatus.values.map((status) {
      return WorkflowStageInfo(
        status: status,
        isCompleted: status.order < order.status.order,
        isCurrent: status == order.status,
        isPending: status.order > order.status.order,
        completedAt: _getCompletionTime(order, status),
        completedBy: _getCompletedBy(order, status),
      );
    }).toList();
  }

  DateTime? _getCompletionTime(Order order, GarmentStatus status) {
    for (final log in order.workflowLogs) {
      if (log.toStatus == status) {
        return log.timestamp;
      }
    }
    return null;
  }

  String? _getCompletedBy(Order order, GarmentStatus status) {
    for (final log in order.workflowLogs) {
      if (log.toStatus == status) {
        return log.userName;
      }
    }
    return null;
  }
}

/// Information about a workflow stage
class WorkflowStageInfo {
  final GarmentStatus status;
  final bool isCompleted;
  final bool isCurrent;
  final bool isPending;
  final DateTime? completedAt;
  final String? completedBy;

  const WorkflowStageInfo({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    required this.isPending,
    this.completedAt,
    this.completedBy,
  });

  /// Get stage name in Arabic
  String get arabicName => status.arabicName;

  /// Get stage name in English
  String get englishName => status.englishName;

  /// Get stage number (1-based)
  int get stageNumber => status.order + 1;

  /// Total number of stages
  static int get totalStages => GarmentStatus.values.length;
}

