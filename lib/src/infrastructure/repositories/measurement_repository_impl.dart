import 'package:tailorhouse/src/domain/domain.dart';
import 'package:tailorhouse/src/infrastructure/models/measurement_model.dart';
import 'package:tailorhouse/src/infrastructure/datasources/local/measurement_local_datasource.dart';

/// Implementation of MeasurementRepository using local storage
class MeasurementRepositoryImpl implements MeasurementRepository {
  final MeasurementLocalDataSource _localDataSource;

  MeasurementRepositoryImpl({required MeasurementLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Measurement> create(Measurement measurement) async {
    final model = MeasurementModel.fromEntity(measurement);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<Measurement?> getById(String id) async {
    final model = _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<Measurement?> getByOrderId(String orderId) async {
    final model = _localDataSource.getByOrderId(orderId);
    return model?.toEntity();
  }

  @override
  Future<Measurement> update(Measurement measurement) async {
    final model = MeasurementModel.fromEntity(measurement);
    final savedModel = await _localDataSource.save(model);
    return savedModel.toEntity();
  }

  @override
  Future<void> delete(String id) async {
    // Delete images first
    await _localDataSource.deleteImages(id);
    // Then delete measurement
    await _localDataSource.delete(id);
  }

  @override
  Future<List<String>> storeImages(
    String measurementId,
    List<String> imagePaths,
  ) async {
    return await _localDataSource.storeImages(measurementId, imagePaths);
  }

  @override
  Future<void> deleteImages(String measurementId) async {
    await _localDataSource.deleteImages(measurementId);
  }
}

