import 'package:tailorhouse/src/domain/enums/garment_status.dart';
import 'package:tailorhouse/src/domain/enums/garment_type.dart';
import 'package:tailorhouse/src/domain/value_objects/garment_id.dart';
import 'package:tailorhouse/src/domain/value_objects/money.dart';
import 'package:tailorhouse/src/domain/entities/measurement.dart';
import 'package:tailorhouse/src/domain/entities/workflow_log.dart';
import 'package:tailorhouse/src/domain/exceptions/domain_exceptions.dart';

/// Order entity - the core business object
/// 
/// Represents a customer's order for a tailored garment.
/// Contains all information needed to track the garment through the workflow.
class Order {
  /// Unique internal identifier (UUID)
  final String id;

  /// Human-readable garment identifier
  /// Format: SHOP_CODE-YY-SEQUENCE (e.g., TF01-25-00458)
  final GarmentId garmentId;

  /// Shop this order belongs to
  final String shopId;

  /// Customer who placed the order
  final String customerId;

  /// Customer name (denormalized for quick display)
  final String customerName;

  /// Customer phone (denormalized for quick contact)
  final String customerPhone;

  /// Type of garment being made
  final GarmentType garmentType;

  /// Description of the fabric
  final String fabricDescription;

  /// Optional fabric color
  final String? fabricColor;

  /// Total price for the order
  final Money totalPrice;

  /// Deposit amount paid
  final Money depositPaid;

  /// Current workflow status
  final GarmentStatus status;

  /// Expected delivery date
  final DateTime expectedDeliveryDate;

  /// Actual delivery date (null until delivered)
  final DateTime? actualDeliveryDate;

  /// Associated measurement (null until measured)
  final Measurement? measurement;

  /// Workflow history
  final List<WorkflowLog> workflowLogs;

  /// Special instructions or notes
  final String? notes;

  /// When the order was created
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Who created the order
  final String createdBy;

