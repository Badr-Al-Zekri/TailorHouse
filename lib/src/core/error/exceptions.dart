/// Base exception class for infrastructure-level errors
/// These should be caught and converted to Failures in repositories
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

// ============================================================================
// Server Exceptions
// ============================================================================

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });

  factory ServerException.fromStatusCode(int statusCode, [String? message]) {
    final defaultMessage = _getMessageForStatusCode(statusCode);
    return ServerException(
      message: message ?? defaultMessage,
      statusCode: statusCode,
      code: 'HTTP_$statusCode',
    );
  }

  static String _getMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Validation error';
      case 429:
        return 'Too many requests';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'Server error';
    }
  }
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.code = 'TIMEOUT',
    super.originalError,
  });
}

// ============================================================================
// Cache Exceptions
// ============================================================================

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

class CacheNotFoundException extends CacheException {
  const CacheNotFoundException({
    super.message = 'Data not found in cache',
    super.code = 'CACHE_NOT_FOUND',
  });
}

class CacheWriteException extends CacheException {
  const CacheWriteException({
    super.message = 'Failed to write to cache',
    super.code = 'CACHE_WRITE_ERROR',
  });
}

// ============================================================================
// Authentication Exceptions
// ============================================================================

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.originalError,
  });
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    super.message = 'Invalid credentials',
    super.code = 'INVALID_CREDENTIALS',
  });
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Token expired',
    super.code = 'TOKEN_EXPIRED',
  });
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.code = 'UNAUTHORIZED',
  });
}

// ============================================================================
// Validation Exceptions
// ============================================================================

class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });
}

// ============================================================================
// AI Exceptions
// ============================================================================

class AiException extends AppException {
  const AiException({
    required super.message,
    super.code = 'AI_ERROR',
    super.originalError,
  });
}

class ImageProcessingException extends AiException {
  const ImageProcessingException({
    super.message = 'Failed to process image',
    super.code = 'IMAGE_PROCESSING_ERROR',
  });
}

// ============================================================================
// Permission Exceptions
// ============================================================================

class PermissionException extends AppException {
  final String permission;

  const PermissionException({
    required this.permission,
    super.message = 'Permission denied',
    super.code = 'PERMISSION_DENIED',
  });
}

