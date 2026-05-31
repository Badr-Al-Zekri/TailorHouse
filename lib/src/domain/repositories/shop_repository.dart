import 'package:tailorhouse/src/domain/entities/shop.dart';

/// Shop Repository Interface
/// 
/// Defines the contract for shop persistence.
abstract class ShopRepository {
  /// Create a new shop
  Future<Shop> create(Shop shop);

  /// Get shop by ID
  Future<Shop?> getById(String id);

  /// Get shop by code
  Future<Shop?> getByCode(String code);

  /// Update an existing shop
  Future<Shop> update(Shop shop);

  /// Get the current shop (for single-shop deployments)
  Future<Shop?> getCurrentShop();

  /// Set the current shop
  Future<void> setCurrentShop(String shopId);

  /// Check if a shop code is available
  Future<bool> isCodeAvailable(String code);
}

