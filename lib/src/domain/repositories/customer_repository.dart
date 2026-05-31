import 'package:tailorhouse/src/domain/entities/customer.dart';

/// Customer Repository Interface
/// 
/// Defines the contract for customer persistence.
abstract class CustomerRepository {
  /// Create a new customer
  Future<Customer> create(Customer customer);

  /// Get customer by ID
  Future<Customer?> getById(String id);

  /// Get customer by phone number
  Future<Customer?> getByPhone(String normalizedPhone);

  /// Update an existing customer
  Future<Customer> update(Customer customer);

  /// Get all customers for a shop
  Future<List<Customer>> getAll(String shopId);

  /// Search customers by name or phone
  Future<List<Customer>> search(String shopId, String query);

  /// Delete a customer
  Future<void> delete(String id);

  /// Get or create customer by phone
  /// Returns existing customer if phone matches, otherwise creates new
  Future<Customer> getOrCreate({
    required String shopId,
    required String name,
    required String phone,
  });
}

