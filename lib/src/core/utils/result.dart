import 'package:dartz/dartz.dart';
import 'package:tailorhouse/src/core/error/failures.dart';

/// Type alias for Either with Failure on the left
/// Use this for all use case return types
typedef Result<T> = Either<Failure, T>;

/// Type alias for async operations returning Result
typedef FutureResult<T> = Future<Result<T>>;

/// Extension methods for Result type
extension ResultExtension<T> on Result<T> {
  /// Returns true if the result is a success (Right)
  bool get isSuccess => isRight();

  /// Returns true if the result is a failure (Left)
  bool get isFailure => isLeft();

  /// Get the success value or null
  T? get successOrNull => fold((_) => null, (r) => r);

  /// Get the failure or null
  Failure? get failureOrNull => fold((l) => l, (_) => null);

  /// Get success value or throw
  T get successOrThrow => fold(
        (failure) => throw Exception(failure.message),
        (value) => value,
      );

  /// Map success value to another type
  Result<R> mapSuccess<R>(R Function(T value) mapper) {
    return map(mapper);
  }

  /// Handle both success and failure cases
  R when<R>({
    required R Function(Failure failure) failure,
    required R Function(T value) success,
  }) {
    return fold(failure, success);
  }

  /// Execute callback on success, return original result
  Result<T> onSuccess(void Function(T value) callback) {
    fold((_) {}, callback);
    return this;
  }

  /// Execute callback on failure, return original result
  Result<T> onFailure(void Function(Failure failure) callback) {
    fold(callback, (_) {});
    return this;
  }
}

/// Extension methods for FutureResult
extension FutureResultExtension<T> on FutureResult<T> {
  /// Handle both success and failure cases asynchronously
  Future<R> when<R>({
    required R Function(Failure failure) failure,
    required R Function(T value) success,
  }) async {
    final result = await this;
    return result.fold(failure, success);
  }

  /// Map success value to another type asynchronously
  FutureResult<R> mapSuccess<R>(R Function(T value) mapper) async {
    final result = await this;
    return result.map(mapper);
  }
}

/// Helper functions for creating Result values
class Results {
  Results._();

  /// Create a success result
  static Result<T> success<T>(T value) => Right(value);

  /// Create a failure result
  static Result<T> failure<T>(Failure failure) => Left(failure);

  /// Create a success result from a nullable value
  /// Returns failure if value is null
  static Result<T> fromNullable<T>(
    T? value, {
    required Failure Function() onNull,
  }) {
    return value != null ? Right(value) : Left(onNull());
  }

  /// Execute a function and wrap the result
  /// Catches exceptions and converts them to failures
  static FutureResult<T> guard<T>(
    Future<T> Function() function, {
    Failure Function(Object error)? onError,
  }) async {
    try {
      final result = await function();
      return Right(result);
    } catch (e) {
      if (onError != null) {
        return Left(onError(e));
      }
      return Left(UnexpectedFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  /// Execute a synchronous function and wrap the result
  static Result<T> guardSync<T>(
    T Function() function, {
    Failure Function(Object error)? onError,
  }) {
    try {
      final result = function();
      return Right(result);
    } catch (e) {
      if (onError != null) {
        return Left(onError(e));
      }
      return Left(UnexpectedFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }
}

