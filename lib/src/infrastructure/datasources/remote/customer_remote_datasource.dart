import 'package:dio/dio.dart';
import 'package:tailorhouse/src/infrastructure/models/customer_model.dart';
import 'package:tailorhouse/src/core/error/exceptions.dart';

/// Remote data source for Customer operations
class CustomerRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  CustomerRemoteDataSource({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  /// Create customer on server
  Future<CustomerModel> create(CustomerModel customer) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/customers',
        data: _customerToJson(customer),
      );
      return _customerFromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get customer by ID from server
  Future<CustomerModel?> getById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/customers/$id');
      return _customerFromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw _handleDioError(e);
    }
  }

  /// Update customer on server
  Future<CustomerModel> update(CustomerModel customer) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/customers/${customer.id}',
        data: _customerToJson(customer),
      );
      return _customerFromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Sync local customers to server (batch)
  Future<void> syncCustomers(List<CustomerModel> customers) async {
    try {
      await _dio.post(
        '$_baseUrl/customers/sync',
        data: customers.map((c) => _customerToJson(c)).toList(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Map<String, dynamic> _customerToJson(CustomerModel customer) {
    return {
      'id': customer.id,
      'shop_id': customer.shopId,
      'name': customer.name,
      'phone_number': customer.phoneNumber,
      'secondary_phone_number': customer.secondaryPhoneNumber,
      'notes': customer.notes,
      'created_at': customer.createdAt.toIso8601String(),
      'updated_at': customer.updatedAt.toIso8601String(),
    };
  }

  CustomerModel _customerFromJson(Map<String, dynamic> json) {
    // Simplified - full implementation needed
    throw UnimplementedError('Full JSON mapping to be implemented');
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return ServerException(
        message: e.response?.data['message'] ?? 'Server error',
        statusCode: e.response!.statusCode!,
      );
    } else {
      return NetworkException(message: 'Network error: ${e.message}');
    }
  }
}