  const Order({
    required this.id,
    required this.garmentId,
    required this.shopId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.garmentType,
    required this.fabricDescription,
    this.fabricColor,
    required this.totalPrice,
    required this.depositPaid,
    required this.status,
    required this.expectedDeliveryDate,
    this.actualDeliveryDate,
    this.measurement,
    required this.workflowLogs,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /// Create a new order (initial status: CREATED)
  factory Order.create({
    required String id,
    required GarmentId garmentId,
    required String shopId,
    required String customerId,
    required String customerName,
    required String customerPhone,
    required GarmentType garmentType,
    required String fabricDescription,
    String? fabricColor,
    required Money totalPrice,
    required Money depositPaid,
    required DateTime expectedDeliveryDate,
    String? notes,
    required String createdBy,
    required String createdByName,
    required String createdByRole,
  }) {
    // Validate deposit doesn't exceed total
    if (depositPaid > totalPrice) {
      throw InvalidOrderException(
        'Deposit cannot exceed total price',
        field: 'depositPaid',
      );
    }

    // Validate expected delivery is in the future
    if (expectedDeliveryDate.isBefore(DateTime.now())) {
      throw InvalidOrderException(
        'Expected delivery date must be in the future',
        field: 'expectedDeliveryDate',
      );
    }

    final now = DateTime.now();
    
    // Create initial workflow log
    final initialLog = WorkflowLog.create(
      id: '${id}_log_0',
      orderId: id,
      fromStatus: null,
      toStatus: GarmentStatus.created,
      userId: createdBy,
      userName: createdByName,
      userRole: createdByRole,
      notes: 'Order created',
    );

    return Order(
      id: id,
      garmentId: garmentId,
      shopId: shopId,
      customerId: customerId,
      customerName: customerName.trim(),
      customerPhone: customerPhone,
      garmentType: garmentType,
      fabricDescription: fabricDescription.trim(),
      fabricColor: fabricColor?.trim(),
      totalPrice: totalPrice,
      depositPaid: depositPaid,
      status: GarmentStatus.created,
      expectedDeliveryDate: expectedDeliveryDate,
      actualDeliveryDate: null,
      measurement: null,
      workflowLogs: [initialLog],
      notes: notes?.trim(),
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
    );
  }

  // ============================================
  // Business Logic - Status Transitions
  // ============================================

  /// Check if the order can transition to a specific status
  bool canTransitionTo(GarmentStatus targetStatus) {
    return status.canTransitionTo(targetStatus);
  }

  /// Transition to the next status
  /// 
  /// Business Rules:
  /// - Must transition to IMMEDIATE next status only
  /// - Skipping is NOT allowed
  /// - Every transition must be logged
  Order transitionTo({
    required GarmentStatus newStatus,
    required String userId,
    required String userName,
    required String userRole,
    String? notes,
    String? deviceInfo,
  }) {
    // Validate the transition is allowed
    if (!canTransitionTo(newStatus)) {
      throw InvalidWorkflowTransitionException(
        fromStatus: status.englishName,
        toStatus: newStatus.englishName,
      );
    }

    // Special validation for MEASURED status
    if (newStatus == GarmentStatus.measured && measurement == null) {
      throw WorkflowOperationNotPermittedException(
        operation: 'Transition to MEASURED',
        reason: 'Measurements must be recorded first',
      );
    }

    // Create the workflow log
    final log = WorkflowLog.create(
      id: '${id}_log_${workflowLogs.length}',
      orderId: id,
      fromStatus: status,
      toStatus: newStatus,
      userId: userId,
      userName: userName,
      userRole: userRole,
      notes: notes,
      deviceInfo: deviceInfo,
    );

    // Handle delivery timestamp
    DateTime? deliveryDate = actualDeliveryDate;
    if (newStatus == GarmentStatus.delivered) {
      deliveryDate = DateTime.now();
    }

    return _copyWith(
      status: newStatus,
      actualDeliveryDate: deliveryDate,
      workflowLogs: [...workflowLogs, log],
      updatedAt: DateTime.now(),
    );
  }

  /// Add measurement to the order
  Order addMeasurement(Measurement newMeasurement) {
    if (status != GarmentStatus.created) {
      throw WorkflowOperationNotPermittedException(
        operation: 'Add measurement',
        reason: 'Measurements can only be added in CREATED status',
      );
    }

    // Validate measurements for garment type
    newMeasurement.validateForGarmentType(garmentType);

    return _copyWith(
      measurement: newMeasurement,
      updatedAt: DateTime.now(),
    );
  }

  // ============================================
  // Computed Properties
  // ============================================

  /// Amount remaining to be paid
  Money get remainingBalance => totalPrice - depositPaid;

  /// Check if fully paid
  bool get isFullyPaid => depositPaid >= totalPrice;

  /// Check if order is complete (delivered)
  bool get isComplete => status == GarmentStatus.delivered;

  /// Check if order is still in progress
  bool get isInProgress => status.isInProgress;

  /// Get progress percentage
  double get progressPercentage => status.progressPercentage;

  /// Check if order is overdue
  bool get isOverdue {
    if (isComplete) return false;
    return DateTime.now().isAfter(expectedDeliveryDate);
  }

  /// Days until expected delivery (negative if overdue)
  int get daysUntilDelivery {
    return expectedDeliveryDate.difference(DateTime.now()).inDays;
  }

  /// Get the last workflow log entry
  WorkflowLog get lastWorkflowLog => workflowLogs.last;

  /// Get when the current status was entered
  DateTime get statusEnteredAt => lastWorkflowLog.timestamp;

  /// Check if measurements have been recorded
  bool get hasMeasurements => measurement != null;

  // ============================================
  // Update Methods
  // ============================================

  /// Update order details (only allowed before cutting starts)
  Order updateDetails({
    String? fabricDescription,
    String? fabricColor,
    Money? totalPrice,
    Money? depositPaid,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) {
    // Can only update in early stages
    if (status.order > GarmentStatus.measured.order) {
      throw OrderCannotBeModifiedException(
        orderId: garmentId.toString(),
        reason: 'Order is already in ${status.englishName} stage',
      );
    }

    final newTotalPrice = totalPrice ?? this.totalPrice;
    final newDeposit = depositPaid ?? this.depositPaid;

    if (newDeposit > newTotalPrice) {
      throw InvalidOrderException(
        'Deposit cannot exceed total price',
        field: 'depositPaid',
      );
    }

    return _copyWith(
      fabricDescription: fabricDescription?.trim(),
      fabricColor: fabricColor?.trim(),
      totalPrice: newTotalPrice,
      depositPaid: newDeposit,
      expectedDeliveryDate: expectedDeliveryDate,
      notes: notes?.trim(),
      updatedAt: DateTime.now(),
    );
  }

  /// Record additional payment
  Order recordPayment(Money amount) {
    final newDeposit = depositPaid + amount;
    if (newDeposit > totalPrice) {
      throw InvalidOrderException(
        'Payment would exceed total price',
        field: 'depositPaid',
      );
    }

    return _copyWith(
      depositPaid: newDeposit,
      updatedAt: DateTime.now(),
    );
  }

  // ============================================
  // Private Helper
  // ============================================

  Order _copyWith({
    GarmentStatus? status,
    DateTime? expectedDeliveryDate,
    DateTime? actualDeliveryDate,
    Measurement? measurement,
    List<WorkflowLog>? workflowLogs,
    String? fabricDescription,
    String? fabricColor,
    Money? totalPrice,
    Money? depositPaid,
    String? notes,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id,
      garmentId: garmentId,
      shopId: shopId,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      garmentType: garmentType,
      fabricDescription: fabricDescription ?? this.fabricDescription,
      fabricColor: fabricColor ?? this.fabricColor,
      totalPrice: totalPrice ?? this.totalPrice,
      depositPaid: depositPaid ?? this.depositPaid,
      status: status ?? this.status,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate ?? this.actualDeliveryDate,
      measurement: measurement ?? this.measurement,
      workflowLogs: workflowLogs ?? this.workflowLogs,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Order(${garmentId.toString()}, $status)';
}

