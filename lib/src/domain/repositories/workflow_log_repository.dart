import 'package:tailorhouse/src/domain/entities/workflow_log.dart';
import 'package:tailorhouse/src/domain/enums/garment_status.dart';

/// Workflow Log Repository Interface
/// 
/// Defines the contract for workflow log persistence.
/// Logs are immutable - only create and read operations.
abstract class WorkflowLogRepository {
  /// Create a new workflow log entry
  Future<WorkflowLog> create(WorkflowLog log);

  /// Get all logs for an order
  Future<List<WorkflowLog>> getByOrderId(String orderId);

  /// Get logs for a specific status transition
  Future<List<WorkflowLog>> getByTransition(
    String shopId,
    GarmentStatus fromStatus,
    GarmentStatus toStatus,
  );

  /// Get logs by user (for audit)
  Future<List<WorkflowLog>> getByUserId(String userId);

  /// Get logs within a date range
  Future<List<WorkflowLog>> getByDateRange(
    String shopId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get recent activity (for dashboard)
  Future<List<WorkflowLog>> getRecentActivity(String shopId, {int limit = 20});
}

