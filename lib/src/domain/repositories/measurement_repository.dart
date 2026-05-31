import 'package:tailorhouse/src/domain/entities/measurement.dart';

/// Measurement Repository Interface
/// 
/// Defines the contract for measurement persistence.
abstract class MeasurementRepository {
  /// Create a new measurement record
  Future<Measurement> create(Measurement measurement);

  /// Get measurement by ID
  Future<Measurement?> getById(String id);

  /// Get measurement by order ID
  Future<Measurement?> getByOrderId(String orderId);

  /// Update an existing measurement
  Future<Measurement> update(Measurement measurement);

  /// Delete a measurement
  Future<void> delete(String id);

  /// Store measurement images
  /// Returns the stored image paths/URLs
  Future<List<String>> storeImages(String measurementId, List<String> imagePaths);

  /// Delete measurement images
  Future<void> deleteImages(String measurementId);
}

