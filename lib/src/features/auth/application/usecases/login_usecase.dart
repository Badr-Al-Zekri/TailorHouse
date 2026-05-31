import 'package:tailorhouse/src/core/error/failures.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/auth/domain/entities/user.dart';
import 'package:tailorhouse/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Execute login with email and password
  FutureResult<User> call(LoginParams params) async {
    // Validate input
    final validationError = _validateInput(params);
    if (validationError != null) {
      return Results.failure(validationError);
    }

    return _repository.login(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }

  Failure? _validateInput(LoginParams params) {
    if (params.email.isEmpty) {
      return const ValidationFailure(message: 'Email is required');
    }

    if (!_isValidEmail(params.email)) {
      return const ValidationFailure(message: 'Please enter a valid email');
    }

    if (params.password.isEmpty) {
      return const ValidationFailure(message: 'Password is required');
    }

    if (params.password.length < 8) {
      return const ValidationFailure(
        message: 'Password must be at least 8 characters',
      );
    }

    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}

/// Parameters for login use case
class LoginParams {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

