import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/core/error/failures.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/body_measurement.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/measurement_profile.dart';
import 'package:tailorhouse/src/features/measurement/domain/repositories/measurement_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for creating a manual measurement profile
class CreateManualProfileUseCase {
  final MeasurementRepository _repository;
  final Uuid _uuid;

  CreateManualProfileUseCase(
    this._repository, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  /// Execute creation of a manual measurement profile
  FutureResult<MeasurementProfile> call(CreateManualProfileParams params) async {
    // Validate input
    final validationError = _validateInput(params);
    if (validationError != null) {
      return Results.failure(validationError);
    }

    // Create measurement map
    final measurements = <String, BodyMeasurement>{};
    final now = DateTime.now();

    for (final entry in params.measurements.entries) {
      measurements[entry.key] = BodyMeasurement(
        bodyPart: entry.key,
        value: entry.value,
        measuredAt: now,
        isManuallyEdited: true,
      );
    }

    // Create the profile
    final profile = MeasurementProfile(
      id: _uuid.v4(),
      userId: params.userId,
      name: params.name.trim(),
      height: params.height,
      weight: params.weight,
      measurements: measurements,
      source: MeasurementSource.manual,
      createdAt: now,
      updatedAt: now,
      isSynced: false,
    );

    return _repository.createMeasurementProfile(profile);
  }

  Failure? _validateInput(CreateManualProfileParams params) {
    if (params.name.isEmpty) {
      return const ValidationFailure(message: 'Profile name is required');
    }

    if (params.height < AppConstants.minHeight ||
        params.height > AppConstants.maxHeight) {
      return ValidationFailure(
        message:
            'Height must be between ${AppConstants.minHeight} and ${AppConstants.maxHeight} cm',
      );
    }

    if (params.weight < AppConstants.minWeight ||
        params.weight > AppConstants.maxWeight) {
      return ValidationFailure(
        message:
            'Weight must be between ${AppConstants.minWeight} and ${AppConstants.maxWeight} kg',
      );
    }

    // Validate individual measurements
    for (final entry in params.measurements.entries) {
      final bodyPart = BodyParts.getByKey(entry.key);
      if (bodyPart != null && !bodyPart.isValidValue(entry.value)) {
        return ValidationFailure(
          message:
              '${bodyPart.displayName} must be between ${bodyPart.minValue} and ${bodyPart.maxValue} cm',
        );
      }
    }

    // Check for essential measurements
    const essential = ['chest', 'waist', 'hip', 'shoulder'];
    final missingEssential =
        essential.where((part) => !params.measurements.containsKey(part));
    if (missingEssential.isNotEmpty) {
      return ValidationFailure(
        message:
            'Please provide measurements for: ${missingEssential.join(', ')}',
      );
    }

    return null;
  }
}

/// Parameters for creating a manual measurement profile
class CreateManualProfileParams {
  final String userId;
  final String name;
  final double height;
  final double weight;
  final Map<String, double> measurements;

  const CreateManualProfileParams({
    required this.userId,
    required this.name,
    required this.height,
    required this.weight,
    required this.measurements,
  });
}

