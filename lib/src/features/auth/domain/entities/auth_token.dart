import 'package:equatable/equatable.dart';

/// Authentication tokens for API requests
class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Check if the token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if the token will expire soon (within 5 minutes)
  bool get isExpiringSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  /// Remaining time until token expires
  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}

