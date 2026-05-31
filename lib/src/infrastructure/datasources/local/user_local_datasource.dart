import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:tailorhouse/src/infrastructure/models/user_model.dart';
import 'package:tailorhouse/src/infrastructure/services/storage_service.dart';
import 'package:tailorhouse/src/domain/domain.dart';

/// Local data source for User operations
class UserLocalDataSource {
  final StorageService _storageService;

  UserLocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Save a user
  Future<UserModel> save(UserModel user) async {
    await _storageService.usersBox.put(user.id, user);
    return user;
  }

  /// Get user by ID
  UserModel? getById(String id) {
    return _storageService.usersBox.get(id);
  }

  /// Get user by phone
  UserModel? getByPhone(String phone) {
    final normalizedPhone = _normalizePhone(phone);
    try {
      return _storageService.usersBox.values.firstWhere(
        (user) => _normalizePhone(user.phone) == normalizedPhone,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get all users for a shop
  List<UserModel> getByShopId(String shopId) {
    return _storageService.usersBox.values
        .where((user) => user.shopId == shopId)
        .toList();
  }

  /// Get users by role
  List<UserModel> getByRole(String shopId, UserRole role) {
    return _storageService.usersBox.values
        .where((user) => user.shopId == shopId && user.roleIndex == role.index)
        .toList();
  }

  /// Get all workers for a shop
  List<UserModel> getWorkers(String shopId) {
    final workerRoles = [
      UserRole.cutter.index,
      UserRole.tailor.index,
      UserRole.buttonWorker.index,
      UserRole.ironWorker.index,
    ];
    return _storageService.usersBox.values
        .where((user) =>
            user.shopId == shopId && workerRoles.contains(user.roleIndex))
        .toList();
  }

  /// Delete user
  Future<void> delete(String id) async {
    await _storageService.usersBox.delete(id);
  }

  /// Record login
  Future<void> recordLogin(String userId) async {
    final user = getById(userId);
    if (user != null) {
      await save(user.copyWith(lastLoginAt: DateTime.now()));
    }
  }

  /// Authenticate user
  UserModel? authenticate(String phone, String pin) {
    final user = getByPhone(phone);
    if (user == null || !user.isActive) return null;

    // Verify PIN
    final pinHash = _hashPin(pin);
    if (user.pinHash == pinHash) {
      return user;
    }
    return null;
  }

  /// Set user PIN
  Future<void> setPin(String userId, String pin) async {
    final user = getById(userId);
    if (user != null) {
      await save(user.copyWith(pinHash: _hashPin(pin)));
    }
  }

  /// Hash PIN for storage
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }
}

