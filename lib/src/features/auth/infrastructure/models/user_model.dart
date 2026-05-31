import 'package:hive/hive.dart';
import 'package:tailorhouse/src/features/auth/domain/entities/user.dart';

// TODO: Run `flutter pub run build_runner build` to generate this file
// part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? avatarUrl;

  @HiveField(5)
  final DateTime? dateOfBirth;

  @HiveField(6)
  final String? gender;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  UserModel({
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

  /// Convert from domain entity to model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phoneNumber: user.phoneNumber,
      avatarUrl: user.avatarUrl,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Convert from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      dateOfBirth: dateOfBirth,
      gender: gender,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

