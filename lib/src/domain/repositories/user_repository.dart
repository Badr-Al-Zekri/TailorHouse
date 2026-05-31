import 'package:tailorhouse/src/domain/enums/user_role.dart';

/// User entity for the domain layer
/// 
/// Represents a system user (shop staff, worker, or customer)
class User {
  /// Unique identifier
  final String id;

  /// Shop this user belongs to
  final String shopId;

  /// User's name
  final String name;

  /// User's role
  final UserRole role;

  /// Phone number (for login/contact)
  final String phone;

  /// Whether user is active
  final bool isActive;

  /// When the user was created
  final DateTime createdAt;

  /// Last login timestamp
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.shopId,
    required this.name,
    required this.role,
    required this.phone,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Check if user can perform shop management
  bool get canManageShop => role == UserRole.owner;

  /// Check if user can create orders
  bool get canCreateOrders => role.canCreateOrders;

  /// Check if user can view all orders
  bool get canViewAllOrders => role.canViewAllOrders;

  /// Check if user is a worker
  bool get isWorker => role.isWorker;

  /// Get display name with role
  String get displayNameWithRole => '$name (${role.arabicName})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User($id, $name, ${role.englishName})';
}

/// User Repository Interface
/// 
/// Defines the contract for user persistence.
abstract class UserRepository {
  /// Create a new user
  Future<User> create(User user);

  /// Get user by ID
  Future<User?> getById(String id);

  /// Get user by phone
  Future<User?> getByPhone(String phone);

  /// Update an existing user
  Future<User> update(User user);

  /// Get all users for a shop
  Future<List<User>> getByShopId(String shopId);

  /// Get users by role
  Future<List<User>> getByRole(String shopId, UserRole role);

  /// Get all workers for a shop
  Future<List<User>> getWorkers(String shopId);

  /// Delete a user (soft delete recommended)
  Future<void> delete(String id);

  /// Record login
  Future<void> recordLogin(String userId);

  /// Authenticate user (returns user if valid, null otherwise)
  Future<User?> authenticate(String phone, String pin);
}

