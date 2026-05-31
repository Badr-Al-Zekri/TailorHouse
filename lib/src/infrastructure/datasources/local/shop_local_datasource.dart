import 'package:tailorhouse/src/infrastructure/models/shop_model.dart';
import 'package:tailorhouse/src/infrastructure/services/storage_service.dart';

/// Local data source for Shop operations
class ShopLocalDataSource {
  final StorageService _storageService;

  ShopLocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Save a shop
  Future<ShopModel> save(ShopModel shop) async {
    await _storageService.shopsBox.put(shop.id, shop);
    return shop;
  }

  /// Get shop by ID
  ShopModel? getById(String id) {
    return _storageService.shopsBox.get(id);
  }

  /// Get shop by code
  ShopModel? getByCode(String code) {
    try {
      return _storageService.shopsBox.values.firstWhere(
        (shop) => shop.code.toLowerCase() == code.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get current shop
  ShopModel? getCurrentShop() {
    final currentShopId = _storageService.currentShopId;
    if (currentShopId == null) return null;
    return getById(currentShopId);
  }

  /// Set current shop
  Future<void> setCurrentShop(String shopId) async {
    await _storageService.setCurrentShopId(shopId);
  }

  /// Check if shop code is available
  bool isCodeAvailable(String code) {
    return getByCode(code) == null;
  }
}

