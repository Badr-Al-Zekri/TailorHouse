import 'package:tailorhouse/src/infrastructure/models/workflow_log_model.dart';
import 'package:tailorhouse/src/infrastructure/services/storage_service.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Local data source for WorkflowLog operations
class WorkflowLogLocalDataSource {
  final StorageService _storageService;

  WorkflowLogLocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Save a workflow log
  Future<WorkflowLogModel> save(WorkflowLogModel log) async {
    await _storageService.workflowLogsBox.put(log.id, log);
    return log;
  }

  /// Get all logs for an order
  List<WorkflowLogModel> getByOrderId(String orderId) {
    return _storageService.workflowLogsBox.values
        .where((log) => log.orderId == orderId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Get logs by transition
  List<WorkflowLogModel> getByTransition(
    String shopId,
    GarmentStatus fromStatus,
    GarmentStatus toStatus,
  ) {
    // Note: We need to join with orders to filter by shop
    // For now, we get all logs with this transition
    return _storageService.workflowLogsBox.values
        .where((log) =>
            log.fromStatusIndex == fromStatus.index &&
            log.toStatusIndex == toStatus.index)
        .toList();
  }

  /// Get logs by user
  List<WorkflowLogModel> getByUserId(String userId) {
    return _storageService.workflowLogsBox.values
        .where((log) => log.userId == userId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get logs within date range
  List<WorkflowLogModel> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _storageService.workflowLogsBox.values
        .where((log) =>
            log.timestamp.isAfter(startDate) &&
            log.timestamp.isBefore(endDate))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get recent activity
  List<WorkflowLogModel> getRecentActivity({int limit = 20}) {
    final logs = _storageService.workflowLogsBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs.take(limit).toList();
  }
}

