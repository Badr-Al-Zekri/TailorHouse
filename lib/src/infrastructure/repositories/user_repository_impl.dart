import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/user_model.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/user_local_datasource.dart';

/// Implementation of UserRepository using local storage
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl({required UserLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<User> create(User user) async {
    final model = UserModel.fromEntity(user);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  /// Create user with PIN
  Future<User> createWithPin(User user, String pin) async {
    final model = UserModel.fromEntity(user);
    // Set PIN separately to hash it
    await _localDataSource.save(model);
    await _localDataSource.setPin(user.id, pin);
    
    // Retrieve updated model
    final savedModel = _localDataSource.getById(user.id);
    return savedModel!.toEntity();
  }

  @override
  Future<User?> getById(String id) async {
    final model = _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<User?> getByPhone(String phone) async {
    final model = _localDataSource.getByPhone(phone);
    return model?.toEntity();
  }

  @override
  Future<User> update(User user) async {
    final existing = _localDataSource.getById(user.id);
    if (existing == null) {
      throw EntityNotFoundException(
        entityType: 'User',
        entityId: user.id,
      );
    }
    
    // Preserve PIN hash
    final model = UserModel.fromEntity(user, pinHash: existing.pinHash);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<List<User>> getByShopId(String shopId) async {
    final models = _localDataSource.getByShopId(shopId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<User>> getByRole(String shopId, UserRole role) async {
    final models = _localDataSource.getByRole(shopId, role);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<User>> getWorkers(String shopId) async {
    final models = _localDataSource.getWorkers(shopId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> delete(String id) async {
    await _localDataSource.delete(id);
  }

  @override
  Future<void> recordLogin(String userId) async {
    await _localDataSource.recordLogin(userId);
  }

  @override
  Future<User?> authenticate(String phone, String pin) async {
    final model = _localDataSource.authenticate(phone, pin);
    return model?.toEntity();
  }

  /// Change user PIN
  Future<void> changePin(String userId, String newPin) async {
    await _localDataSource.setPin(userId, newPin);
  }
}

