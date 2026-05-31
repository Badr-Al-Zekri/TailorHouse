import 'package:dio/dio.dart';
import 'package:tailorhouse/src/infrastructure/models/measurement_model.dart';
import 'package:tailorhouse/src/core/error/exceptions.dart';

/// Remote data source for Measurement operations
class MeasurementRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  MeasurementRemoteDataSource({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  /// Create measurement on server
  Future<MeasurementModel> create(MeasurementModel measurement) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/measurements',
        data: _measurementToJson(measurement),
      );
      return _measurementFromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload measurement images
  Future<List<String>> uploadImages(
    String measurementId,
    List<String> imagePaths,
  ) async {
    try {
      final formData = FormData();
      for (int i = 0; i < imagePaths.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(imagePaths[i]),
          ),
        );
      }

      final response = await _dio.post(
        '$_baseUrl/measurements/$measurementId/images',
        data: formData,
      );
      return (response.data['image_urls'] as List)
          .map((url) => url.toString())
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Sync local measurements to server (batch)
  Future<void> syncMeasurements(List<MeasurementModel> measurements) async {
    try {
      await _dio.post(
        '$_baseUrl/measurements/sync',
        data: measurements.map((m) => _measurementToJson(m)).toList(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Map<String, dynamic> _measurementToJson(MeasurementModel measurement) {
    // Simplified - full implementation needed
    return {
      'id': measurement.id,
      'order_id': measurement.orderId,
      'measured_at': measurement.measuredAt.toIso8601String(),
      'measured_by': measurement.measuredBy,
      'notes': measurement.notes,
    };
  }

  MeasurementModel _measurementFromJson(Map<String, dynamic> json) {
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

