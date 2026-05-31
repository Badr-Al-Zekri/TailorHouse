/// Base Use Case interface
/// 
/// All use cases follow this pattern for consistency.
/// Use cases orchestrate domain logic and coordinate between
/// repositories without containing business rules themselves.
abstract class UseCase<Input, Output> {
  /// Execute the use case
  Future<Output> execute(Input input);
}

/// Use case that doesn't require input
abstract class NoInputUseCase<Output> {
  Future<Output> execute();
}

/// Result wrapper for use case outputs
/// 
/// Provides a consistent way to handle success/failure
/// without throwing exceptions through the application layer.
sealed class Result<T> {
  const Result();

  /// Create a success result
  factory Result.success(T data) = Success<T>;

  /// Create a failure result
  factory Result.failure(Failure failure) = FailureResult<T>;

  /// Check if this is a success
  bool get isSuccess => this is Success<T>;

  /// Check if this is a failure
  bool get isFailure => this is FailureResult<T>;

  /// Get the data (throws if failure)
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Cannot get data from failure result');
  }

  /// Get the failure (throws if success)
  Failure get failure {
    if (this is FailureResult<T>) {
      return (this as FailureResult<T>).error;
    }
    throw StateError('Cannot get failure from success result');
  }

  /// Map the success value
  Result<R> map<R>(R Function(T) mapper) {
    if (this is Success<T>) {
      return Result.success(mapper((this as Success<T>).value));
    }
    return Result.failure((this as FailureResult<T>).error);
  }

  /// Handle both cases
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    }
    return onFailure((this as FailureResult<T>).error);
  }
}

/// Success result
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

/// Failure result
class FailureResult<T> extends Result<T> {
  final Failure error;
  const FailureResult(this.error);
}

/// Failure representation
/// 
/// Contains both Arabic and English messages for i18n support.
class Failure {
  final String message;
  final String arabicMessage;
  final String? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    required this.arabicMessage,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'Failure($code: $message)';
}

/// Common failure types
class ValidationFailure extends Failure {
  final String field;

  ValidationFailure({
    required super.message,
    required super.arabicMessage,
    required this.field,
  }) : super(code: 'VALIDATION_ERROR');
}

class NotFoundFailure extends Failure {
  final String entityType;
  final String entityId;

  NotFoundFailure({
    required this.entityType,
    required this.entityId,
  }) : super(
          message: '$entityType not found: $entityId',
          arabicMessage: 'لم يتم العثور على $entityType: $entityId',
          code: 'NOT_FOUND',
        );
}

class PermissionFailure extends Failure {
  PermissionFailure({
    required super.message,
    required super.arabicMessage,
  }) : super(code: 'PERMISSION_DENIED');
}

class WorkflowFailure extends Failure {
  WorkflowFailure({
    required super.message,
    required super.arabicMessage,
  }) : super(code: 'WORKFLOW_ERROR');
}

class NetworkFailure extends Failure {
  NetworkFailure({
    super.message = 'Network error occurred',
    super.arabicMessage = 'حدث خطأ في الاتصال',
  }) : super(code: 'NETWORK_ERROR');
}

class StorageFailure extends Failure {
  StorageFailure({
    super.message = 'Storage error occurred',
    super.arabicMessage = 'حدث خطأ في التخزين',
  }) : super(code: 'STORAGE_ERROR');
}

