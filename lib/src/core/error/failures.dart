import 'package:equatable/equatable.dart';

/// Base failure class for domain-level errors
/// All failures should extend this class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

// ============================================================================
// Server / Network Failures
// ============================================================================

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, code, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.code = 'TIMEOUT',
  });
}

// ============================================================================
// Local Storage Failures
// ============================================================================

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.code = 'CACHE_ERROR',
  });
}

class StorageFullFailure extends Failure {
  const StorageFullFailure({
    super.message = 'Device storage is full.',
    super.code = 'STORAGE_FULL',
  });
}

// ============================================================================
// Authentication Failures
// ============================================================================

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Authentication failed. Please try again.',
    super.code = 'AUTH_ERROR',
  });
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
  });
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please log in again.',
    super.code = 'SESSION_EXPIRED',
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'You are not authorized to perform this action.',
    super.code = 'UNAUTHORIZED',
  });
}

// ============================================================================
// Validation Failures
// ============================================================================

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

// ============================================================================
// AI / Measurement Failures
// ============================================================================

class AiProcessingFailure extends Failure {
  const AiProcessingFailure({
    super.message = 'Failed to process measurements. Please try again.',
    super.code = 'AI_PROCESSING_ERROR',
  });
}

class InvalidImageFailure extends Failure {
  const InvalidImageFailure({
    super.message = 'The image could not be processed. Please take a clearer photo.',
    super.code = 'INVALID_IMAGE',
  });
}

class MeasurementNotFoundFailure extends Failure {
  const MeasurementNotFoundFailure({
    super.message = 'Measurement profile not found.',
    super.code = 'MEASUREMENT_NOT_FOUND',
  });
}

// ============================================================================
// Order Failures
// ============================================================================

class OrderFailure extends Failure {
  const OrderFailure({
    required super.message,
    super.code = 'ORDER_ERROR',
  });
}

class OrderNotFoundFailure extends Failure {
  const OrderNotFoundFailure({
    super.message = 'Order not found.',
    super.code = 'ORDER_NOT_FOUND',
  });
}

// ============================================================================
// Permission Failures
// ============================================================================

class PermissionDeniedFailure extends Failure {
  final String permission;

  const PermissionDeniedFailure({
    required this.permission,
    super.message = 'Permission denied.',
    super.code = 'PERMISSION_DENIED',
  });

  @override
  List<Object?> get props => [message, code, permission];
}

class CameraPermissionFailure extends PermissionDeniedFailure {
  const CameraPermissionFailure({
    super.message = 'Camera permission is required to take measurements.',
  }) : super(permission: 'camera');
}

// ============================================================================
// Generic Failures
// ============================================================================

class UnexpectedFailure extends Failure {
  final Object? originalError;

  const UnexpectedFailure({
    super.message = 'An unexpected error occurred.',
    super.code = 'UNEXPECTED_ERROR',
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, originalError];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.code = 'NOT_FOUND',
  });
}

