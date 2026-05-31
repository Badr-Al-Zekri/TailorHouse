import 'dart:typed_data';

import 'package:tailorhouse/src/core/utils/result.dart';
import 'package:tailorhouse/src/features/measurement/domain/entities/body_measurement.dart';

/// Input data for AI measurement
class AiMeasurementInput {
  final List<Uint8List> photos; // front, side, back photos
  final double heightCm;
  final double weightKg;
  final String? gender;

  const AiMeasurementInput({
    required this.photos,
    required this.heightCm,
    required this.weightKg,
    this.gender,
  });
}

/// Result from AI measurement processing
class AiMeasurementResult {
  final Map<String, BodyMeasurement> measurements;
  final double overallConfidence;
  final String? processingNotes;

  const AiMeasurementResult({
    required this.measurements,
    required this.overallConfidence,
    this.processingNotes,
  });

  /// Check if result has high overall confidence
  bool get isHighConfidence => overallConfidence >= 0.75;

  /// Get measurements with low confidence that may need review
  List<BodyMeasurement> get lowConfidenceMeasurements {
    return measurements.values
        .where((m) => m.confidence != null && m.confidence! < 0.7)
        .toList();
  }
}

/// Abstract gateway for AI body measurement
/// Allows swapping AI implementations without changing domain/app logic
abstract class MeasurementAiGateway {
  /// Process photos and return estimated measurements
  FutureResult<AiMeasurementResult> estimateMeasurements(
    AiMeasurementInput input,
  );

  /// Validate photos before processing
  FutureResult<PhotoValidationResult> validatePhotos(List<Uint8List> photos);

  /// Check if AI service is available
  Future<bool> isAvailable();

  /// Get the AI engine version/info
  String get engineInfo;
}

/// Result of photo validation
class PhotoValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<PhotoIssue> issues;

  const PhotoValidationResult({
    required this.isValid,
    this.errors = const [],
    this.issues = const [],
  });

  factory PhotoValidationResult.valid() => const PhotoValidationResult(
        isValid: true,
      );

  factory PhotoValidationResult.invalid(List<String> errors) =>
      PhotoValidationResult(
        isValid: false,
        errors: errors,
      );
}

/// Specific issues with uploaded photos
enum PhotoIssue {
  tooBlurry,
  tooDark,
  tooBright,
  personNotDetected,
  multiplePeopleDetected,
  incorrectPose,
  partiallyVisible,
  lowResolution,
}

