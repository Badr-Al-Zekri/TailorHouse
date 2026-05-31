import 'dart:typed_data';

import 'package:tailorhouse/src/core/constants/app_constants.dart';
import 'package:tailorhouse/src/core/error/failures.dart';
import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/measurement_profile.dart';
import 'package:tailorhouse/src/features/measurement/domain/repositories/measurement_ai_gateway.dart';
import 'package:tailorhouse/src/features/measurement/domain/repositories/measurement_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for running AI-assisted body measurement
class RunAiMeasurementUseCase {
  final MeasurementRepository _repository;
  final MeasurementAiGateway _aiGateway;
  final Uuid _uuid;

  RunAiMeasurementUseCase(
    this._repository,
    this._aiGateway, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  /// Execute AI measurement from photos
  FutureResult<MeasurementProfile> call(RunAiMeasurementParams params) async {
    // Validate input
    final validationError = _validateInput(params);
    if (validationError != null) {
      return Results.failure(validationError);
    }

    // Check if AI is available
    final isAvailable = await _aiGateway.isAvailable();
    if (!isAvailable) {
      return Results.failure(const AiProcessingFailure(
        message: 'AI measurement service is currently unavailable',
      ));
    }

    // Validate photos first
    final validationResult = await _aiGateway.validatePhotos(params.photos);
    if (validationResult.isFailure) {
      return Results.failure(validationResult.failureOrNull!);
    }

    final photoValidation = validationResult.successOrNull!;
    if (!photoValidation.isValid) {
      return Results.failure(InvalidImageFailure(
        message: photoValidation.errors.join('. '),
      ));
    }

    // Run AI measurement
    final aiInput = AiMeasurementInput(
      photos: params.photos,
      heightCm: params.height,
      weightKg: params.weight,
      gender: params.gender,
    );

    final aiResult = await _aiGateway.estimateMeasurements(aiInput);
    if (aiResult.isFailure) {
      return Results.failure(aiResult.failureOrNull!);
    }

    final measurements = aiResult.successOrNull!;

    // Create profile from AI results
    final now = DateTime.now();
    final profile = MeasurementProfile(
      id: _uuid.v4(),
      userId: params.userId,
      name: params.name.trim(),
      height: params.height,
      weight: params.weight,
      measurements: measurements.measurements,
      source: MeasurementSource.aiAssisted,
      createdAt: now,
      updatedAt: now,
      isSynced: false,
    );

    // Save to repository
    return _repository.createMeasurementProfile(profile);
  }

  Failure? _validateInput(RunAiMeasurementParams params) {
    if (params.photos.length < AppConstants.aiMinPhotos) {
      return ValidationFailure(
        message:
            'At least ${AppConstants.aiMinPhotos} photos are required for AI measurement',
      );
    }

    if (params.photos.length > AppConstants.aiMaxPhotos) {
      return ValidationFailure(
        message:
            'Maximum ${AppConstants.aiMaxPhotos} photos allowed',
      );
    }

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

    return null;
  }
}

/// Parameters for AI measurement use case
class RunAiMeasurementParams {
  final String userId;
  final String name;
  final List<Uint8List> photos;
  final double height;
  final double weight;
  final String? gender;

  const RunAiMeasurementParams({
    required this.userId,
    required this.name,
    required this.photos,
    required this.height,
    required this.weight,
    this.gender,
  });
}

