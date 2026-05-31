import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/auth/domain/entities/auth_token.dart';
import 'package:tailorhouse/src/features/auth/domain/entities/user.dart';

/// Abstract repository for authentication operations
/// Implementation will be in infrastructure layer
abstract class AuthRepository {
  /// Login with email and password
  FutureResult<User> login({
    required String email,
    required String password,
  });

  /// Register a new user
  FutureResult<User> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Logout current user
  FutureResult<void> logout();

  /// Send password reset email
  FutureResult<void> sendPasswordResetEmail(String email);

  /// Verify password reset code
  FutureResult<void> verifyResetCode(String code);

  /// Reset password with new password
  FutureResult<void> resetPassword({
    required String code,
    required String newPassword,
  });

  /// Change password for current user
  FutureResult<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Get current authenticated user
  FutureResult<User?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get current auth token
  FutureResult<AuthToken?> getAuthToken();

  /// Refresh auth token
  FutureResult<AuthToken> refreshToken();

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
}

