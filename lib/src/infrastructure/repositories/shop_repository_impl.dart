import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/shop_model.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/shop_local_datasource.dart';

/// Implementation of ShopRepository using local storage
class ShopRepositoryImpl implements ShopRepository {
  final ShopLocalDataSource _localDataSource;

  ShopRepositoryImpl({required ShopLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Shop> create(Shop shop) async {
    final model = ShopModel.fromEntity(shop);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<Shop?> getById(String id) async {
    final model = _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<Shop?> getByCode(String code) async {
    final model = _localDataSource.getByCode(code);
    return model?.toEntity();
  }

  @override
  Future<Shop> update(Shop shop) async {
    final model = ShopModel.fromEntity(shop);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<Shop?> getCurrentShop() async {
    final model = _localDataSource.getCurrentShop();
    return model?.toEntity();
  }

  @override
  Future<void> setCurrentShop(String shopId) async {
    await _localDataSource.setCurrentShop(shopId);
  }

  @override
  Future<bool> isCodeAvailable(String code) async {
    return _localDataSource.isCodeAvailable(code);
  }
}

