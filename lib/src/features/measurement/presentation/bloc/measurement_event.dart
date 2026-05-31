part of 'measurement_bloc.dart';

/// Base class for measurement events
abstract class MeasurementEvent extends Equatable {
  const MeasurementEvent();

  @override
  List<Object?> get props => [];
}

/// Event to add measurements to an order
class AddMeasurementEvent extends MeasurementEvent {
  final String orderId;
  final double? height;
  final double? shoulder;
  final double? chest;
  final double? waist;
  final double? hips;
  final double? sleeveLength;
  final double? trouserLength;
  final double? thobeLength;
  final double? neck;
  final double? armLength;
  final double? wrist;
  final double? inseam;
  final Map<String, double>? customMeasurements;
  final List<String>? imagePaths;
  final bool isAiMeasurement;
  final Map<String, double>? aiConfidenceScores;
  final String measuredByUserId;
  final String? notes;

  const AddMeasurementEvent({
    required this.orderId,
    this.height,
    this.shoulder,
    this.chest,
    this.waist,
    this.hips,
    this.sleeveLength,
    this.trouserLength,
    this.thobeLength,
    this.neck,
    this.armLength,
    this.wrist,
    this.inseam,
    this.customMeasurements,
    this.imagePaths,
    this.isAiMeasurement = false,
    this.aiConfidenceScores,
    required this.measuredByUserId,
    this.notes,
  });

  @override
  List<Object?> get props => [
        orderId,
        height,
        shoulder,
        chest,
        waist,
        hips,
        sleeveLength,
        trouserLength,
        thobeLength,
        neck,
        armLength,
        wrist,
        inseam,
        customMeasurements,
        imagePaths,
        isAiMeasurement,
        aiConfidenceScores,
        measuredByUserId,
        notes,
      ];
}

/// Event to get measurement for an order
class GetMeasurementEvent extends MeasurementEvent {
  final String orderId;

  const GetMeasurementEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Event to store measurement images
class StoreMeasurementImagesEvent extends MeasurementEvent {
  final String measurementId;
  final List<String> imagePaths;

  const StoreMeasurementImagesEvent({
    required this.measurementId,
    required this.imagePaths,
  });

  @override
  List<Object?> get props => [measurementId, imagePaths];
}

