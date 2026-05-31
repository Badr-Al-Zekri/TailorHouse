import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/customer_model.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/customer_local_datasource.dart';

/// Implementation of CustomerRepository using local storage
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource _localDataSource;

  CustomerRepositoryImpl({required CustomerLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Customer> create(Customer customer) async {
    // Note: Customer entity doesn't have shopId, but we need it for storage
    // This method should be used with getOrCreate which handles shop association
    // For direct create, use createWithShopId
    throw UnimplementedError(
      'Use createWithShopId or getOrCreate for proper shop association',
    );
  }

  /// Create customer with explicit shop ID
  /// This is the preferred method for creating customers
  Future<Customer> createWithShopId(Customer customer, String shopId) async {
    final model = CustomerModel.fromEntity(customer, shopId);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<Customer?> getById(String id) async {
    final model = _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<Customer?> getByPhone(String normalizedPhone) async {
    final model = _localDataSource.getByPhone(normalizedPhone);
    return model?.toEntity();
  }

  @override
  Future<Customer> update(Customer customer) async {
    final existing = _localDataSource.getById(customer.id);
    if (existing == null) {
      throw EntityNotFoundException(
        entityType: 'Customer',
        entityId: customer.id,
      );
    }
    final model = CustomerModel.fromEntity(customer, existing.shopId);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<List<Customer>> getAll(String shopId) async {
    final models = _localDataSource.getByShopId(shopId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Customer>> search(String shopId, String query) async {
    final models = _localDataSource.search(shopId, query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> delete(String id) async {
    await _localDataSource.delete(id);
  }

  @override
  Future<Customer> getOrCreate({
    required String shopId,
    required String name,
    required String phone,
  }) async {
    // Try to find existing customer by phone
    final normalizedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final existing = _localDataSource.getByPhone(normalizedPhone);
    
    if (existing != null) {
      return existing.toEntity();
    }

    // Create new customer
    final now = DateTime.now();
    final newCustomer = Customer(
      id: 'CUST_${now.millisecondsSinceEpoch}',
      name: name,
      phoneNumber: PhoneNumber.create(phone),
      createdAt: now,
      updatedAt: now,
    );

    return await createWithShopId(newCustomer, shopId);
  }
}

