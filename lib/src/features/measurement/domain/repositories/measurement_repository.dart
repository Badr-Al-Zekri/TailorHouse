import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/measurement_profile.dart';

/// Abstract repository for measurement operations
/// Implementation will handle offline-first sync
abstract class MeasurementRepository {
  /// Get all measurement profiles for the current user
  FutureResult<List<MeasurementProfile>> getMeasurementProfiles();

  /// Get a specific measurement profile by ID
  FutureResult<MeasurementProfile> getMeasurementProfile(String id);

  /// Create a new measurement profile
  FutureResult<MeasurementProfile> createMeasurementProfile(
    MeasurementProfile profile,
  );

  /// Update an existing measurement profile
  FutureResult<MeasurementProfile> updateMeasurementProfile(
    MeasurementProfile profile,
  );

  /// Delete a measurement profile
  FutureResult<void> deleteMeasurementProfile(String id);

  /// Sync local profiles with remote server
  FutureResult<void> syncProfiles();

  /// Get the most recent measurement profile
  FutureResult<MeasurementProfile?> getMostRecentProfile();

  /// Stream of measurement profiles (for reactive UI)
  Stream<List<MeasurementProfile>> watchMeasurementProfiles();
}

