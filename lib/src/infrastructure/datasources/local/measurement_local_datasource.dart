import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:tailorhouse/src/infrastructure/models/measurement_model.dart';
import 'package:tailorhouse/src/infrastructure/services/storage_service.dart';

/// Local data source for Measurement operations
class MeasurementLocalDataSource {
  final StorageService _storageService;

  MeasurementLocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Save a measurement
  Future<MeasurementModel> save(MeasurementModel measurement) async {
    await _storageService.measurementsBox.put(measurement.id, measurement);
    return measurement;
  }

  /// Get measurement by ID
  MeasurementModel? getById(String id) {
    return _storageService.measurementsBox.get(id);
  }

  /// Get measurement by order ID
  MeasurementModel? getByOrderId(String orderId) {
    try {
      return _storageService.measurementsBox.values.firstWhere(
        (measurement) => measurement.orderId == orderId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Delete measurement
  Future<void> delete(String id) async {
    await _storageService.measurementsBox.delete(id);
  }

  /// Store measurement images
  /// Copies images to app's documents directory
  Future<List<String>> storeImages(
    String measurementId,
    List<String> sourcePaths,
  ) async {
    final storedPaths = <String>[];

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final measurementDir = Directory('${appDir.path}/measurements/$measurementId');
      
      if (!await measurementDir.exists()) {
        await measurementDir.create(recursive: true);
      }

      for (int i = 0; i < sourcePaths.length; i++) {
        final sourceFile = File(sourcePaths[i]);
        if (await sourceFile.exists()) {
          final extension = sourcePaths[i].split('.').last;
          final destPath = '${measurementDir.path}/image_$i.$extension';
          await sourceFile.copy(destPath);
          storedPaths.add(destPath);
        }
      }
    } catch (e) {
      // Return whatever paths we managed to store
      // In production, log this error
    }

    return storedPaths;
  }

  /// Delete measurement images
  Future<void> deleteImages(String measurementId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final measurementDir = Directory('${appDir.path}/measurements/$measurementId');
      
      if (await measurementDir.exists()) {
        await measurementDir.delete(recursive: true);
      }
    } catch (_) {
      // Ignore errors during cleanup
    }
  }
}

