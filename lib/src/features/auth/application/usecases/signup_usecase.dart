import 'package:tailorhouse/src/core/error/failures.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/auth/domain/entities/user.dart';
import 'package:tailorhouse/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user registration
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  /// Execute sign up with user details
  FutureResult<User> call(SignUpParams params) async {
    // Validate input
    final validationError = _validateInput(params);
    if (validationError != null) {
      return Results.failure(validationError);
    }

    return _repository.signUp(
      name: params.name.trim(),
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }

  Failure? _validateInput(SignUpParams params) {
    if (params.name.isEmpty) {
      return const ValidationFailure(message: 'Name is required');
    }

    if (params.name.length < 2) {
      return const ValidationFailure(
        message: 'Name must be at least 2 characters',
      );
    }

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

    if (!_hasValidPasswordStrength(params.password)) {
      return const ValidationFailure(
        message:
            'Password must contain at least one letter and one number',
      );
    }

    if (params.password != params.confirmPassword) {
      return const ValidationFailure(message: 'Passwords do not match');
    }

    if (!params.acceptedTerms) {
      return const ValidationFailure(
        message: 'Please accept the terms and conditions',
      );
    }

    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _hasValidPasswordStrength(String password) {
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }
}

/// Parameters for sign up use case
class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool acceptedTerms;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.acceptedTerms,
  });
}

