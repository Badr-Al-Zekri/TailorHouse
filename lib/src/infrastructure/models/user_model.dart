import 'package:hive/hive.dart';
import 'package:tailorhouse/src/domain/domain.dart';

part 'user_model.g.dart';

/// Hive model for User entity
@HiveType(typeId: 6)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String shopId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int roleIndex; // UserRole enum index

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String? pinHash; // Hashed PIN for authentication

  @HiveField(6)
  final bool isActive;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.roleIndex,
    required this.phone,
    this.pinHash,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Convert from domain entity
  factory UserModel.fromEntity(User entity, {String? pinHash}) {
    return UserModel(
      id: entity.id,
      shopId: entity.shopId,
      name: entity.name,
      roleIndex: entity.role.index,
      phone: entity.phone,
      pinHash: pinHash,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      shopId: shopId,
      name: name,
      role: UserRole.values[roleIndex],
      phone: phone,
      isActive: isActive,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }

  /// Create copy with updated fields
  UserModel copyWith({
    String? name,
    int? roleIndex,
    String? phone,
    String? pinHash,
    bool? isActive,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id,
      shopId: shopId,
      name: name ?? this.name,
      roleIndex: roleIndex ?? this.roleIndex,
      phone: phone ?? this.phone,
      pinHash: pinHash ?? this.pinHash,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

