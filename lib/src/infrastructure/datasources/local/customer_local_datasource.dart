import 'package:tailorhouse/src/infrastructure/models/customer_model.dart';
import 'package:tailorhouse/src/infrastructure/services/storage_service.dart';

/// Local data source for Customer operations
class CustomerLocalDataSource {
  final StorageService _storageService;

  CustomerLocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Save a customer
  Future<CustomerModel> save(CustomerModel customer) async {
    await _storageService.customersBox.put(customer.id, customer);
    return customer;
  }

  /// Get customer by ID
  CustomerModel? getById(String id) {
    return _storageService.customersBox.get(id);
  }

  /// Get customer by phone number
  CustomerModel? getByPhone(String normalizedPhone) {
    try {
      return _storageService.customersBox.values.firstWhere(
        (customer) => _normalizePhone(customer.phoneNumber) == normalizedPhone,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get all customers for a shop
  List<CustomerModel> getByShopId(String shopId) {
    return _storageService.customersBox.values
        .where((customer) => customer.shopId == shopId)
        .toList();
  }

  /// Search customers by name or phone
  List<CustomerModel> search(String shopId, String query) {
    final lowerQuery = query.toLowerCase();
    return _storageService.customersBox.values
        .where((customer) =>
            customer.shopId == shopId &&
            (customer.name.toLowerCase().contains(lowerQuery) ||
                customer.phoneNumber.contains(lowerQuery)))
        .toList();
  }

  /// Delete customer
  Future<void> delete(String id) async {
    await _storageService.customersBox.delete(id);
  }

  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }
}

