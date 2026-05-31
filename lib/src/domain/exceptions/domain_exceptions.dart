/// Base class for all domain exceptions
/// 
/// Domain exceptions represent business rule violations
/// and are independent of infrastructure concerns.
abstract class DomainException implements Exception {
  final String message;
  final String arabicMessage;

  const DomainException({
    required this.message,
    required this.arabicMessage,
  });

  @override
  String toString() => 'DomainException: $message';
}

// ============================================
// Garment ID Exceptions
// ============================================

/// Thrown when a garment ID is invalid
class InvalidGarmentIdException extends DomainException {
  final String invalidValue;

  const InvalidGarmentIdException(String message, {required this.invalidValue})
      : super(
          message: message,
          arabicMessage: 'معرّف الثوب غير صالح: $message',
        );
}

/// Thrown when garment ID sequence is exhausted for a year
class GarmentIdSequenceExhaustedException extends DomainException {
  final String shopCode;
  final int year;

  GarmentIdSequenceExhaustedException({
    required this.shopCode,
    required this.year,
  }) : super(
          message: 'Garment ID sequence exhausted for $shopCode in year $year',
          arabicMessage: 'تم استنفاد تسلسل معرّفات الأثواب للمحل $shopCode في سنة $year',
        );
}

// ============================================
// Workflow Exceptions
// ============================================

/// Thrown when attempting an invalid workflow transition
class InvalidWorkflowTransitionException extends DomainException {
  final String fromStatus;
  final String toStatus;

  InvalidWorkflowTransitionException({
    required this.fromStatus,
    required this.toStatus,
  }) : super(
          message: 'Cannot transition from $fromStatus to $toStatus',
          arabicMessage: 'لا يمكن الانتقال من $fromStatus إلى $toStatus',
        );
}

/// Thrown when a workflow operation is not permitted
class WorkflowOperationNotPermittedException extends DomainException {
  final String operation;
  final String reason;

  WorkflowOperationNotPermittedException({
    required this.operation,
    required this.reason,
  }) : super(
          message: '$operation not permitted: $reason',
          arabicMessage: 'العملية غير مسموحة: $reason',
        );
}

// ============================================
// Measurement Exceptions
// ============================================

/// Thrown when a measurement value is invalid
class InvalidMeasurementException extends DomainException {
  final double invalidValue;

  const InvalidMeasurementException(String message, this.invalidValue)
      : super(
          message: message,
          arabicMessage: 'قيمة القياس غير صالحة: $message',
        );
}

/// Thrown when required measurements are missing
class MissingRequiredMeasurementsException extends DomainException {
  final List<String> missingMeasurements;

  MissingRequiredMeasurementsException(this.missingMeasurements)
      : super(
          message: 'Missing required measurements: ${missingMeasurements.join(", ")}',
          arabicMessage: 'قياسات مطلوبة ناقصة: ${missingMeasurements.join("، ")}',
        );
}

// ============================================
// Money Exceptions
// ============================================

/// Thrown when a money amount is invalid
class InvalidMoneyException extends DomainException {
  final double invalidAmount;

  const InvalidMoneyException(String message, this.invalidAmount)
      : super(
          message: message,
          arabicMessage: 'مبلغ غير صالح: $message',
        );
}

/// Thrown when currencies don't match
class CurrencyMismatchException extends DomainException {
  final String currency1;
  final String currency2;

  CurrencyMismatchException(this.currency1, this.currency2)
      : super(
          message: 'Currency mismatch: $currency1 vs $currency2',
          arabicMessage: 'عملات غير متطابقة: $currency1 و $currency2',
        );
}

// ============================================
// Phone Number Exceptions
// ============================================

/// Thrown when a phone number is invalid
class InvalidPhoneNumberException extends DomainException {
  final String invalidInput;

  const InvalidPhoneNumberException(String message, this.invalidInput)
      : super(
          message: message,
          arabicMessage: 'رقم الهاتف غير صالح: $message',
        );
}

// ============================================
// Order Exceptions
// ============================================

/// Thrown when order validation fails
class InvalidOrderException extends DomainException {
  final String field;

  const InvalidOrderException(String message, {required this.field})
      : super(
          message: message,
          arabicMessage: 'طلب غير صالح: $message',
        );
}

/// Thrown when order cannot be modified
class OrderCannotBeModifiedException extends DomainException {
  final String orderId;
  final String reason;

  OrderCannotBeModifiedException({
    required this.orderId,
    required this.reason,
  }) : super(
          message: 'Order $orderId cannot be modified: $reason',
          arabicMessage: 'لا يمكن تعديل الطلب: $reason',
        );
}

// ============================================
// Permission Exceptions
// ============================================

/// Thrown when user lacks permission for an action
class PermissionDeniedException extends DomainException {
  final String action;
  final String role;

  PermissionDeniedException({
    required this.action,
    required this.role,
  }) : super(
          message: 'Permission denied for $role to perform $action',
          arabicMessage: 'صلاحية مرفوضة: لا يمكن لـ $role تنفيذ $action',
        );
}

// ============================================
// Entity Not Found Exceptions
// ============================================

/// Thrown when an entity is not found
class EntityNotFoundException extends DomainException {
  final String entityType;
  final String entityId;

  EntityNotFoundException({
    required this.entityType,
    required this.entityId,
  }) : super(
          message: '$entityType with ID $entityId not found',
          arabicMessage: 'لم يتم العثور على $entityType برقم $entityId',
        );
}

