import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/measurement_profile.dart';
import 'package:tailorhouse/src/features/measurement/domain/repositories/measurement_repository.dart';

/// Use case for getting all measurement profiles
class GetMeasurementProfilesUseCase {
  final MeasurementRepository _repository;

  GetMeasurementProfilesUseCase(this._repository);

  /// Get all measurement profiles for the current user
  FutureResult<List<MeasurementProfile>> call() {
    return _repository.getMeasurementProfiles();
  }

  /// Watch measurement profiles for reactive UI
  Stream<List<MeasurementProfile>> watch() {
    return _repository.watchMeasurementProfiles();
  }
}

/// Use case for getting a single measurement profile
class GetMeasurementProfileUseCase {
  final MeasurementRepository _repository;

  GetMeasurementProfileUseCase(this._repository);

  /// Get a specific measurement profile by ID
  FutureResult<MeasurementProfile> call(String id) {
    return _repository.getMeasurementProfile(id);
  }
}

/// Use case for getting the most recent measurement profile
class GetMostRecentProfileUseCase {
  final MeasurementRepository _repository;

  GetMostRecentProfileUseCase(this._repository);

  /// Get the most recently created/updated measurement profile
  FutureResult<MeasurementProfile?> call() {
    return _repository.getMostRecentProfile();
  }
}

/// Use case for deleting a measurement profile
class DeleteMeasurementProfileUseCase {
  final MeasurementRepository _repository;

  DeleteMeasurementProfileUseCase(this._repository);

  /// Delete a measurement profile by ID
  FutureResult<void> call(String id) {
    return _repository.deleteMeasurementProfile(id);
  }
}

/// Use case for syncing measurement profiles
class SyncMeasurementsUseCase {
  final MeasurementRepository _repository;

  SyncMeasurementsUseCase(this._repository);

  /// Sync all local profiles with remote server
  FutureResult<void> call() {
    return _repository.syncProfiles();
  }
}

