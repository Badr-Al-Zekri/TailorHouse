import 'package:tailorhouse/src/domain/enums/garment_status.dart';

/// Workflow log entry
/// 
/// Records every state transition for audit and tracking.
/// This is an immutable record - once created, it never changes.
/// 
/// Business Rule: Every transition MUST be logged.
class WorkflowLog {
  /// Unique identifier
  final String id;

  /// Order ID this log belongs to
  final String orderId;

  /// Previous status (null for initial creation)
  final GarmentStatus? fromStatus;

  /// New status after transition
  final GarmentStatus toStatus;

  /// User who performed the transition
  final String userId;

  /// User's name at time of transition (for display)
  final String userName;

  /// User's role at time of transition
  final String userRole;

  /// When the transition occurred
  final DateTime timestamp;

  /// Optional notes for this transition
  final String? notes;

  /// Device/location info (optional, for audit)
  final String? deviceInfo;

  const WorkflowLog({
    required this.id,
    required this.orderId,
    this.fromStatus,
    required this.toStatus,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.timestamp,
    this.notes,
    this.deviceInfo,
  });

  /// Create a new workflow log entry
  factory WorkflowLog.create({
    required String id,
    required String orderId,
    GarmentStatus? fromStatus,
    required GarmentStatus toStatus,
    required String userId,
    required String userName,
    required String userRole,
    String? notes,
    String? deviceInfo,
  }) {
    return WorkflowLog(
      id: id,
      orderId: orderId,
      fromStatus: fromStatus,
      toStatus: toStatus,
      userId: userId,
      userName: userName,
      userRole: userRole,
      timestamp: DateTime.now(),
      notes: notes?.trim(),
      deviceInfo: deviceInfo,
    );
  }

  /// Check if this is the initial creation log
  bool get isInitialCreation => fromStatus == null;

  /// Get the transition description in English
  String get transitionDescriptionEnglish {
    if (isInitialCreation) {
      return 'Order created';
    }
    return '${fromStatus!.englishName} → ${toStatus.englishName}';
  }

  /// Get the transition description in Arabic
  String get transitionDescriptionArabic {
    if (isInitialCreation) {
      return 'تم إنشاء الطلب';
    }
    return '${fromStatus!.arabicName} ← ${toStatus.arabicName}';
  }

  /// Get formatted timestamp for display
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Get duration since this log entry (for "X minutes ago" display)
  Duration get timeSince => DateTime.now().difference(timestamp);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkflowLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WorkflowLog($id, $transitionDescriptionEnglish)';
}

