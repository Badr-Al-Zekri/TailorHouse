import 'package:hive/hive.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'workflow_log_model.g.dart';

/// Hive model for WorkflowLog entity
@HiveType(typeId: 4)
class WorkflowLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderId;

  @HiveField(2)
  final int? fromStatusIndex; // GarmentStatus enum index

  @HiveField(3)
  final int toStatusIndex; // GarmentStatus enum index

  @HiveField(4)
  final String userId;

  @HiveField(5)
  final String userName;

  @HiveField(6)
  final String userRole;

  @HiveField(7)
  final DateTime timestamp;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final String? deviceInfo;

  WorkflowLogModel({
    required this.id,
    required this.orderId,
    this.fromStatusIndex,
    required this.toStatusIndex,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.timestamp,
    this.notes,
    this.deviceInfo,
  });

  /// Convert from domain entity
  factory WorkflowLogModel.fromEntity(WorkflowLog entity) {
    return WorkflowLogModel(
      id: entity.id,
      orderId: entity.orderId,
      fromStatusIndex: entity.fromStatus?.index,
      toStatusIndex: entity.toStatus.index,
      userId: entity.userId,
      userName: entity.userName,
      userRole: entity.userRole,
      timestamp: entity.timestamp,
      notes: entity.notes,
      deviceInfo: entity.deviceInfo,
    );
  }

  /// Convert to domain entity
  WorkflowLog toEntity() {
    return WorkflowLog(
      id: id,
      orderId: orderId,
      fromStatus: fromStatusIndex != null
          ? GarmentStatus.values[fromStatusIndex!]
          : null,
      toStatus: GarmentStatus.values[toStatusIndex],
      userId: userId,
      userName: userName,
      userRole: userRole,
      timestamp: timestamp,
      notes: notes,
      deviceInfo: deviceInfo,
    );
  }
}

