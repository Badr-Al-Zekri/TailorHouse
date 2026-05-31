import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/workflow_log_model.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/workflow_log_local_datasource.dart';

/// Implementation of WorkflowLogRepository using local storage
class WorkflowLogRepositoryImpl implements WorkflowLogRepository {
  final WorkflowLogLocalDataSource _localDataSource;

  WorkflowLogRepositoryImpl({required WorkflowLogLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<WorkflowLog> create(WorkflowLog log) async {
    final model = WorkflowLogModel.fromEntity(log);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<List<WorkflowLog>> getByOrderId(String orderId) async {
    final models = _localDataSource.getByOrderId(orderId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<WorkflowLog>> getByTransition(
    String shopId,
    GarmentStatus fromStatus,
    GarmentStatus toStatus,
  ) async {
    final models = _localDataSource.getByTransition(shopId, fromStatus, toStatus);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<WorkflowLog>> getByUserId(String userId) async {
    final models = _localDataSource.getByUserId(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<WorkflowLog>> getByDateRange(
    String shopId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final models = _localDataSource.getByDateRange(startDate, endDate);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<WorkflowLog>> getRecentActivity(
    String shopId, {
    int limit = 20,
  }) async {
    final models = _localDataSource.getRecentActivity(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
}

