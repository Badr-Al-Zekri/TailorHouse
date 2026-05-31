import 'package:dio/dio.dart';
import 'package:tailorhouse/src/infrastructure/models/order_model.dart';
import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/core/error/exceptions.dart';

/// Remote data source for Order operations
/// 
/// Handles API communication with the FastAPI backend.
class OrderRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  OrderRemoteDataSource({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  /// Create order on server
  Future<OrderModel> create(OrderModel order) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/orders',
        data: _orderToJson(order),
      );
      return _orderFromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get order by ID from server
  Future<OrderModel?> getById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/orders/$id');
      return _orderFromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw _handleDioError(e);
    }
  }

  /// Get order by garment ID from server
  Future<OrderModel?> getByGarmentId(String garmentId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/orders/by-garment-id/$garmentId',
      );
      return _orderFromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw _handleDioError(e);
    }
  }

  /// Update order on server
  Future<OrderModel> update(OrderModel order) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/orders/${order.id}',
        data: _orderToJson(order),
      );
      return _orderFromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get orders by shop ID from server
  Future<List<OrderModel>> getByShopId(String shopId) async {
    try {
      final response = await _dio.get('$_baseUrl/orders?shop_id=$shopId');
      return (response.data as List)
          .map((json) => _orderFromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get orders by status from server
  Future<List<OrderModel>> getByStatus(
    String shopId,
    GarmentStatus status,
  ) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/orders?shop_id=$shopId&status=${status.englishName}',
      );
      return (response.data as List)
          .map((json) => _orderFromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Sync local orders to server (batch)
  Future<void> syncOrders(List<OrderModel> orders) async {
    try {
      await _dio.post(
        '$_baseUrl/orders/sync',
        data: orders.map((o) => _orderToJson(o)).toList(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get last sequence from server
  Future<int> getLastSequence(String shopCode, int year) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/orders/sequence?shop_code=$shopCode&year=$year',
      );
      return response.data['last_sequence'] as int? ?? 0;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Helper methods for JSON conversion
  Map<String, dynamic> _orderToJson(OrderModel order) {
    return {
      'id': order.id,
      'garment_id': order.garmentIdString,
      'shop_id': order.shopId,
      'customer_id': order.customerId,
      'customer_name': order.customerName,
      'customer_phone': order.customerPhone,
      'garment_type': order.garmentTypeIndex,
      'fabric_description': order.fabricDescription,
      'fabric_color': order.fabricColor,
      'total_price': order.totalPriceInSmallestUnit,
      'deposit_paid': order.depositPaidInSmallestUnit,
      'currency': order.currency,
      'status': order.statusIndex,
      'expected_delivery_date': order.expectedDeliveryDate.toIso8601String(),
      'actual_delivery_date': order.actualDeliveryDate?.toIso8601String(),
      'notes': order.notes,
      'created_at': order.createdAt.toIso8601String(),
      'updated_at': order.updatedAt.toIso8601String(),
      'created_by': order.createdBy,
    };
  }

  OrderModel _orderFromJson(Map<String, dynamic> json) {
    // This is a simplified version - in production, you'd need full mapping
    // For now, we'll need to reconstruct from JSON
    // Note: This assumes the API returns data in a compatible format
    throw UnimplementedError('Full JSON mapping to be implemented');
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return ServerException(
        message: e.response?.data['message'] ?? 'Server error',
        statusCode: e.response!.statusCode!,
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException(message: 'Connection timeout');
    } else {
      return NetworkException(message: 'Network error: ${e.message}');
    }
  }
}

