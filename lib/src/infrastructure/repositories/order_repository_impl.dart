import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/order_model.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/order_local_datasource.dart';

/// Implementation of OrderRepository using local storage
class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl({required OrderLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Order> create(Order order) async {
    final model = OrderModel.fromEntity(order);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<Order?> getById(String id) async {
    final model = _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<Order?> getByGarmentId(String garmentId) async {
    final model = _localDataSource.getByGarmentId(garmentId);
    return model?.toEntity();
  }

  @override
  Future<Order> update(Order order) async {
    final model = OrderModel.fromEntity(order);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<List<Order>> getByShopId(String shopId) async {
    final models = _localDataSource.getByShopId(shopId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Order>> getByStatus(String shopId, GarmentStatus status) async {
    final models = _localDataSource.getByStatus(shopId, status);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Order>> getByCustomerId(String customerId) async {
    final models = _localDataSource.getByCustomerId(customerId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Order>> getInProgressOrders(String shopId) async {
    final models = _localDataSource.getInProgressOrders(shopId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Order>> getOverdueOrders(String shopId) async {
    final models = _localDataSource.getOverdueOrders(shopId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Order>> search(String shopId, String query) async {
    final models = _localDataSource.search(shopId, query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Map<GarmentStatus, int>> getStatusCounts(String shopId) async {
    return _localDataSource.getStatusCounts(shopId);
  }

  @override
  Future<void> delete(String id) async {
    await _localDataSource.delete(id);
  }

  @override
  Future<int> getLastGarmentSequence(String shopCode, int year) async {
    return _localDataSource.getLastGarmentSequence(shopCode, year);
  }

  @override
  Future<int> getNextGarmentSequence(String shopCode, int year) async {
    return await _localDataSource.getNextGarmentSequence(shopCode, year);
  }
}

