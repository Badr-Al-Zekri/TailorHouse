import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get user's initials for avatar placeholder
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Check if profile is complete
  bool get isProfileComplete =>
      name.isNotEmpty && phoneNumber != null && phoneNumber!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        avatarUrl,
        dateOfBirth,
        gender,
        createdAt,
        updatedAt,
      ];
}

